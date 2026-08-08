import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/add_product_provider.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/product_list.dart';
import '../widgets/product_search_field.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(addProductProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),

                /// Search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ProductSearchField(
                    onChanged: (value) {
                      ref
                          .read(addProductProvider.notifier)
                          .searchProducts(value);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// Category
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CategoryDropdown(
                    selectedCategory: state.selectedCategory,
                    categories: state.categories,
                    onSelected: (category) {
                      ref
                          .read(addProductProvider.notifier)
                          .selectCategory(category);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// Product List
                Expanded(child: ProductList(products: state.filteredProducts)),
              ],
            ),
    );
  }
}
