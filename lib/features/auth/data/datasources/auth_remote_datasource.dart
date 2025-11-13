// ============================================
// STEP 3: DATA LAYER - REMOTE DATA SOURCE
// lib/features/auth/data/datasources/auth_remote_datasource.dart
// ============================================
// This talks directly to Supabase
// Handles all the network calls

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warshasy/core/network/network.dart';
import 'package:warshasy/features/auth/data/constants/auth_constants.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/data/models/user_model.dart';
import '../../../../core/errors/errors.dart';
import 'package:warshasy/core/config/injection_container.dart';
import 'package:http/http.dart' as http;
import 'package:warshasy/features/user/domain/entities/user.dart' as Warsha;

// Abstract class defines what operations we can do
abstract class AuthRemoteDataSource {
  Future<AuthSession> signInWithPhone(String phone, String code);
  Future<void> signOut();
  Future<void> sendVerificationCode({required String phone});
  Stream<AuthState> get authStateChanges;
}

// Implementation - actual code that does the work
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;
  final network = sl<Network>();

  AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<AuthSession> signInWithPhone(String phone, String code) async {
    return await network.guard(() async {
      final res =
          await supabase
              .from('auth_sessions')
              .select()
              .eq('phone', phone)
              .single();

      if (code != res['code']) throw AuthenticationException('كود تحقق خاطئ');
      /*await supabase
          .from('auth_sessions')
          .update({'last_active': DateTime.now().toIso8601String()})
          .eq('phone', phone);*/
      final res2 =
          await supabase.from('users').select().eq('phone', phone).single();
      return AuthSession(
        phone: phone,
        otpCode: int.parse(code),
        user: UserModel.fromJson(res2),
      );
    });
  }

  @override
  Future<void> signOut() async {
    await network.guard(() async {
      final authSession = sl<AuthSession>();
      await supabase
          .from('auth_sessions')
          .update({'last_logout': DateTime.now().toIso8601String()})
          .eq('phone', authSession.phone!);
      return true;
    });
  }

  @override
  Future<void> sendVerificationCode({required String phone}) async {
    return await network.guard(() async {
      // توليد كود بسيط (مثلاً 4 أرقام)
      final code =
          (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

      // حفظ الكود مؤقتًا في جدول
      final isAlreadyExist =
          (await supabase.from('auth_sessions').select().eq('phone', phone)
                  as List<dynamic>)
              .isNotEmpty;

      if (isAlreadyExist) {
        await supabase
            .from('auth_sessions')
            .update({
              'code': code,
              'created_at': DateTime.now().toIso8601String(),
            })
            .eq('phone', phone);
      } else {
        await supabase.from('auth_sessions').insert({
          'phone': phone,
          'code': code,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      await _sendWhatsAppCode(phone, code);
    });
  }

  @override
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  Future<void> _sendWhatsAppCode(String phone, String code) async {
    return;
    final message = Uri.encodeComponent(
      " رمز التفعيل الخاص بك لتطبيق ورشة هو: $code",
    );

    final url = AuthConstants.callMeBotUrl(phone, code, message);

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        print("✅ WhatsApp message sent successfully!");
      } else {
        throw AuthException('Failed to send WhatsApp message: ${res.body}');
      }
    } catch (e) {
      throw AuthException('Failed to send WhatsApp message: $e');
    }
  }
}
