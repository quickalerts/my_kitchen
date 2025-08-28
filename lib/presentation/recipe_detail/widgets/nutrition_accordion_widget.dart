import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class NutritionAccordionWidget extends StatefulWidget {
  final Map<String, dynamic> nutrition;

  const NutritionAccordionWidget({
    super.key,
    required this.nutrition,
  });

  @override
  State<NutritionAccordionWidget> createState() =>
      _NutritionAccordionWidgetState();
}

class _NutritionAccordionWidgetState extends State<NutritionAccordionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_dining,
                        color: Colors.green[600],
                        size: 20.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Nutrition Information',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.nutrition['calories']} cal',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[600],
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[600],
                        size: 24.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildNutritionRow(
                      'Calories', '${widget.nutrition['calories']}', 'kcal'),
                  _buildNutritionRow(
                      'Protein', widget.nutrition['protein'], ''),
                  _buildNutritionRow(
                      'Carbohydrates', widget.nutrition['carbs'], ''),
                  _buildNutritionRow('Fat', widget.nutrition['fat'], ''),
                  _buildNutritionRow('Fiber', widget.nutrition['fiber'], ''),
                  _buildNutritionRow('Sugar', widget.nutrition['sugar'], ''),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, String unit) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            '$value $unit'.trim(),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
