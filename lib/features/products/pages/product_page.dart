import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vender_app/core/routes/app_routes.dart';
import 'package:vender_app/features/add_product/widgets/selected_product_bottom_sheet.dart';
import 'package:vender_app/features/products/providers/product_provider.dart';

import '../../dashboard/widgets/dashboard_header.dart';
import '../widgets/product_card.dart';
import '../widgets/product_filter_chip.dart';
import '../widgets/product_search_bar.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(productsProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.addProducts);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// Header
            const SliverToBoxAdapter(
              child: DashboardHeader(shopName: "Green Grocer"),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// Search (abhi same rahega)
            SliverToBoxAdapter(
              child: ProductSearchBar(
                onChanged: (value) {
                  ref.read(productsProvider.notifier).searchProducts(value);
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// Categories (abhi same rahengi)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductFilterChip(
                      title: "All",
                      isSelected: state.selectedCategory == null,
                      onTap: () {
                        ref.read(productsProvider.notifier).clearCategory();
                      },
                    ),

                    ...state.categories.map(
                      (category) => ProductFilterChip(
                        title: category.name,
                        isSelected: state.selectedCategory?.id == category.id,
                        onTap: () {
                          ref
                              .read(productsProvider.notifier)
                              .selectCategory(category);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// Loading
            if (state.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            /// Empty
            else if (state.filteredProducts.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text("No Products Found")),
              )
            /// Product List
            else
              SliverList.builder(
                itemCount: state.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = state.filteredProducts[index];

                  return ProductCard(
                    product: product,
                    onTap: () {},
                    onEdit: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return SelectedProductBottomSheet(
                            product: product.product,
                            initialPrice: product.vendorProduct.sellingPrice,
                            initialStock: product.vendorProduct.stock,
                            initialAvailability:
                                product.vendorProduct.isAvailable,
                            onSave:
                                ({
                                  required sellingPrice,
                                  required stock,
                                  required isAvailable,
                                }) async {
                                  await ref
                                      .read(productsProvider.notifier)
                                      .updateProduct(
                                        vendorProductId:
                                            product.vendorProduct.id!,
                                        sellingPrice: sellingPrice,
                                        stock: stock,
                                        isAvailable: isAvailable,
                                      );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Product updated successfully",
                                        ),
                                      ),
                                    );
                                  }
                                },
                          );
                        },
                      );
                    },
                    onDelete: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("Delete Product"),
                            content: Text(
                              "Are you sure you want to delete ${product.product.name}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );

                      if (result == true) {
                        await ref
                            .read(productsProvider.notifier)
                            .deleteProduct(product.vendorProduct.id!);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product deleted successfully"),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
