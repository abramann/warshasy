// ============================================
// STEP 3: DATA LAYER - REMOTE DATA SOURCE
// lib/features/auth/data/datasources/auth_remote_datasource.dart
// ============================================
// This talks directly to Supabase
// Handles all the network calls

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:warshasy/core/network/network.dart';
import 'package:warshasy/core/env/call_me_bot.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/data/models/user_model.dart';
import 'package:warshasy/features/static_data/domain/entites/location.dart';
import '../../../../core/errors/errors.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:http/http.dart' as http;
import 'package:warshasy/features/user/domain/entities/user.dart' as Warsha;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<void> signOut();

  // CHANGED: now returns the otpSessionId (UUID from DB)
  Future<String> sendVerificationCode({required String phone});

  // CHANGED: we don't need phone here anymore, we need:
  // - otpSessionId: the row in otp_sessions
  // - code: what the user typed
  // - deviceId: your per-device identifier (for device_sessions)
  Future<AuthSession> verifyCodeAndCreateSession({
    required String otpSessionId,
    required String code,
    required String deviceId,
  });

  Future<AuthSession?> restoreSession({
    required String deviceId,
    required String sessionToken,
  });

  Future<void> invalidateSession({
    required String deviceId,
    required String sessionToken,
  });

  Stream<AuthState> get authStateChanges;
}

// Implementation - actual code that does the work
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;
  final network = sl<Network>();

  AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<AuthSession?> restoreSession({
    required String deviceId,
    required String sessionToken,
  }) async {
    final nowIso = DateTime.now().toIso8601String();

    final result =
        await supabase
            .from('device_sessions')
            .select('*, users(*)')
            .eq('device_id', deviceId)
            .eq('session_token', sessionToken)
            .isFilter('revoked_at', null)
            .or('expires_at.is.null,expires_at.gt.$nowIso')
            .maybeSingle();

    if (result == null) return null;

    final userJson = result['users'] as Map<String, dynamic>;
    final userId = result['user_id'] as String;
    final fullName = userJson['full_name'] as String?;
    final expiresAt =
        result['expires_at'] != null
            ? DateTime.parse(result['expires_at'])
            : null;

    return AuthSession(
      userId: userId,
      deviceId: deviceId,
      sessionToken: sessionToken,
      expiresAt: expiresAt,
    );
  }

  @override
  Future<void> invalidateSession({
    required String deviceId,
    required String sessionToken,
  }) async {
    await supabase
        .from('device_sessions')
        .update({'revoked_at': DateTime.now().toIso8601String()})
        .eq('device_id', deviceId)
        .eq('session_token', sessionToken);
  }

  @override
  Future<void> signOut() async {
    /* await network.guard(() async {
      await supabase
          .from('auth_sessions')
          .update({'last_logout': DateTime.now().toIso8601String()})
          .eq('phone', authSession.phone!);
    });*/
    // No server-side sign-out needed for this simple implementation
    // TODO: Later we can revoke tokens or sessions if needed
  }

  @override
  @override
  Future<AuthSession> verifyCodeAndCreateSession({
    required String otpSessionId,
    required String code,
    required String deviceId,
  }) async {
    final now = DateTime.now();
    final nowIso = now.toIso8601String();

    // 1) Get a valid OTP row BY ID + CODE (no phone needed here)
    final otpRow =
        await supabase
            .from('otp_sessions')
            .select()
            .eq('id', otpSessionId)
            .eq('otp_code', code)
            //   .isFilter('used_at', null)
            //   .gt('expires_at', nowIso)
            .maybeSingle();

    if (otpRow == null) {
      throw Exception('Invalid or expired code'); // map to Failure later
    }

    final phone = otpRow['phone'] as String;

    // 2) Get or create user by phone
    final user =
        (await getUser(phone: phone)) ?? (await createUser(phone: phone));

    final userId = user.id;

    // 3) Link OTP to user and mark as used
    await supabase
        .from('otp_sessions')
        .update({'used_at': nowIso, 'user_id': userId})
        .eq('id', otpSessionId);

    // 4) Generate a session token
    final sessionToken = _generateSessionToken();
    final expiresAt = now.add(const Duration(days: 30));

    // 5) Upsert device session (same as before, but using deviceId param)
    await supabase.from('device_sessions').upsert({
      'user_id': userId,
      'device_id': deviceId,
      'session_token': sessionToken,
      'created_at': nowIso,
      'expires_at': expiresAt.toIso8601String(),
      'revoked_at': null,
    }, onConflict: 'user_id,device_id');

    // 6) Return AuthSession
    return AuthSession(
      userId: userId,
      deviceId: deviceId,
      sessionToken: sessionToken,
      expiresAt: expiresAt,
    );
  }

  Future<Warsha.User> createUser({required String phone}) async {
    // Create with minimal info
    final json =
        await supabase
            .from('users')
            .insert({
              'full_name': 'مستخدم جديد',
              'phone': phone,
              'city_id': 1, // Default city
            })
            .select()
            .single();

    return UserModel.fromJson(json);
  }

  Future<Warsha.User?> getUser({String? userId, String? phone}) async {
    late final res;
    if (userId != null) {
      res =
          await supabase.from('users').select().eq('id', userId).maybeSingle();
      if (res == null) return null;
    } else if (phone != null) {
      res =
          await supabase
              .from('users')
              .select()
              .eq('phone', phone)
              .maybeSingle();
      if (res == null) return null;
    }
    return UserModel.fromJson(res);
  }

  String _generateSessionToken() {
    // In prod, use secure random bytes / uuid package
    final rand = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < 32; i++) {
      buffer.write(rand.nextInt(16).toRadixString(16)); // hex char
    }
    return buffer.toString();
  }

  @override
  Future<String> sendVerificationCode({required String phone}) async {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 5));
    final otp = _generateOtp(length: 4);

    // 1) Delete old OTPs for this phone (optional but you already do it)
    await supabase.from('otp_sessions').delete().eq('phone', phone);

    // 2) Insert new row and get its id
    final inserted =
        await supabase
            .from('otp_sessions')
            .insert({
              'phone': phone,
              'otp_code': otp,
              'expires_at': expiresAt.toIso8601String(),
            })
            .select('id') // only need id
            .single();

    final otpSessionId = inserted['id'] as String;

    // 3) Send via WhatsApp / SMS (still optional)
    // await _sendWhatsAppCode(phone, otp);

    // 4) Return the OTP session id to client
    return otpSessionId;
  }

  String _generateOtp({int length = 4}) {
    if (kDebugMode) {
      return '1234'; // Fixed OTP for testing
    }

    final rand = Random.secure();
    final min = pow(10, length - 1).toInt();
    final max = pow(10, length).toInt() - 1;
    return (min + rand.nextInt(max - min)).toString();
  }

  @override
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  Future<void> _sendWhatsAppCode(String phone, String code) async {
    /*    final message = Uri.encodeComponent(
      " رمز التفعيل الخاص بك لتطبيق ورشة هو: $code",
    );

    final url = AuthConfig.callMeBotUrl(phone, code, message);

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        print("✅ WhatsApp message sent successfully!");
      } else {
        throw AuthException('Failed to send WhatsApp message: ${res.body}');
      }
    } catch (e) {
      throw AuthException('Failed to send WhatsApp message: $e');
    }*/
  }
}
