// ============================================
// UPDATED profile_setup_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/presentation/widgets/base_page.dart';
import 'package:warshasy/core/storage/repository/local_storage_reposotory.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  City? _selectedCity;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // Load current user data from the existing UserBloc state
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _setUser(userState.user);
    }
  }

  void _setUser(User user) {
    setState(() {
      _currentUser = user;
      _nameController.text = user.fullName;
      _bioController.text = user.bio ?? '';
      _selectedCity = user.city;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() && _currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        phone: _currentUser!.phone,
        fullName: _nameController.text.trim(),
        city: _selectedCity,
        bio:
            _bioController.text.trim().isEmpty
                ? null
                : _bioController.text.trim(),
        updatedAt: DateTime.now(),
      );
      context.read<UserBloc>().add(UpdateProfileRequested(user: updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الملف الشخصي'),
          actions: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                final isUpdating = state is UserUpdating;
                return TextButton(
                  onPressed: isUpdating ? null : _saveProfile,
                  child:
                      isUpdating
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text('حفظ', style: TextStyle(fontSize: 16)),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded && _currentUser == null) {
              // Initial load
              _setUser(state.user);
            } else if (state is UserUpdated) {
              // Update successful
              final storage = sl<LocalStorageRepository>();
              storage.saveUser(state.user);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تحديث البيانات بنجاح'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              // Navigate back after a short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) context.pop();
              });
            } else if (state is UserError) {
              // Show error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            // Show loading only on initial load
            if (_currentUser == null && state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final isUpdating = state is UserUpdating;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Avatar Section
                  _buildAvatarSection(context, isUpdating),
                  const SizedBox(height: 32),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل *',
                      hintText: 'أدخل اسمك الكامل',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      if (value.trim().length < 3) {
                        return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                      }
                      return null;
                    },
                    enabled: !isUpdating,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // City Dropdown
                  DropdownButtonFormField<City>(
                    value: _selectedCity,
                    decoration: const InputDecoration(
                      labelText: 'المدينة',
                      hintText: 'اختر مدينتك',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    items:
                        City.values.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city.arabicName),
                          );
                        }).toList(),
                    onChanged:
                        isUpdating
                            ? null
                            : (city) {
                              setState(() => _selectedCity = city);
                            },
                  ),
                  const SizedBox(height: 16),

                  // Bio Field
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'نبذة عنك (اختياري)',
                      hintText: 'أخبر الآخرين عن نفسك...',
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    maxLength: 500,
                    enabled: !isUpdating,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  ElevatedButton(
                    onPressed: isUpdating ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child:
                        isUpdating
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text('حفظ التغييرات'),
                  ),
                  const SizedBox(height: 16),

                  // Cancel Button
                  OutlinedButton(
                    onPressed: isUpdating ? null : () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('إلغاء'),
                  ),
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
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              String? avatarUrl;

              if (state is UserLoaded) {
                avatarUrl = state.user.avatarUrl;
              } else if (state is UserUpdating) {
                avatarUrl = state.user.avatarUrl;
              }

              return CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child:
                    avatarUrl == null
                        ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade400,
                        )
                        : null,
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 20),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: isDisabled ? null : _showAvatarOptions,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
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
                    _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('اختيار من المعرض'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                if (_currentUser?.avatarUrl != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      'حذف الصورة',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteAvatar();
                    },
                  ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    // TODO: Implement camera picker
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('سيتم تفعيل الكاميرا قريباً')));
  }

  Future<void> _pickImageFromGallery() async {
    // TODO: Implement gallery picker with image_picker
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('سيتم تفعيل المعرض قريباً')));
  }

  void _deleteAvatar() {
    if (_currentUser != null) {
      context.read<UserBloc>().add(
        DeleteAvatarRequested(userId: _currentUser!.id),
      );
    }
  }
}
