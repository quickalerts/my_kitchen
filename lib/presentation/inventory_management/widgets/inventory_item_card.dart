import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onEdit;
  final VoidCallback? onUse;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool isSelected;

  const InventoryItemCard({
    Key? key,
    required this.item,
    this.onEdit,
    this.onUse,
    this.onDelete,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isExpiringSoon = _isExpiringSoon();
    final bool isExpired = _isExpired();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(item['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onUse?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.remove_circle_outline,
              label: 'Use',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  // Product Image
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.lightTheme.colorScheme.surface,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: item['image'] as String? ?? '',
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Item Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['name'] as String? ?? 'Unknown Item',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isExpired)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'EXPIRED',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            else if (isExpiringSoon)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.warningLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'EXPIRES SOON',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),

                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'inventory_2',
                              size: 16,
                              color: AppTheme.textSecondaryLight,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Qty: ${item['quantity'] ?? 0} ${item['unit'] ?? ''}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              size: 16,
                              color: AppTheme.textSecondaryLight,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                _formatExpirationDate(),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: isExpired
                                      ? AppTheme.lightTheme.colorScheme.error
                                      : isExpiringSoon
                                          ? AppTheme.warningLight
                                          : AppTheme.textSecondaryLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),

                        // Category Tag
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getCategoryColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getCategoryColor().withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            item['category'] as String? ?? 'Other',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getCategoryColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Controls
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _adjustQuantity(1),
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomIconWidget(
                            iconName: 'add',
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${item['quantity'] ?? 0}',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () => _adjustQuantity(-1),
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppTheme.textSecondaryLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomIconWidget(
                            iconName: 'remove',
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isExpiringSoon() {
    if (item['expirationDate'] == null) return false;
    final expirationDate = DateTime.parse(item['expirationDate']);
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;
    return difference <= 3 && difference > 0;
  }

  bool _isExpired() {
    if (item['expirationDate'] == null) return false;
    final expirationDate = DateTime.parse(item['expirationDate']);
    final now = DateTime.now();
    return expirationDate.isBefore(now);
  }

  String _formatExpirationDate() {
    if (item['expirationDate'] == null) return 'No expiry date';
    final expirationDate = DateTime.parse(item['expirationDate']);
    final now = DateTime.now();
    final difference = expirationDate.difference(now).inDays;

    if (difference < 0) {
      return 'Expired ${(-difference)} days ago';
    } else if (difference == 0) {
      return 'Expires today';
    } else if (difference == 1) {
      return 'Expires tomorrow';
    } else {
      return 'Expires in $difference days';
    }
  }

  Color _getCategoryColor() {
    switch (item['category']?.toString().toLowerCase()) {
      case 'vegetables':
        return Colors.green;
      case 'proteins':
        return Colors.red;
      case 'pantry':
        return Colors.brown;
      case 'dairy':
        return Colors.blue;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  void _adjustQuantity(int change) {
    // This would typically call a callback to update the quantity
    // For now, it's a placeholder for the functionality
  }
}
