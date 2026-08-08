import 'package:flutter/material.dart';
import 'package:vender_app/core/utils/storage_helper.dart';

import '../models/product_model.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, this.onAdd});

  final ProductModel product;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageUrl = StorageHelper.getProductImageUrl(product.image);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return _imagePlaceholder(colorScheme);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _imagePlaceholder(colorScheme);
                      },
                    )
                  : _imagePlaceholder(colorScheme),
            ),

            const SizedBox(width: 14),

            /// Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product.categoryName ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.unit,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.image_outlined, color: colorScheme.outline),
    );
  }
}
