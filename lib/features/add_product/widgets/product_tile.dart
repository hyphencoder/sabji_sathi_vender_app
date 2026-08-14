import 'package:flutter/material.dart';
import 'package:vender_app/core/utils/storage_helper.dart';
import 'package:vender_app/shared/models/product_model.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    this.onAdd,
    this.isAdded = false,
  });

  final ProductModel product;
  final VoidCallback? onAdd;
  final bool isAdded;

  @override
  Widget build(BuildContext context) {
    debugPrint("Building Tile : ${product.name}");
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

            /// Add Button with State
            _buildAddButton(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme, ColorScheme colorScheme) {
    if (isAdded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 18),
            const SizedBox(width: 4),
            Text(
              "Added",
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add, size: 18),
      label: const Text("Add"),
      style: FilledButton.styleFrom(
        minimumSize: const Size(80, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
