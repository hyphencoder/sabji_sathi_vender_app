import 'package:flutter/material.dart';

class ProductFilterChip extends StatelessWidget {
  const ProductFilterChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        selected: isSelected,
        onSelected: (_) => onTap(),

        // Checkmark nahi chahiye
        showCheckmark: false,

        // Size / spacing
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

        selectedColor: colorScheme.primary,
        backgroundColor: colorScheme.surface,

        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),

        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        ),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
