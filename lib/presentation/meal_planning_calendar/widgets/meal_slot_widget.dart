import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MealSlotWidget extends StatelessWidget {
  final String mealType;
  final Map<String, dynamic>? meal;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isDetailed;

  const MealSlotWidget({
    super.key,
    required this.mealType,
    this.meal,
    required this.onTap,
    this.onLongPress,
    this.isDetailed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return _buildEmptySlot();
    }

    return _buildMealCard();
  }

  Widget _buildEmptySlot() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isDetailed ? 12.h : 10.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.grey[600],
              size: isDetailed ? 24.sp : 20.sp,
            ),
            SizedBox(height: 1.h),
            Text(
              mealType.substring(0, 1).toUpperCase() + mealType.substring(1),
              style: GoogleFonts.inter(
                fontSize: isDetailed ? 14.sp : 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard() {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: isDetailed ? 12.h : 10.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Background image
              if (meal!['image'] != null)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: meal!['image'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(179),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal!['name'],
                        style: GoogleFonts.inter(
                          fontSize: isDetailed ? 14.sp : 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isDetailed) ...[
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.white70,
                              size: 12.sp,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              meal!['cookTime'],
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.w, vertical: 0.2.h),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(meal!['difficulty'])
                                    .withAlpha(204),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                meal!['difficulty'],
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
}
