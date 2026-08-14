import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/shared/models/product_model.dart';

import '../providers/add_product_provider.dart';
import 'product_tile.dart';
import 'selected_product_bottom_sheet.dart';

class ProductList extends ConsumerWidget {
  const ProductList({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("========== ProductList ==========");
    debugPrint("Products: ${products.length}");

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No Products Found',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    // Get vendor products to check which are already added
    final vendorProducts = ref.watch(addProductProvider).vendorProducts;
    final addedProductIds = vendorProducts.map((p) => p.productId).toSet();

    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];
        final isAdded = addedProductIds.contains(product.id);

        return ProductTile(
          product: product,
          isAdded: isAdded,
          onAdd: () {
            // ✅ SYNC callback - NO async
            if (isAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This product is already added'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            // Call without await - it's a void function
            _showAddProductBottomSheet(context, ref, product);
          },
        );
      },
    );
  }

  void _showAddProductBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ProductModel product,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (bottomSheetContext) {
        return SelectedProductBottomSheet(
          product: product,
          onSave:
              ({
                required double sellingPrice,
                required double mrp,
                required double discountPrice,
                required int stock,
                required int minOrderQty,
                required int maxOrderQty,
                required String sku,
                required bool isAvailable,
              }) async {
                try {
                  final vendorId =
                      Supabase.instance.client.auth.currentUser!.id;

                  await ref
                      .read(addProductProvider.notifier)
                      .saveVendorProduct(
                        vendorId: vendorId,
                        productId: product.id,
                        sellingPrice: sellingPrice,
                        mrp: mrp,
                        discountPrice: discountPrice,
                        stock: stock,
                        minOrderQty: minOrderQty,
                        maxOrderQty: maxOrderQty,
                        sku: sku,
                        isAvailable: isAvailable,
                      );

                  if (!bottomSheetContext.mounted) return;

                  ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Product added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Close bottom sheet
                  if (bottomSheetContext.mounted) {
                    Navigator.pop(bottomSheetContext);
                  }
                } catch (e) {
                  if (!bottomSheetContext.mounted) return;

                  ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        );
      },
    ).then((_) {
      // ✅ After bottom sheet closes, refresh products
      if (context.mounted) {
        final state = ref.read(addProductProvider);
        if (state.selectedCategory == null) {
          ref.read(addProductProvider.notifier).refresh();
        } else {
          ref.read(addProductProvider.notifier).refresh();
        }
      }
    });
  }
}
