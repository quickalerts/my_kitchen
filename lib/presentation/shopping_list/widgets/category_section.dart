import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './shopping_item_card.dart';

class CategorySection extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> completedItems;
  final Function(Map<String, dynamic>) onToggleComplete;
  final Function(Map<String, dynamic>) onEditItem;
  final Function(Map<String, dynamic>) onAddNote;
  final Function(Map<String, dynamic>) onRemoveItem;

  const CategorySection({
    Key? key,
    required this.categoryName,
    required this.items,
    required this.completedItems,
    required this.onToggleComplete,
    required this.onEditItem,
    required this.onAddNote,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.items.length + widget.completedItems.length;
    final completedCount = widget.completedItems.length;

    if (totalItems == 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _getCategoryColor(widget.categoryName)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getCategoryColor(widget.categoryName)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(widget.categoryName),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoryName,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '$completedCount of $totalItems completed',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress indicator
                  SizedBox(
                    width: 12.w,
                    child: LinearProgressIndicator(
                      value: totalItems > 0 ? completedCount / totalItems : 0,
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getCategoryColor(widget.categoryName),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Items list
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    children: [
                      // Active items
                      ...widget.items.map((item) => ShoppingItemCard(
                            item: item,
                            isCompleted: false,
                            onToggleComplete: () =>
                                widget.onToggleComplete(item),
                            onEdit: () => widget.onEditItem(item),
                            onAddNote: () => widget.onAddNote(item),
                            onRemove: () => widget.onRemoveItem(item),
                          )),
                      // Completed items
                      ...widget.completedItems.map((item) => ShoppingItemCard(
                            item: item,
                            isCompleted: true,
                            onToggleComplete: () =>
                                widget.onToggleComplete(item),
                            onEdit: () => widget.onEditItem(item),
                            onAddNote: () => widget.onAddNote(item),
                            onRemove: () => widget.onRemoveItem(item),
                          )),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'produce':
        return const Color(0xFF4CAF50);
      case 'dairy':
        return const Color(0xFF2196F3);
      case 'pantry':
        return const Color(0xFFFF9800);
      case 'meat':
        return const Color(0xFFF44336);
      case 'frozen':
        return const Color(0xFF9C27B0);
      case 'bakery':
        return const Color(0xFF795548);
      default:
        return const Color(0xFF607D8B);
    }
  }
}
