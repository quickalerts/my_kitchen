import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShoppingItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isCompleted;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onAddNote;
  final VoidCallback onRemove;

  const ShoppingItemCard({
    Key? key,
    required this.item,
    required this.isCompleted,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onAddNote,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<ShoppingItemCard> createState() => _ShoppingItemCardState();
}

class _ShoppingItemCardState extends State<ShoppingItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSwipedRight = false;
  bool _isSwipedLeft = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.3, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      // Swipe right - show edit actions
      setState(() {
        _isSwipedRight = true;
        _isSwipedLeft = false;
      });
      _animationController.forward();
    } else if (details.primaryVelocity! < 0) {
      // Swipe left - show remove action
      setState(() {
        _isSwipedLeft = true;
        _isSwipedRight = false;
      });
      _animationController.forward();
    }
  }

  void _resetSwipe() {
    setState(() {
      _isSwipedRight = false;
      _isSwipedLeft = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: _handleSwipe,
      onTap: _resetSwipe,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Stack(
          children: [
            // Background actions
            if (_isSwipedRight || _isSwipedLeft)
              Container(
                height: 12.h,
                decoration: BoxDecoration(
                  color: _isSwipedRight
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: _isSwipedRight
                      ? [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _resetSwipe();
                                widget.onEdit();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'edit',
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      'Edit Qty',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _resetSwipe();
                                widget.onAddNote();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'note_add',
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      'Add Note',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      : [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _resetSwipe();
                                widget.onRemove();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'delete',
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      'Remove',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            // Main card
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                height: 12.h,
                decoration: BoxDecoration(
                  color: widget.isCompleted
                      ? AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.7)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isCompleted
                        ? AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Row(
                    children: [
                      // Checkbox
                      InkWell(
                        onTap: widget.onToggleComplete,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.isCompleted
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 2,
                            ),
                            color: widget.isCompleted
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : Colors.transparent,
                          ),
                          child: widget.isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      // Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (widget.item['name'] as String?) ??
                                  'Unknown Item',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                decoration: widget.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: widget.isCompleted
                                    ? AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Text(
                                  'Qty: ${(widget.item['quantity'] as String?) ?? '1'}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: widget.isCompleted
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(
                                        widget.item['category'] as String? ??
                                            'Other'),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    (widget.item['category'] as String?) ??
                                        'Other',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if ((widget.item['source'] as String?)
                                    ?.isNotEmpty ==
                                true) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                'From: ${widget.item['source']}',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Price
                      if ((widget.item['estimatedPrice'] as String?)
                              ?.isNotEmpty ==
                          true)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.item['estimatedPrice'] as String,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: widget.isCompleted
                                    ? AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                    : AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'est.',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
