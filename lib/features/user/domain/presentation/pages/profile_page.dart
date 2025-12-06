// ============================================
// UPDATED profile_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/presentation/widgets/base_page.dart';
import 'package:warshasy/core/route/app_routes.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/theme/app_shadows.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/core/utils/snackbar_utils.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/home/presentation/widgets/custom_scaffold.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late final _isOwnProfile;

  @override
  void initState() {
    super.initState();

    // Load user if viewing another profile
    // For own profile, user is already loaded in warshasy.dart
    final currentUserId = _getCurrentUserId(context);
    final targetUserId = widget.userId ?? currentUserId;
    sl<UserBloc>().add(LoadUserRequested(userId: targetUserId!));

    _isOwnProfile = targetUserId == currentUserId;
  }

  String? _getCurrentUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return authState.session.userId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: CustomerScaffold(
        appBar: _buildAppBar(context, _isOwnProfile),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            // Handle different states
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserLoaded) {
              //if (state.user.id == targetUserId) {
              return _ProfileContent(
                user: state.user,
                isOwnProfile: _isOwnProfile,
              );
              //}
            }

            if (state is UserUpdating) {
              // Show updating indicator while keeping UI responsive
              return _ProfileContent(
                user: state.user,
                isOwnProfile: _isOwnProfile,
                isUpdating: true,
              );
            }

            if (state is UserError) {
              return _buildErrorState(context, state, state.failure.message);
            }

            // If no user loaded yet, show loading
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isOwnProfile) {
    return AppBar(
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
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    UserError state,
    String targetUserId,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              state.failure.message,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<UserBloc>().add(
                  LoadUserRequested(userId: targetUserId, forceRefresh: true),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
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
  final bool isUpdating;

  const _ProfileContent({
    required this.user,
    required this.isOwnProfile,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            context.read<UserBloc>().add(RefreshUserRequested(userId: user.id));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 8),
                _buildInfoSection(context),
                if (user.bio != null && user.bio!.isNotEmpty)
                  _buildBioSection(context),
                _buildServicesSection(context),
                if (!isOwnProfile) _buildActionsSection(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Show updating indicator
        if (isUpdating)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.small),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'جاري التحديث...',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: theme.cardTheme.color),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft,
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.surface,
                  backgroundImage:
                      user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                  child:
                      user.avatarUrl == null
                          ? Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.textTertiary,
                          )
                          : null,
                ),
              ),
              if (isOwnProfile)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: AppShadows.subtle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18),
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () => _showAvatarOptions(context),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'عضو منذ ${_formatDate(user.createdAt!)}',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات الاتصال',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.phone,
            label: 'رقم الهاتف',
            value: user.phone,
            onTap: isOwnProfile ? null : () => _callUser(context),
          ),
          if (user.location != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.location_on,
              label: 'الموقع',
              value:
                  '${user.location!.city.arabicName} - ${user.location!.location}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBioSection(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'نبذة',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.bio!,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الخدمات المقدمة',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (isOwnProfile)
                TextButton.icon(
                  onPressed: () => context.pushNamed(AppRouteName.addService),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'لا توجد خدمات حالياً',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => _contactUser(context),
            icon: const Icon(Icons.message),
            label: const Text('إرسال رسالة'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _callUser(context),
            icon: const Icon(Icons.phone),
            label: const Text('اتصال هاتفي'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text('التقاط صورة'),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: AppColors.info,
                      ),
                    ),
                    title: const Text('اختيار من المعرض'),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement
                    },
                  ),
                  if (user.avatarUrl != null)
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: const Icon(Icons.delete, color: AppColors.error),
                      ),
                      title: const Text(
                        'حذف الصورة',
                        style: TextStyle(color: AppColors.error),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<UserBloc>().add(
                          DeleteAvatarRequested(userId: user.id),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }

  void _contactUser(BuildContext context) {
    context.push('/chat/${user.id}');
  }

  void _callUser(BuildContext context) {
    context.showInfoSnackBar('الاتصال بـ ${user.phone}');
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
    final textTheme = Theme.of(context).textTheme;

    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.chevron_left, color: AppColors.textTertiary),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: child,
      );
    }

    return child;
  }
}
