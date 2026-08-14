import 'package:flutter/material.dart';
import 'package:vender_app/shared/models/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onSelected,
  });

  final CategoryModel? selectedCategory;
  final List<CategoryModel> categories;
  final Function(CategoryModel?) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    debugPrint(
      "Current Selected => ${selectedCategory?.id} ${selectedCategory?.name}",
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CategoryModel?>(
          value: selectedCategory,
          hint: const Text('Select Category'),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          dropdownColor: colorScheme.surface,
          items: [
            // ✅ "All Categories" option
            const DropdownMenuItem<CategoryModel>(
              value: null,
              child: Row(
                children: [
                  Icon(Icons.list, size: 18),
                  SizedBox(width: 8),
                  Text('All Categories'),
                ],
              ),
            ),
            // ✅ Categories list
            ...categories.map((category) {
              return DropdownMenuItem<CategoryModel>(
                value: category,
                child: Row(
                  children: [
                    Icon(Icons.category, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(category.name),
                  ],
                ),
              );
            }).toList(),
          ],
          onChanged: (value) {
            debugPrint("Selected => ${value?.id} ${value?.name}");
            onSelected(value);
          },
        ),
      ),
    );
  }
}
