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
import 'package:warshasy/features/static_data/domain/entites/city.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/home/presentation/widgets/common_widgets.dart';
import 'package:warshasy/features/home/presentation/widgets/custom_scaffold.dart';
import 'package:warshasy/features/user/domain/presentation/blocs/current_user_bloc/current_user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  late final staticData =
      context.read<StaticDataBloc>().state as StaticDataLoaded;
  late final cities = staticData.cities;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentUserBloc, CurrentUserState>(
      listener: (context, state) {
        if (state is CurrentUserLoaded) {
          if (user != null && user!.id != state.user.id) {
            setState(() {
              user = state.user;
            });
          }
        } else {
          setState(() {
            user = null;
          });
          if (state is CurrentUserError) {
            context.showErrorSnackBar(state.failure.message);
          }
          setState(() {
            isLoading = state is CurrentUserLoading;
          });
        }
      },
      child: _buildHomeUI(context, isLoading),
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
                  '${l.welcomeGreeting} ${user?.fullName ?? ''}',
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
        if (user != null)
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
                  '${user?.location.cityName}',
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        context.string('chooseCity'),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // City List
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: cities.length,
                          separatorBuilder:
                              (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final city = cities[index];
                            final isSelected =
                                user?.location.cityName == city.nameAr;

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Icon(
                                Icons.location_city,
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : AppColors.textTertiary,
                              ),
                              title: Text(
                                city.nameAr,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                ),
                              ),
                              trailing:
                                  isSelected
                                      ? Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                      )
                                      : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.medium,
                                ),
                              ),
                              onTap: () {
                                _onCitySelected(context, city);
                              },
                            );
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

  void _onCitySelected(BuildContext context, City city) {
    // Update user location
    if (user != null) {
      //user!.location.cityId = city.id;
      //context.read<CurrentUserBloc>().add(UpdateCurrentUser(user: ));
    }

    // Close bottom sheet
    Navigator.pop(context);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اختيار ${city.nameAr}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
