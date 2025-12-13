import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/presentation/widgets/base_page.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/theme/app_shadows.dart';
import 'package:warshasy/core/utils/snackbar_utils.dart';
import 'package:warshasy/features/home/presentation/widgets/common_widgets.dart';
import 'package:warshasy/features/home/presentation/widgets/location_selector.dart';
import 'package:warshasy/features/static_data/domain/entites/location.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/current_user_bloc/current_user_bloc.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  Location? _selectedLocation;
  User? _currentUser;
  bool get _isFormValid => _selectedLocation != null;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _loadCurrentUser() {
    final userState = context.read<CurrentUserBloc>().state;
    if (userState is CurrentUserLoaded) {
      _initializeUserData(userState.user);
    }
  }

  void _initializeUserData(User user) {
    setState(() {
      _currentUser = user;
      _nameController.text = user.fullName;
      _bioController.text = user.bio ?? '';
      _selectedLocation = user.location;
    });
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate() ||
        _currentUser == null ||
        !_isFormValid) {
      return;
    }

    final updatedUser = _currentUser!.copyWith(
      fullName: _nameController.text.trim(),
      location: _selectedLocation!,
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      updatedAt: DateTime.now(),
    );

    context.read<CurrentUserBloc>().add(UpdateCurrentUser(user: updatedUser));
  }

  void _updateLocation({int? cityId, int? regionId}) {
    setState(() {
      if (cityId != null) {
        _selectedLocation = Location(cityId: cityId);
      } else if (regionId != null && _selectedLocation != null) {
        _selectedLocation = Location(
          cityId: _selectedLocation!.cityId,
          regionId: regionId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BasePage(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CommonWidgets.buildDefaultAppBar(
          context,
          title: l.profileSetupTitle,
        ),
        body: BlocConsumer<CurrentUserBloc, CurrentUserState>(
          listener: _handleUserStateChanges,
          builder: (context, state) {
            if (_currentUser == null && state is CurrentUserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final isUpdating = state is CurrentUserUpdating;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAvatarSection(context, isUpdating),
                  const SizedBox(height: 24),
                  _buildFormCard(context, isUpdating),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, isUpdating),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, bool isDisabled) {
    return Center(
      child: Stack(
        children: [
          BlocBuilder<CurrentUserBloc, CurrentUserState>(
            builder: (context, state) {
              final avatarUrl = _getAvatarUrl(state);

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft,
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.surface,
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.textTertiary,
                        )
                      : null,
                ),
              );
            },
          ),
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
                onPressed: isDisabled ? null : _showAvatarOptions,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _getAvatarUrl(CurrentUserState state) {
    if (state is CurrentUserLoaded) {
      return state.user.avatarUrl;
    } else if (state is CurrentUserUpdating) {
      return _currentUser?.avatarUrl;
    }
    return null;
  }

  Widget _buildFormCard(BuildContext context, bool isUpdating) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(textTheme, l.fullNameLabel, isRequired: true, l: l),
          const SizedBox(height: 8),
          _buildNameField(textTheme, isUpdating, l),
          const SizedBox(height: 20),
          _buildSectionTitle(textTheme, l.locationLabel, isRequired: true, l: l),
          const SizedBox(height: 12),
          _buildLocationSection(isUpdating),
          const SizedBox(height: 20),
          _buildSectionTitle(textTheme, l.bioLabel, isRequired: false, l: l),
          const SizedBox(height: 8),
          _buildBioField(textTheme, isUpdating, l),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    TextTheme textTheme,
    String title, {
    required bool isRequired,
    required AppLocalizations l,
  }) {
    final suffix = isRequired ? ' *' : ' ';
    return Text(
      '',
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildNameField(
    TextTheme textTheme,
    bool isUpdating,
    AppLocalizations l,
  ) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: l.fullNameHint,
        hintStyle: TextStyle(color: AppColors.textTertiary),
        prefixIcon: Icon(Icons.person, color: AppColors.textTertiary),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l.nameRequiredError;
        }
        if (value.trim().length < 3) {
          return l.nameTooShortError;
        }
        return null;
      },
      enabled: !isUpdating,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildLocationSection(bool isUpdating) {
    if (_selectedLocation == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        LocationSelector(
          type: LocationType.city,
          selectedId: _selectedLocation!.cityId,
          onSelected: (cityId) => _updateLocation(cityId: cityId),
        ),
        const SizedBox(height: 12),
        if (_selectedLocation!.cityId > 0)
          LocationSelector(
            type: LocationType.region,
            selectedId: _selectedLocation!.regionId ?? -1,
            parentCityId: _selectedLocation!.cityId,
            onSelected: (regionId) => _updateLocation(regionId: regionId),
          ),
      ],
    );
  }

  Widget _buildBioField(
    TextTheme textTheme,
    bool isUpdating,
    AppLocalizations l,
  ) {
    return TextFormField(
      controller: _bioController,
      decoration: InputDecoration(
        hintText: l.bioHint,
        hintStyle: TextStyle(color: AppColors.textTertiary),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Icon(Icons.info_outline, color: AppColors.textTertiary),
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        alignLabelWithHint: true,
      ),
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      maxLines: 4,
      maxLength: 500,
      enabled: !isUpdating,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isUpdating) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isUpdating || !_isFormValid ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.textTertiary.withOpacity(0.3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            child: isUpdating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    l.saveChanges,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: isUpdating ? null : () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            child: Text(
              l.cancel,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleUserStateChanges(BuildContext context, CurrentUserState state) {
    final l = AppLocalizations.of(context);
    if (state is CurrentUserLoaded && _currentUser == null) {
      _initializeUserData(state.user);
    } else if (state is CurrentUserUpdated) {
      context.showSuccessSnackBar(l.profileUpdated);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) context.pop();
      });
    } else if (state is CurrentUserError) {
      context.showErrorSnackBar(state.failure.message);
    }
  }

  void _showAvatarOptions() {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      builder: (context) => SafeArea(
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
              _buildAvatarOption(
                icon: Icons.camera_alt,
                title: l.takePhoto,
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              _buildAvatarOption(
                icon: Icons.photo_library,
                title: l.chooseFromGallery,
                color: AppColors.info,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_currentUser?.avatarUrl != null)
                _buildAvatarOption(
                  icon: Icons.delete,
                  title: l.deletePhoto,
                  color: AppColors.error,
                  onTap: () {
                    Navigator.pop(context);
                    _deleteAvatar();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color == AppColors.error ? color : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final l = AppLocalizations.of(context);
    if (_currentUser == null) return;

    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedImage != null && mounted) {
        context.read<CurrentUserBloc>().add(
              UploadCurrentUserAvatar(
                filePath: pickedImage.path,
              ),
            );
      }
    } catch (_) {
      if (mounted) {
        context.showErrorSnackBar(l.avatarUploadError);
      }
    }
  }

  void _deleteAvatar() {
    if (_currentUser != null) {
      context.read<CurrentUserBloc>().add(
            DeleteCurrentUserAvatar(userId: _currentUser!.id),
          );
    }
  }
}

// Extension for User copyWith if not already present
extension UserCopyWith on User {
  User copyWith({
    String? id,
    String? phone,
    String? fullName,
    Location? location,
    String? bio,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
