import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/localization/localization.dart';
import 'package:warshasy/core/presentation/widgets/base_page.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';
import 'package:warshasy/core/theme/app_shadows.dart';
import 'package:warshasy/features/static_data/domain/presentation/bloc/static_data_bloc.dart';

enum LocationType { city, region }

class LocationSelector<T> extends StatelessWidget {
  final LocationType type;
  final int selectedId;
  final int? parentCityId; // Only required for regions
  final Function(int) onSelected;

  const LocationSelector({
    super.key,
    required this.type,
    required this.selectedId,
    required this.onSelected,
    this.parentCityId,
  }) : assert(
         type == LocationType.city || parentCityId != null,
         'parentCityId is required when type is region',
       );

  @override
  Widget build(BuildContext context) {
    final staticData = context.read<StaticDataBloc>().state as StaticDataLoaded;
    final displayData = _getDisplayData(staticData);

    return InkWell(
      onTap: () => _showBottomSheet(context),
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
                Icon(displayData.icon, color: AppColors.accent, size: 20),
                const SizedBox(width: 12),
                Text(
                  displayData.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  _DisplayData _getDisplayData(StaticDataLoaded staticData) {
    switch (type) {
      case LocationType.city:
        final city = staticData.getCityById(selectedId);
        return _DisplayData(name: city?.nameAr ?? '', icon: Icons.location_on);
      case LocationType.region:
        final region = staticData.getRegionById(selectedId);
        return _DisplayData(name: region?.name ?? '', icon: CupertinoIcons.map);
    }
  }

  void _showBottomSheet(BuildContext context) {
    final staticData = context.read<StaticDataBloc>().state as StaticDataLoaded;
    final items = _getItems(staticData);
    final config = _getConfig(context);
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
                        config.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Items List
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: items.length,
                          separatorBuilder:
                              (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isSelected = selectedId == item.id;

                            return ListTile(
                              leading: Icon(
                                config.itemIcon,
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : AppColors.textTertiary,
                              ),
                              title: Text(
                                item.name,
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
                                      ? const Icon(
                                        Icons.check,
                                        color: AppColors.accent,
                                      )
                                      : null,
                              onTap: () {
                                onSelected(item.id);
                                Navigator.pop(context);
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

  List<_ItemData> _getItems(StaticDataLoaded staticData) {
    switch (type) {
      case LocationType.city:
        return staticData.cities
            .map((city) => _ItemData(id: city.id, name: city.nameAr))
            .toList();
      case LocationType.region:
        return staticData
            .getRegionsByCity(parentCityId!)
            .map((region) => _ItemData(id: region.id, name: region.name))
            .toList();
    }
  }

  _BottomSheetConfig _getConfig(BuildContext context) {
    switch (type) {
      case LocationType.city:
        return _BottomSheetConfig(
          title: context.string('chooseCity'),
          itemIcon: Icons.location_city,
        );
      case LocationType.region:
        return _BottomSheetConfig(
          title: context.string('chooseRegion'),
          itemIcon: Icons.map,
        );
    }
  }
}

// Helper classes
class _DisplayData {
  final String name;
  final IconData icon;

  _DisplayData({required this.name, required this.icon});
}

class _ItemData {
  final int id;
  final String name;

  _ItemData({required this.id, required this.name});
}

class _BottomSheetConfig {
  final String title;
  final IconData itemIcon;

  _BottomSheetConfig({required this.title, required this.itemIcon});
}
