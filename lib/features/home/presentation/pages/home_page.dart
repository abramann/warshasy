import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/constants/constants.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/presentation/widgets/base_page.dart';
import 'package:warshasy/core/route/app_routes.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/theme/app_shadows.dart';
import 'package:warshasy/core/theme/app_gradients.dart';
import 'package:warshasy/core/utils/snackbar_utils.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/database/domain/entites/location.dart';
import 'package:warshasy/features/home/presentation/widgets/common_widgets.dart';
import 'package:warshasy/features/home/presentation/widgets/custom_scaffold.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCity = 0;
  AuthSession? _authSession;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingStartup || state is AuthInitial)
          return _buildStartupUI(context);

        if (state is Authenticated) {
          _authSession = state.session;
          //  _selectedCity =
          // _authSession?.?.city.arabicName ?? _selectedCity;
        } else {
          _authSession = null;
          if (state is AuthFailureState) {
            context.showErrorSnackBar(state.message);
            context.read<AuthBloc>().add(AuthStartup());
            return _buildStartupUI(context);
          }
        }

        final isLoading = state is AuthLoading;
        return _buildHomeUI(context, isLoading);
      },
    );
  }

  // Add this to your _HomePageState class

  Widget _buildStartupUI(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content up a bit
              const Spacer(flex: 2),

              // App Logo with animation
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 40),

              // App Name
              Text(
                l.appTitle,
                style: textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              // Tagline or description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'منصتك الموثوقة للخدمات المنزلية والحرفية',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 2),

              // Loading Indicator
              Column(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.loading,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  // Alternative: Minimal version (simpler, faster loading)
  Widget _buildStartupUIMinimal(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft,
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
            ),

            const SizedBox(height: 30),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Alternative: With animated logo (even fancier)
  Widget _buildStartupUIAnimated(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Animated Logo with pulse effect
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(28),
                      child: Image.asset(
                        AppAssets.appLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // App Name with fade-in effect
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, opacity, child) {
                    return Opacity(opacity: opacity, child: child);
                  },
                  child: Column(
                    children: [
                      Text(
                        l.appTitle,
                        style: textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'منصتك الموثوقة للخدمات',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Loading with text
                Column(
                  children: [
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'جاري التحميل...',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // Version or copyright (optional)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'الإصدار 1.0.0',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeUI(BuildContext context, bool isLoading) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = MediaQuery.of(context).size.width > 600;
    final l = AppLocalizations.of(context);

    return CustomerScaffold(
      appBar: CommonWidgets.buildDefaultAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context, isLoading, textTheme, isTablet),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 20),
              _buildLocationSelector(context),
              const SizedBox(height: 24),
              _buildSectionHeader(textTheme),
              const SizedBox(height: 16),
              _buildCategoryGrid(context, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(
    BuildContext context,
    bool isLoading,
    TextTheme textTheme,
    bool isTablet,
  ) {
    final l = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  '${l.welcomeGreeting} ${_authSession?.fullName ?? ''}',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                l.homeServicePrompt,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (_authSession != null)
          ElevatedButton(
            onPressed: () => context.pushNamed(AppRouteName.addService),
            child: Text(l.homePostService),
          )
        else if (isLoading)
          const CircularProgressIndicator()
        else
          ElevatedButton(
            onPressed: () => context.pushNamed(AppRouteName.login),
            child: Text(l.homeLoginCta),
          ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppShadows.subtle,
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: context.string('searchHint'),
          prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
        ),
        onTap: () {
          // TODO: Navigate to search screen
        },
      ),
    );
  }

  Widget _buildLocationSelector(BuildContext context) {
    return InkWell(
      onTap: () => _showCityBottomSheet(context),
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.accent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedCity,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(TextTheme textTheme) {
    return Text(
      AppLocalizations.of(context).homeSectionTitle,
      style: textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, bool isTablet) {
    final l = AppLocalizations.of(context);
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
          title: l.categoryCraftsTitle,
          description: l.categoryCraftsDesc,
          icon: 'assets/icons/crafts.png',
          gradient: AppGradients.craft,
          borderColor: AppColors.craftGradient.first,
          onTap: () => _navigateToSubcategory(context, l.categoryCraftsTitle),
        ),
        _buildCategoryCard(
          context: context,
          title: l.categoryTechnicalTitle,
          description: l.categoryTechnicalDesc,
          icon: 'assets/icons/technical.png',
          gradient: AppGradients.technical,
          borderColor: AppColors.technicalGradient.first,
          onTap:
              () => _navigateToSubcategory(context, l.categoryTechnicalTitle),
        ),
        _buildCategoryCard(
          context: context,
          title: l.categoryCleaningTitle,
          description: l.categoryCleaningDesc,
          icon: 'assets/icons/cleaning.png',
          gradient: AppGradients.cleaning,
          borderColor: AppColors.cleaningGradient.first,
          onTap: () => _navigateToSubcategory(context, l.categoryCleaningTitle),
        ),
      ],
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppShadows.soft,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isTablet ? 150 : 130,
                height: isTablet ? 150 : 130,
                padding: const EdgeInsets.all(16),
                child: Image.asset(icon, fit: BoxFit.contain),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Flexible(
                child: Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => BasePage(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: [
                      Text(
                        context.string('chooseCity'),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...City.values.map(
                        (city) => ListTile(
                          leading: const Icon(Icons.location_city),
                          title: Text(city.arabicName),
                          trailing:
                              _selectedCity == city.arabicName
                                  ? const Icon(
                                    Icons.check,
                                    color: AppColors.accent,
                                  )
                                  : null,
                          onTap: () {
                            setState(() => _selectedCity = city.arabicName);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
    );
  }

  void _navigateToSubcategory(BuildContext context, String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalizations.of(context).openingCategory} $category...',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
