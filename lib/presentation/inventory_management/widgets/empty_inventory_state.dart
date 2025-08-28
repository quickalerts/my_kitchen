import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyInventoryState extends StatelessWidget {
  final String category;
  final VoidCallback onAddItem;

  const EmptyInventoryState({
    Key? key,
    required this.category,
    required this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: CustomIconWidget(
                iconName: _getCategoryIcon(),
                size: 80,
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              _getEmptyTitle(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            Text(
              _getEmptySubtitle(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            ElevatedButton.icon(
              onPressed: onAddItem,
              icon: CustomIconWidget(
                iconName: 'add',
                size: 20,
                color: Colors.white,
              ),
              label: Text(_getButtonText()),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return 'eco';
      case 'proteins':
        return 'restaurant';
      case 'pantry':
        return 'kitchen';
      case 'dairy':
        return 'local_drink';
      default:
        return 'inventory_2';
    }
  }

  String _getEmptyTitle() {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return 'No Vegetables Yet';
      case 'proteins':
        return 'No Proteins Yet';
      case 'pantry':
        return 'No Pantry Items Yet';
      case 'dairy':
        return 'No Dairy Items Yet';
      default:
        return 'No Items Yet';
    }
  }

  String _getEmptySubtitle() {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return 'Start adding your fresh vegetables to keep track of what\'s in your kitchen.';
      case 'proteins':
        return 'Add your meat, fish, and protein sources to manage your inventory.';
      case 'pantry':
        return 'Keep track of your dry goods, spices, and pantry essentials.';
      case 'dairy':
        return 'Add milk, cheese, yogurt, and other dairy products to your inventory.';
      default:
        return 'Start building your kitchen inventory by adding your first item.';
    }
  }

  String _getButtonText() {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return 'Add Your First Vegetable';
      case 'proteins':
        return 'Add Your First Protein';
      case 'pantry':
        return 'Add Your First Pantry Item';
      case 'dairy':
        return 'Add Your First Dairy Item';
      default:
        return 'Add Your First Item';
    }
  }
}
