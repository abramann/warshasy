// ============================================
// 1. PROFILE PAGE (View User Profile)
// lib/features/user/presentation/pages/profile_page.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/config/injection_container.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/presentation/blocs/user_bloc.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  @override
  State<StatefulWidget> createState() => ProfilePageState();

  const ProfilePage({super.key, required this.userId});
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Determine if viewing own profile or another user's profile
    String targetUserId = widget.userId!;
    final isOwnProfile = sl<AuthSession>().phone == targetUserId;

    return BlocProvider(
      create:
          (context) =>
              sl<UserBloc>()..add(
                LoadUserRequested(userId: targetUserId, context: context),
              ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isOwnProfile ? 'ملفي الشخصي' : 'الملف الشخصي'),
          actions:
              isOwnProfile
                  ? [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => context.push('/profile/profile-setup'),
                      tooltip: 'تعديل الملف الشخصي',
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => context.push('/settings'),
                      tooltip: 'الإعدادات',
                    ),
                  ]
                  : null,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserLoaded) {
              return _ProfileContent(
                user: state.user,
                isOwnProfile: isOwnProfile,
              );
            }

            if (state is UserError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.failure.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<UserBloc>().add(
                          LoadUserRequested(
                            userId: targetUserId,
                            context: context,
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ============================================
// Profile Content Widget
// ============================================

class _ProfileContent extends StatelessWidget {
  final User user;
  final bool isOwnProfile;

  const _ProfileContent({required this.user, required this.isOwnProfile});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(
          LoadUserRequested(userId: user.phone, context: context),
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            const Divider(height: 1),

            // Info Section
            _buildInfoSection(context),

            const Divider(height: 1),

            // Bio Section
            if (user.bio != null && user.bio!.isNotEmpty)
              _buildBioSection(context),

            // Services Section (if user offers services)
            _buildServicesSection(context),

            // Actions Section
            if (!isOwnProfile) _buildActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                child:
                    user.avatarUrl == null
                        ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade400,
                        )
                        : null,
              ),
              if (isOwnProfile)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      onPressed: () => _showAvatarOptions(context),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            user.fullName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Account Age
          Text(
            'عضو منذ ${_formatDate(user.createdAt)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات الاتصال',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Phone
          _InfoRow(
            icon: Icons.phone,
            label: 'رقم الهاتف',
            value: user.phone,
            onTap: isOwnProfile ? null : () => _callUser(context),
          ),

          const SizedBox(height: 12),

          // City
          if (user.city != null)
            _InfoRow(
              icon: Icons.location_on,
              label: 'المدينة',
              value: user.city!.name,
            ),
        ],
      ),
    );
  }

  Widget _buildBioSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نبذة',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(user.bio!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    // TODO: Fetch user services
    // For now, show placeholder
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الخدمات المقدمة',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (isOwnProfile)
                TextButton.icon(
                  onPressed: () => context.push('/services/add'),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة خدمة'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد خدمات حالياً',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => _contactUser(context),
            icon: const Icon(Icons.message),
            label: const Text('إرسال رسالة'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _callUser(context),
            icon: const Icon(Icons.phone),
            label: const Text('اتصال هاتفي'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('التقاط صورة'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement camera capture
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('اختيار من المعرض'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement gallery picker
                  },
                ),
                if (user.avatarUrl != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      'حذف الصورة',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<UserBloc>().add(
                        DeleteAvatarRequested(
                          userId: user.phone,
                          context: context,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
    );
  }

  void _contactUser(BuildContext context) {
    // TODO: Navigate to chat
    context.push('/chat/${user.phone}');
  }

  void _callUser(BuildContext context) {
    // TODO: Implement phone call
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('الاتصال بـ ${user.phone}')));
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 30) {
      return '${difference.inDays} يوم';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else {
      return '${(difference.inDays / 365).floor()} سنة';
    }
  }
}

// ============================================
// Info Row Widget
// ============================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        if (onTap != null)
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: child,
        ),
      );
    }

    return child;
  }
}
