import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DietaryFilterChips extends StatelessWidget {
  final List<String> options;
  final Set<String> selectedFilters;
  final Function(String, bool) onFilterChanged;

  const DietaryFilterChips({
    super.key,
    required this.options,
    required this.selectedFilters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selectedFilters.contains(option);

          return Padding(
            padding: EdgeInsets.only(
              right: index < options.length - 1 ? 8 : 0,
            ),
            child: FilterChip(
              label: Text(option),
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              selected: isSelected,
              onSelected: (selected) => onFilterChanged(option, selected),
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
              ),
              elevation: isSelected ? 2 : 0,
              pressElevation: 1,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
