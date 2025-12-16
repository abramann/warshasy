import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/presentation/widgets/common_widgets.dart';
import 'package:warshasy/core/route/app_routes.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/theme/app_shadows.dart';
import 'package:warshasy/features/static_data/domain/entites/service.dart';
import 'package:warshasy/features/static_data/domain/entites/service_category.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';

class SubcategoriesPage extends StatefulWidget {
  final int categoryId;
  final ServiceCategory? category;

  const SubcategoriesPage({super.key, required this.categoryId, this.category});

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<StaticDataBloc, StaticDataState>(
      builder: (context, state) {
        if (state is StaticDataLoading || state is StaticDataInitial) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! StaticDataLoaded) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l.unexpectedError)),
          );
        }

        final category =
            widget.category ?? state.getCategoryById(widget.categoryId);
        if (category == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l.noServicesFound)),
          );
        }

        final services = _filteredServices(category.services);
        final isTablet = MediaQuery.of(context).size.width > 600;
        final localizedName = _localizedCategoryName(category, context);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CommonWidgets.buildDefaultAppBar(
            context,
            title: localizedName,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  _CategoryHeader(category: category),
                  // const SizedBox(height: 16),
                  _buildSearchBar(context, localizedName),
                  const SizedBox(height: 20),
                  _buildInfoBanner(context),
                  const SizedBox(height: 24),
                  Text(
                    searchQuery.isEmpty ? l.allServices : l.searchResults,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  services.isEmpty
                      ? _EmptyState(message: l.noServicesFound)
                      : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 3 : 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: isTablet ? 1.2 : 1.05,
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return _ServiceCard(
                            service: service,
                            onTap: () => _onServiceTap(context, service),
                            name: _localizedServiceName(service, context),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Service> _filteredServices(List<Service> services) {
    if (searchQuery.isEmpty) return services;
    final query = searchQuery.toLowerCase();
    return services
        .where(
          (service) => _localizedServiceName(
            service,
            context,
          ).toLowerCase().contains(query),
        )
        .toList();
  }

  Widget _buildSearchBar(BuildContext context, String categoryName) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppShadows.subtle,
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: '${l.searchIn} $categoryName...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.notFindService,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.contactUsToAdd,
                  style: const TextStyle(fontSize: 12, color: AppColors.info),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onServiceTap(BuildContext context, Service service) {
    context.pushNamed(
      AppRouteName.serviceProviders,
      pathParameters: {'serviceId': service.id.toString()},
    );
  }

  String _localizedServiceName(Service service, BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? service.nameAr : service.nameEn;
  }

  String _localizedCategoryName(
    ServiceCategory category,
    BuildContext context,
  ) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? category.nameAr : category.nameEn;
  }
}

class _CategoryHeader extends StatelessWidget {
  final ServiceCategory category;

  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    final name =
        Localizations.localeOf(context).languageCode == 'ar'
            ? category.nameAr
            : category.nameEn;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        children: [
          _CategoryIcon(iconUrl: category.iconUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (category.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      category.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String? iconUrl;

  const _CategoryIcon({this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.08),
      ),
      child: ClipOval(
        child:
            (iconUrl != null && iconUrl!.isNotEmpty)
                ? Image.network(
                  iconUrl!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const Icon(Icons.handyman, color: AppColors.primary),
                )
                : const Icon(Icons.handyman, color: AppColors.primary),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  final String name;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.primary.withOpacity(0.05)),
          boxShadow: AppShadows.subtle,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.miscellaneous_services_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (service.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  service.description!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
