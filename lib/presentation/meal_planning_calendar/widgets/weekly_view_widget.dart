import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './meal_slot_widget.dart';

class WeeklyViewWidget extends StatelessWidget {
  final List<DateTime> currentWeekDays;
  final Map<String, Map<String, Map<String, dynamic>>> plannedMeals;
  final Function(DateTime, String, Map<String, dynamic>) onMealTap;
  final Function(DateTime, String) onEmptySlotTap;
  final VoidCallback onGenerateShoppingList;

  const WeeklyViewWidget({
    super.key,
    required this.currentWeekDays,
    required this.plannedMeals,
    required this.onMealTap,
    required this.onEmptySlotTap,
    required this.onGenerateShoppingList,
  });

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Shopping list generation button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 3.h),
            child: ElevatedButton.icon(
              onPressed: onGenerateShoppingList,
              icon: const Icon(Icons.help_outline),
              label: const Text('Generate Shopping List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Daily meal breakdown
          Expanded(
            child: ListView.builder(
              itemCount: currentWeekDays.length,
              itemBuilder: (context, index) {
                final date = currentWeekDays[index];
                final dateStr = _formatDate(date);
                final dailyMeals = plannedMeals[dateStr] ?? {};

                return Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          _formatDateForDisplay(date),
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Meal slots
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children:
                              ['breakfast', 'lunch', 'dinner'].map((mealType) {
                            final meal = dailyMeals[mealType];

                            return Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    child: Text(
                                      mealType.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MealSlotWidget(
                                      mealType: mealType,
                                      meal: meal,
                                      isDetailed: true,
                                      onTap: meal != null
                                          ? () =>
                                              onMealTap(date, mealType, meal)
                                          : () =>
                                              onEmptySlotTap(date, mealType),
                                      onLongPress: meal != null
                                          ? () =>
                                              onMealTap(date, mealType, meal)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateForDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == today.add(const Duration(days: 1))) return 'Tomorrow';

    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
