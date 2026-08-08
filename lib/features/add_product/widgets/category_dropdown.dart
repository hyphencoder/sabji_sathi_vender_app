import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../models/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onSelected,
  });

  final CategoryModel? selectedCategory;
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel?> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownSearch<CategoryModel>(
      selectedItem: selectedCategory,

      items: (filter, infiniteScrollProps) => categories,

      itemAsString: (item) => item.name,

      compareFn: (a, b) => a.id == b.id,

      onChanged: onSelected,

      popupProps: PopupProps.menu(
        showSearchBox: true,

        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search Category",
            prefixIcon: Icon(Icons.search),
          ),
        ),

        constraints: const BoxConstraints(maxHeight: 400),

        fit: FlexFit.loose,

        emptyBuilder: (context, searchEntry) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("No Category Found")),
          );
        },
      ),

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: "All Categories",

          prefixIcon: Icon(Icons.category_outlined, color: colorScheme.primary),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
