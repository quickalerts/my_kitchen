import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpiringSoonCard extends StatelessWidget {
  final List<Map<String, dynamic>> expiringItems;
  final Function(String itemId)? onDismiss;
  final VoidCallback? onViewAll;

  const ExpiringSoonCard({
    Key? key,
    required this.expiringItems,
    this.onDismiss,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expiringItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppTheme.warningLight.withValues(alpha: 0.1),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.warningLight,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Expiring Soon',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.warningLight,
                        ),
                  ),
                ),
                if (expiringItems.length > 3)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: AppTheme.warningLight,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Column(
              children: (expiringItems.take(3).toList() as List)
                  .map((item) => _buildExpiringItem(
                        context,
                        item as Map<String, dynamic>,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringItem(BuildContext context, Map<String, dynamic> item) {
    return Dismissible(
      key: Key(item['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismiss?.call(item['id'].toString()),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 5.w,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.warningLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CustomImageWidget(
                imageUrl: item['image'] as String? ?? '',
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String? ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Expires in ${item['daysLeft'] as String? ?? ''} days',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'swipe_left',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
