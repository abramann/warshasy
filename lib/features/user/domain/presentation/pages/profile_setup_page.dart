// ============================================
// 2. PROFILE SETUP PAGE (Edit Profile)
// lib/features/user/presentation/pages/profile_setup_page.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/presentation/widgets/base_page.dart';
import 'package:warshasy/core/storage/repository/local_storage_reposotory.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';

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
  bool _isLoading = true;
  bool _isSaving = false;
  late String _userId;
  late String _phone;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      ctx.read<UserBloc>().add(
        UpdateProfileRequested(
          userId: _userId,
          phone: _phone,
          fullName: _nameController.text.trim(),
          city: _selectedCity,
          bio:
              _bioController.text.trim().isEmpty
                  ? null
                  : _bioController.text.trim(),
        ),
      );
    }
  }

  void setUser(User user) {
    _userId = user.id;
    _phone = user.phone;
    _nameController.text = user.fullName;
    _bioController.text = user.bio ?? '';
    _selectedCity = City.fromString(user.city?.arabicName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<UserBloc>()..add(LoadUserRequested(userId: _userId)),

      child: Builder(
        builder:
            (innerContext) => BasePage(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('تعديل الملف الشخصي'),
                  actions: [
                    TextButton(
                      onPressed: () => _saveProfile(innerContext),
                      child: const Text('حفظ', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                body: BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserLoaded) {
                      setState(() {
                        setUser(state.user);
                        _isLoading = false;
                      });
                    } else if (state is UserLoading)
                      setState(() {
                        if (!_isLoading)
                          _isSaving = true;
                        else
                          _isLoading = true;
                      });
                    else if (state is UserUpdated) {
                      final storage = sl<LocalStorageRepository>();
                      storage.saveUser(state.user);
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تحديث البيانات')),
                      );
                    } else {
                      setState(() {
                        _isLoading = false;
                        _isSaving = false;
                      });
                    }
                  },
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Form(
                            key: _formKey,
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                // Avatar Section
                                _buildAvatarSection(),

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
                                  enabled: !_isSaving,
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
                                      _isSaving
                                          ? null
                                          : (city) {
                                            setState(
                                              () => _selectedCity = city,
                                            );
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
                                  enabled: !_isSaving,
                                  textInputAction: TextInputAction.done,
                                ),

                                const SizedBox(height: 24),

                                // Save Button
                                ElevatedButton(
                                  onPressed:
                                      _isSaving
                                          ? null
                                          : () => _saveProfile(innerContext),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      48,
                                    ),
                                  ),
                                  child:
                                      _isSaving
                                          ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Text('حفظ التغييرات'),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ),
      ),
    );
  }

  Widget foo() {
    return Text('foo');
  }

  Widget _buildAvatarSection() {
    final storage = sl<LocalStorageRepository>();
    final user = storage.getUser();

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
            child:
                user?.avatarUrl == null
                    ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                    : null,
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
                onPressed: _isSaving ? null : () => _showAvatarOptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    final storage = sl<LocalStorageRepository>();
    final user = storage.getUser();

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
                if (user?.avatarUrl != null)
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
    final storage = sl<LocalStorageRepository>();
    final userId = storage.getUserId();

    if (userId != null) {
      context.read<UserBloc>().add(DeleteAvatarRequested(userId: userId));
    }
  }
}
