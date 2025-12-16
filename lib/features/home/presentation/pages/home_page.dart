import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/route/app_routes.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/theme/app_shadows.dart';
import 'package:warshasy/core/utils/snackbar_utils.dart';
import 'package:warshasy/core/presentation/widgets/location_selector.dart';
import 'package:warshasy/core/presentation/widgets/common_widgets.dart';
import 'package:warshasy/core/presentation/widgets/custom_scaffold.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/static_data/domain/entites/city.dart';
import 'package:warshasy/features/static_data/domain/entites/service_category.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';
import 'package:warshasy/features/user/presentation/blocs/current_user_bloc/current_user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  late final staticData =
      context.read<StaticDataBloc>().state as StaticDataLoaded;
  bool isLoading = false;
  late int _selectedCityId = user?.location.cityId ?? 1;

  @override
  void initState() {
    super.initState();
    final currentUserBloc = context.read<CurrentUserBloc>();
    if (currentUserBloc.state is CurrentUserLoaded) {
      onUserLoaded();
    }
  }

  void onUserLoaded() {
    final currentUserBloc = context.read<CurrentUserBloc>();
    final state = currentUserBloc.state as CurrentUserLoaded;
    setState(() {
      user = state.user;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentUserBloc, CurrentUserState>(
      listener: (context, state) {
        if (state is CurrentUserLoaded) {
          onUserLoaded();
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

    return CustomerScaffold(
      appBar: CommonWidgets.buildDefaultAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context, isLoading, textTheme),
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
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
        ),
        onTap: () {
          // TODO: Navigate to search screen
        },
      ),
    );
  }

  Widget _buildSectionHeader(TextTheme textTheme) {
    return Text(
      AppLocalizations.of(context).homeSectionTitle,
      style: textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildLocationSelector(BuildContext context) {
    return LocationSelector(
      type: LocationType.city,
      selectedId: _selectedCityId,
      onSelected:
          (cityId) => _onCitySelected(context, staticData.getCityById(cityId)!),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, bool isTablet) {
    final l = AppLocalizations.of(context);
    final categories = staticData.serviceCategories;

    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.noServicesFound,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: isTablet ? 0.85 : 1.4,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          context: context,
          category: category,
          isTablet: isTablet,
          onTap: () => _navigateToSubcategory(context, category),
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required ServiceCategory category,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final title = _localizedCategoryName(category);
    final serviceCount = category.services.length;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppShadows.soft,
          border: Border.all(color: AppColors.primary.withOpacity(0.08)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CategoryIcon(
                iconUrl: category.iconUrl,
                size: isTablet ? 120 : 110,
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
                '$serviceCount ${AppLocalizations.of(context).servicesAvailable}',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCitySelected(BuildContext context, City city) {
    setState(() {
      _selectedCityId = city.id;
    });
  }

  void _navigateToSubcategory(BuildContext context, ServiceCategory category) {
    context.pushNamed(
      AppRouteName.categoryServices,
      pathParameters: {'categoryId': category.id.toString()},
      extra: category,
    );
  }

  String _localizedCategoryName(ServiceCategory category) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? category.nameAr : category.nameEn;
  }
}

class _CategoryIcon extends StatelessWidget {
  final String? iconUrl;
  final double size;

  const _CategoryIcon({required this.iconUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child:
          (iconUrl != null && iconUrl!.isNotEmpty)
              ? Image.asset(
                iconUrl!,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.handyman, color: AppColors.primary),
              )
              : const Icon(Icons.handyman, color: AppColors.primary),
    );
  }
}
