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
        label: Text(title),
        selected: isSelected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
