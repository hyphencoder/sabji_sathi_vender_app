import 'package:flutter/material.dart';
import 'package:vender_app/core/utils/storage_helper.dart';
import 'package:vender_app/shared/models/product_model.dart';

class SelectedProductBottomSheet extends StatefulWidget {
  const SelectedProductBottomSheet({
    super.key,
    required this.product,
    required this.onSave,
    this.initialPrice,
    this.initialStock,
    this.initialAvailability,
  });

  final ProductModel product;

  final double? initialPrice;
  final int? initialStock;
  final bool? initialAvailability;

  final Future<void> Function({
    required double sellingPrice,
    required int stock,
    required bool isAvailable,
  })
  onSave;

  @override
  State<SelectedProductBottomSheet> createState() =>
      _SelectedProductBottomSheetState();
}

class _SelectedProductBottomSheetState
    extends State<SelectedProductBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  bool isAvailable = true;
  bool isSaving = false;

  bool get isEdit => widget.initialPrice != null;

  @override
  void initState() {
    super.initState();

    _priceController.text = widget.initialPrice?.toString() ?? '';

    _stockController.text = widget.initialStock?.toString() ?? '';

    isAvailable = widget.initialAvailability ?? true;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageUrl = StorageHelper.getProductImageUrl(widget.product.image);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _imagePlaceholder(colorScheme);
                          },
                        )
                      : _imagePlaceholder(colorScheme),
                ),

                const SizedBox(height: 16),

                Text(
                  widget.product.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.product.categoryName ?? "",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.product.unit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (widget.product.description != null &&
                    widget.product.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],

                const SizedBox(height: 24),

                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Selling Price",
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter selling price";
                    }

                    final price = double.tryParse(value);

                    if (price == null || price <= 0) {
                      return "Enter valid price";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Stock",
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter stock";
                    }

                    final stock = int.tryParse(value);

                    if (stock == null || stock < 0) {
                      return "Enter valid stock";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isAvailable,
                  title: const Text("Available"),
                  onChanged: isSaving
                      ? null
                      : (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            setState(() {
                              isSaving = true;
                            });

                            try {
                              await widget.onSave(
                                sellingPrice: double.parse(
                                  _priceController.text.trim(),
                                ),
                                stock: int.parse(_stockController.text.trim()),
                                isAvailable: isAvailable,
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isSaving = false;
                                });
                              }
                            }
                          },
                    child: isSaving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(isEdit ? "Update Product" : "Save Product"),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.image_outlined, size: 40),
    );
  }
}
