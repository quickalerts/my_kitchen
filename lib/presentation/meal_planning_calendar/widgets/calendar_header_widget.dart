import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CalendarHeaderWidget extends StatelessWidget {
  final DateTime currentWeekStart;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const CalendarHeaderWidget({
    super.key,
    required this.currentWeekStart,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final currentWeekEnd = currentWeekStart.add(const Duration(days: 6));
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String headerText;
    if (currentWeekStart.month == currentWeekEnd.month) {
      headerText =
          '${months[currentWeekStart.month - 1]} ${currentWeekStart.year}';
    } else {
      headerText =
          '${months[currentWeekStart.month - 1]} - ${months[currentWeekEnd.month - 1]} ${currentWeekStart.year}';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black87),
            onPressed: onPreviousWeek,
          ),
          Text(
            headerText,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.black87),
            onPressed: onNextWeek,
          ),
        ],
      ),
    );
  }
}
