import 'package:flutter/material.dart';

class CategorySelectorBottomSheet extends StatefulWidget {
  const CategorySelectorBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  State<CategorySelectorBottomSheet> createState() =>
      _CategorySelectorBottomSheetState();
}

class _CategorySelectorBottomSheetState
    extends State<CategorySelectorBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  late List<String> filteredCategories;

  @override
  void initState() {
    super.initState();
    filteredCategories = widget.categories;
  }

  void _search(String value) {
    setState(() {
      filteredCategories = widget.categories
          .where((e) => e.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Select Category",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Search Category",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];

                  final isSelected = category == widget.selectedCategory;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(category),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: colorScheme.primary)
                        : null,
                    onTap: () {
                      widget.onSelected(category);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
