import 'package:flutter/material.dart';
import 'package:vender_app/core/utils/storage_helper.dart';
import 'package:vender_app/shared/models/vendor_product_details_model.dart';

import 'product_status_chip.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final VendorProductDetailsModel product;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              /// Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  StorageHelper.getProductImageUrl(product.product.image),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      product.product.categoryName ?? "",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "₹${product.vendorProduct.sellingPrice.toStringAsFixed(0)}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Stock : ${product.vendorProduct.stock}",
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 8),

                    ProductStatusChip(
                      status: !product.vendorProduct.isAvailable
                          ? ProductStatus.outOfStock
                          : product.vendorProduct.stock == 0
                          ? ProductStatus.outOfStock
                          : product.vendorProduct.stock <= 10
                          ? ProductStatus.lowStock
                          : ProductStatus.inStock,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
