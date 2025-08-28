import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryOverviewCard extends StatelessWidget {
  final Map<String, dynamic> inventoryData;
  final VoidCallback? onTap;

  const InventoryOverviewCard({
    Key? key,
    required this.inventoryData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inventory Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              _buildCategoryItem(
                context,
                'Vegetables',
                (inventoryData['vegetables'] as int? ?? 0),
                45,
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              SizedBox(height: 1.5.h),
              _buildCategoryItem(
                context,
                'Proteins',
                (inventoryData['proteins'] as int? ?? 0),
                28,
                AppTheme.lightTheme.colorScheme.secondary,
              ),
              SizedBox(height: 1.5.h),
              _buildCategoryItem(
                context,
                'Pantry',
                (inventoryData['pantry'] as int? ?? 0),
                67,
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String category,
    int count,
    int maxCount,
    Color color,
  ) {
    double progress = maxCount > 0 ? count / maxCount : 0.0;
    progress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
            ),
            Text(
              '$count items',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 0.8.h,
        ),
      ],
    );
  }
}
