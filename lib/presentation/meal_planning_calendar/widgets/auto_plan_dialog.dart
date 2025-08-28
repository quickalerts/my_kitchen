import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AutoPlanDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAutoPlan;

  const AutoPlanDialog({
    super.key,
    required this.onAutoPlan,
  });

  @override
  State<AutoPlanDialog> createState() => _AutoPlanDialogState();
}

class _AutoPlanDialogState extends State<AutoPlanDialog> {
  final List<String> _dietaryPreferences = [];
  int _mealsPerDay = 3;
  bool _useInventoryItems = true;
  bool _balancedNutrition = true;

  final List<String> _availableDietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Low-Carb',
    'High-Protein',
    'Mediterranean',
    'Keto',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Auto-Plan Week',
        style: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let us create a balanced meal plan for your week!',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 3.h),
            // Meals per day selector
            Text(
              'Meals per day',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [1, 2, 3].map((meals) {
                final isSelected = _mealsPerDay == meals;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: meals < 3 ? 2.w : 0),
                    child: InkWell(
                      onTap: () => setState(() => _mealsPerDay = meals),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          '$meals meal${meals > 1 ? 's' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            // Dietary preferences
            Text(
              'Dietary Preferences',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _availableDietaryOptions.map((option) {
                final isSelected = _dietaryPreferences.contains(option);
                return FilterChip(
                  label: Text(
                    option,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _dietaryPreferences.add(option);
                      } else {
                        _dietaryPreferences.remove(option);
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            // Additional options
            CheckboxListTile(
              title: Text(
                'Use available inventory items',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: _useInventoryItems,
              onChanged: (value) {
                setState(() => _useInventoryItems = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
              activeColor: Colors.blue,
            ),
            CheckboxListTile(
              title: Text(
                'Ensure balanced nutrition',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: _balancedNutrition,
              onChanged: (value) {
                setState(() => _balancedNutrition = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final preferences = {
              'mealsPerDay': _mealsPerDay,
              'dietaryPreferences': _dietaryPreferences,
              'useInventoryItems': _useInventoryItems,
              'balancedNutrition': _balancedNutrition,
            };
            widget.onAutoPlan(preferences);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Generate Plan',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
