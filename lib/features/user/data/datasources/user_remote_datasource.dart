// ============================================
// lib/features/user/data/datasources/user_remote_datasource.dart
// ============================================
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:warshasy/features/auth/auth.dart';
import '../../../../core/network/network.dart';
import '../../../../core/utils/injection_container.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String userId);
  Future<UserModel?> getUserByPhone(String phone);
  Future<UserModel> createUser({
    required String phone,
    required String fullName,
    Location? location,
    String? bio,
  });
  Future<UserModel> updateUser({required User user});
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  });
  Future<void> deleteAvatar(String userId);
  Future<void> deactivateUser(String userId);
  Future<void> reactivateUser(String userId);
  Future<bool> phoneExists(String phone);
  Future<List<UserModel>> searchUsers({
    String? query,
    Location? location,
    int? limit,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final sb.SupabaseClient supabaseClient;
  final network = sl<Network>();

  UserRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> getUserById(String userId) async {
    return await network.guard(() async {
      final response =
          await supabaseClient.from('users').select().eq('id', userId).single();
      return UserModel.fromJson(response);
    });
  }

  @override
  Future<UserModel?> getUserByPhone(String phone) async {
    return await network.guard(() async {
      final response =
          await supabaseClient
              .from('users')
              .select()
              .eq('phone', phone)
              .maybeSingle();
      if (response == null) return null;
      return UserModel.fromJson(response);
    });
  }

  @override
  Future<UserModel> createUser({
    required String phone,
    required String fullName,
    Location? location,
    String? bio,
  }) async {
    return await network.guard(() async {
      final userData = {
        'phone': phone,
        'full_name': fullName,
        if (location != null) ...{
          'city': location.city.arabicName,
          'location': location.location,
        },
        if (bio != null) 'bio': bio,
      };

      final response =
          await supabaseClient.from('users').insert(userData).select().single();

      return UserModel.fromJson(response);
    });
  }

  @override
  Future<UserModel> updateUser({required User user}) async {
    return await network.guard(() async {
      final updateData = <String, dynamic>{};

      final userId = user.id;
      final fullName = user.fullName;
      final phone = user.phone;
      final userLocation = user.location;
      final avatarUrl = user.avatarUrl;
      final bio = user.bio;
      final updatedAt = user.updatedAt?.toIso8601String();
      updateData['full_name'] = fullName;
      updateData['phone'] = phone;
      if (userLocation != null) {
        updateData['city'] = userLocation.city.arabicName;
        updateData['location'] = userLocation.location;
      }
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (bio != null) updateData['bio'] = bio;
      if (updatedAt != null) updateData['updated_at'] = updatedAt;

      final response =
          await supabaseClient
              .from('users')
              .update(updateData)
              .eq('id', userId)
              .select()
              .single();

      return UserModel.fromJson(response);
    });
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    return await network.guard(() async {
      final file = File(filePath);
      final fileExt = filePath.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final storagePath = 'avatars/$fileName';

      await supabaseClient.storage
          .from('user-avatars')
          .upload(
            storagePath,
            file,
            fileOptions: const sb.FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      final publicUrl = supabaseClient.storage
          .from('user-avatars')
          .getPublicUrl(storagePath);

      await supabaseClient
          .from('users')
          .update({'avatar_url': publicUrl})
          .eq('id', userId);

      return publicUrl;
    });
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    return await network.guard(() async {
      final user = await getUserById(userId);
      if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
        final uri = Uri.parse(user.avatarUrl!);
        final pathSegments = uri.pathSegments;

        if (pathSegments.isNotEmpty) {
          final filePath = pathSegments
              .sublist(pathSegments.indexOf('avatars'))
              .join('/');
          await supabaseClient.storage.from('user-avatars').remove([filePath]);
        }
      }
      await supabaseClient
          .from('users')
          .update({'avatar_url': null})
          .eq('id', userId);
    });
  }

  @override
  Future<void> deactivateUser(String userId) async {
    return await network.guard(() async {
      await supabaseClient
          .from('users')
          .update({'is_active': false})
          .eq('id', userId);
    });
  }

  @override
  Future<void> reactivateUser(String userId) async {
    return await network.guard(() async {
      await supabaseClient
          .from('users')
          .update({'is_active': true})
          .eq('id', userId);
    });
  }

  @override
  Future<bool> phoneExists(String phone) async {
    return await network.guard(() async {
      final response =
          await supabaseClient
              .from('users')
              .select('id')
              .eq('phone', phone)
              .maybeSingle();
      return response != null;
    });
  }

  @override
  Future<List<UserModel>> searchUsers({
    String? query,
    Location? location,
    int? limit,
  }) async {
    return await network.guard(() async {
      var queryBuilder = supabaseClient
          .from('users')
          .select()
          .eq('is_active', true);

      if (location != null) {
        queryBuilder = queryBuilder.eq('city', location.city.arabicName);
        queryBuilder = queryBuilder.eq('location', location.location);
      }

      if (query != null && query.isNotEmpty) {
        queryBuilder = queryBuilder.or(
          'full_name.ilike.%$query%,phone.ilike.%$query%',
        );
      }

      var queryBuilder2 = queryBuilder.order('created_at', ascending: false);

      if (limit != null && limit > 0) {
        queryBuilder2 = queryBuilder2.limit(limit);
      }

      final response = await queryBuilder2;

      return (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    });
  }
}
