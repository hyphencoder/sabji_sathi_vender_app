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
    if (products.isEmpty) {
      return const Center(
        child: Text(
          "No Products Found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductTile(
          product: product,
          onAdd: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) {
                return SelectedProductBottomSheet(
                  product: product,
                  onSave:
                      ({
                        required double sellingPrice,
                        required int stock,
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
                                stock: stock,
                                isAvailable: isAvailable,
                              );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product added successfully'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }

                          rethrow;
                        }
                      },
                );
              },
            );
          },
        );
      },
    );
  }
}
