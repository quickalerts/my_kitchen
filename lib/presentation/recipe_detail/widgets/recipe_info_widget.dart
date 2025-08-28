import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class RecipeInfoWidget extends StatelessWidget {
  final String name;
  final double rating;
  final String difficulty;
  final String prepTime;
  final String cookTime;
  final int servings;

  const RecipeInfoWidget({
    super.key,
    required this.name,
    required this.rating,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20.sp,
                ),
                SizedBox(width: 1.w),
                Text(
                  rating.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(width: 4.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getDifficultyColor(difficulty).withAlpha(51),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getDifficultyColor(difficulty),
                  width: 1,
                ),
              ),
              child: Text(
                difficulty,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _getDifficultyColor(difficulty),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildInfoChip(
              icon: Icons.schedule,
              label: 'Prep',
              value: prepTime,
            ),
            SizedBox(width: 4.w),
            _buildInfoChip(
              icon: Icons.timer,
              label: 'Cook',
              value: cookTime,
            ),
            SizedBox(width: 4.w),
            _buildInfoChip(
              icon: Icons.people,
              label: 'Serves',
              value: servings.toString(),
            ),
          ],
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20.sp,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
