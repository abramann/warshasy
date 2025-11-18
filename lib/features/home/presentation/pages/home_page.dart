import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/config/config.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = City.damascus.arabicName;
  User? user;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        User? user;
        bool _isLoading = false;
        if (state is AuthSuccess) {
          user = state.user;
        } else if (state is AuthLoading || state is AuthStarting) {
          _isLoading = true;
          user = null;
        } else {
          user = null;
        }
        selectedCity = user?.city?.arabicName ?? selectedCity;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            appBar: AppBar(
              title: const Text(
                'تك فيكس',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle_outlined),
                  onPressed: () {
                    context.push('/profile'); // ✅ Push to the actual page
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                ),
              ],

              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 84, 173, 247),
                      Color.fromARGB(255, 84, 173, 247),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              elevation: 2,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                    'أهلا وسهلا ! 👋 ${user?.fullName ?? ''}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                              SizedBox(height: 8),
                              Text(
                                'ما هي الخدمة التي تحتاجها اليوم؟',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12), // a little space before the button
                        if (user != null)
                          ElevatedButton(
                            onPressed: () {
                              context.pushNamed('post-service');
                            },
                            child: Text('اعرض خدمة'),
                          )
                        else
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: () {
                                  context.pushNamed('login');
                                },
                                child: Text('أعلن عن نفسك'),
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن خدمة...',
                          hintStyle: const TextStyle(color: Color(0xFF999999)),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF999999),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onTap: () {
                          // Navigate to search screen
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location Selector
                    InkWell(
                      onTap: () => _showCityBottomSheet(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF667eea),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  selectedCity,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF999999),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section Header
                    const Text(
                      'اختر خدمتك',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isTablet ? 3 : 1,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: isTablet ? 0.85 : 1.4,
                          children: [
                            _buildCategoryCard(
                              context: context,
                              title: 'الحرف اليدوية',
                              description:
                                  'تمديد كهرباء وصحية , نجارة وحدادة وغيرها',
                              icon: 'assets/icons/crafts.png',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B35), Color(0xFFFF8C61)],
                              ),
                              borderColor: const Color(0xFFFF6B35),
                              onTap:
                                  () => _navigateToSubcategory(
                                    context,
                                    'الحرف اليدوية',
                                  ),
                            ),
                            _buildCategoryCard(
                              context: context,
                              title: 'الخدمات التقنية',
                              description: 'الكترونيات , طاقة بديلة وشبكات',
                              icon: 'assets/icons/technical.png',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4A90E2), Color(0xFF6BA8F0)],
                              ),
                              borderColor: const Color(0xFF4A90E2),
                              onTap:
                                  () => _navigateToSubcategory(
                                    context,
                                    'الخدمات التقنية',
                                  ),
                            ),
                            _buildCategoryCard(
                              context: context,
                              title: 'التنظيف والخدمات المنزلية',
                              description:
                                  ' تنظيف منازل وأسطح , تنجيد ونقل أثاث وغيرها',
                              icon: 'assets/icons/cleaning.png',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF50C878), Color(0xFF72D893)],
                              ),
                              borderColor: const Color(0xFF50C878),
                              onTap:
                                  () => _navigateToSubcategory(
                                    context,
                                    'التنظيف والخدمات المنزلية',
                                  ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String description,
    required String icon,
    required Gradient gradient,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isTablet ? 150 : 130,
                height: isTablet ? 150 : 130,
                decoration: BoxDecoration(
                  //color: borderColor.withOpacity(0.08),
                  shape: BoxShape.rectangle,
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(icon, fit: BoxFit.contain),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              // Title
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Service Count
              Text(
                description,
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: const Color(0xFF999999),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اختر مدينتك',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...City.values.toList().map(
                    (city) => ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(city.arabicName),
                      trailing:
                          selectedCity == city.arabicName
                              ? const Icon(
                                Icons.check,
                                color: Color(0xFF667eea),
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          selectedCity = city.arabicName;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _navigateToSubcategory(BuildContext context, String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري فتح خدمات $category...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
