import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vender_app/core/utils/storage_helper.dart';
import 'package:vender_app/features/add_product/models/vender_product_model.dart';
import 'package:vender_app/shared/models/product_model.dart';

class SelectedProductBottomSheet extends StatefulWidget {
  const SelectedProductBottomSheet({
    super.key,
    required this.product,
    required this.onSave,
    this.initialVendorProduct,
  });

  final ProductModel product;
  final VendorProductModel? initialVendorProduct;

  final Future<void> Function({
    required double sellingPrice,
    required double mrp,
    required double discountPrice,
    required int stock,
    required int minOrderQty,
    required int maxOrderQty,
    required String sku,
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

  final _mrpController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minOrderQtyController = TextEditingController();
  final _maxOrderQtyController = TextEditingController();
  final _skuController = TextEditingController();

  bool isAvailable = true;
  bool isSaving = false;

  bool get isEdit => widget.initialVendorProduct != null;

  @override
  void initState() {
    super.initState();

    final vendorProduct = widget.initialVendorProduct;

    _mrpController.text = vendorProduct?.mrp.toString() ?? '';
    _sellingPriceController.text = vendorProduct?.sellingPrice.toString() ?? '';
    _discountPriceController.text =
        vendorProduct?.discountPrice.toString() ?? '';
    _stockController.text = vendorProduct?.stock.toString() ?? '';
    _minOrderQtyController.text = vendorProduct?.minOrderQty.toString() ?? '1';
    _maxOrderQtyController.text = vendorProduct?.maxOrderQty.toString() ?? '1';
    _skuController.text =
        vendorProduct?.sku ??
        widget.product.name.toUpperCase().replaceAll(' ', '-');

    isAvailable = vendorProduct?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _mrpController.dispose();
    _sellingPriceController.dispose();
    _discountPriceController.dispose();
    _stockController.dispose();
    _minOrderQtyController.dispose();
    _maxOrderQtyController.dispose();
    _skuController.dispose();
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
                // ✅ Drag Handle
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _imagePlaceholder(colorScheme),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _imagePlaceholder(colorScheme);
                          },
                        )
                      : _imagePlaceholder(colorScheme),
                ),
                const SizedBox(height: 16),

                // ✅ Product Name
                Text(
                  widget.product.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // ✅ Product Category & Unit
                Text(
                  [
                    widget.product.categoryName,
                    widget.product.unit,
                  ].whereType<String>().join(' • '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ MRP Field
                _decimalField(
                  controller: _mrpController,
                  label: 'MRP *',
                  allowZero: false,
                ),
                const SizedBox(height: 16),

                // ✅ Selling Price Field
                _decimalField(
                  controller: _sellingPriceController,
                  label: 'Selling Price *',
                  allowZero: false,
                ),
                const SizedBox(height: 16),

                // ✅ Discount Price Field
                _decimalField(
                  controller: _discountPriceController,
                  label: 'Discount Price',
                  allowZero: true,
                ),
                const SizedBox(height: 16),

                // ✅ Stock Field
                _integerField(
                  controller: _stockController,
                  label: 'Stock *',
                  minimum: 0,
                ),
                const SizedBox(height: 16),

                // ✅ Min Order Qty Field
                _integerField(
                  controller: _minOrderQtyController,
                  label: 'Min Order Qty *',
                  minimum: 1,
                ),
                const SizedBox(height: 16),

                // ✅ Max Order Qty Field
                _integerField(
                  controller: _maxOrderQtyController,
                  label: 'Max Order Qty *',
                  minimum: 1,
                ),
                const SizedBox(height: 16),

                // ✅ SKU Field
                TextFormField(
                  controller: _skuController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'SKU *',
                    prefixIcon: Icon(Icons.qr_code_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter SKU';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ✅ Available Switch
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isAvailable,
                  title: const Text('Available'),
                  activeColor: Colors.green,
                  onChanged: isSaving
                      ? null
                      : (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                ),
                const SizedBox(height: 24),

                // ✅ Save/Update Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: isSaving ? null : _save,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(isEdit ? 'Update Product' : 'Save Product'),
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

  //==========================================
  // Decimal Field
  //==========================================

  Widget _decimalField({
    required TextEditingController controller,
    required String label,
    bool allowZero = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.currency_rupee),
      ),
      validator: (value) {
        final amount = double.tryParse(value?.trim() ?? '');
        if (amount == null) {
          return 'Enter valid $label';
        }
        if (allowZero) {
          if (amount < 0) {
            return 'Enter valid $label';
          }
        } else {
          if (amount <= 0) {
            return 'Enter valid $label';
          }
        }
        return null;
      },
    );
  }

  //==========================================
  // Integer Field
  //==========================================

  Widget _integerField({
    required TextEditingController controller,
    required String label,
    int minimum = 0,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.inventory_2_outlined),
      ),
      validator: (value) {
        final quantity = int.tryParse(value?.trim() ?? '');
        if (quantity == null || quantity < minimum) {
          return 'Enter valid $label';
        }
        return null;
      },
    );
  }

  //==========================================
  // Save Product
  //==========================================

  Future<void> _save() async {
    // ✅ Validate form
    if (!_formKey.currentState!.validate()) {
      debugPrint("❌ Form validation failed");
      return;
    }

    try {
      // ✅ Parse values
      final mrp = double.parse(_mrpController.text.trim());
      final sellingPrice = double.parse(_sellingPriceController.text.trim());
      final discountPrice = double.parse(_discountPriceController.text.trim());
      final stock = int.parse(_stockController.text.trim());
      final minOrderQty = int.parse(_minOrderQtyController.text.trim());
      final maxOrderQty = int.parse(_maxOrderQtyController.text.trim());
      final sku = _skuController.text.trim();

      debugPrint("🔄 Saving product: ${widget.product.name}");
      debugPrint("  MRP: $mrp");
      debugPrint("  Selling Price: $sellingPrice");
      debugPrint("  Discount Price: $discountPrice");
      debugPrint("  Stock: $stock");
      debugPrint("  Min Order Qty: $minOrderQty");
      debugPrint("  Max Order Qty: $maxOrderQty");
      debugPrint("  SKU: $sku");

      // ✅ Validation
      if (sellingPrice > mrp) {
        _showError('Selling price cannot be greater than MRP.');
        return;
      }

      if (discountPrice > mrp) {
        _showError('Discount price cannot be greater than MRP.');
        return;
      }

      if (stock < 0) {
        _showError('Invalid stock quantity.');
        return;
      }

      if (minOrderQty > maxOrderQty) {
        _showError(
          'Minimum order quantity cannot be greater than maximum order quantity.',
        );
        return;
      }

      // ✅ Show loading
      setState(() {
        isSaving = true;
      });

      // ✅ Save product
      await widget.onSave(
        sellingPrice: sellingPrice,
        mrp: mrp,
        discountPrice: discountPrice,
        stock: stock,
        minOrderQty: minOrderQty,
        maxOrderQty: maxOrderQty,
        sku: sku,
        isAvailable: isAvailable,
      );

      debugPrint("✅ Product saved successfully");

      // ✅ Close bottom sheet
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Product added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("❌ Error saving product: $e");

      // ✅ Show error
      if (mounted) {
        _showError('Failed to save product: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  //==========================================
  // Error Snackbar
  //==========================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  //==========================================
  // Placeholder Image
  //==========================================

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
