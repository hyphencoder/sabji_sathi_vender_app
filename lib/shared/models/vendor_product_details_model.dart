import 'package:vender_app/features/add_product/models/vender_product_model.dart';
import 'package:vender_app/shared/models/product_model.dart';

class VendorProductDetailsModel {
  const VendorProductDetailsModel({
    required this.vendorProduct,
    required this.product,
  });

  final VendorProductModel vendorProduct;
  final ProductModel product;

  VendorProductDetailsModel copyWith({
    VendorProductModel? vendorProduct,
    ProductModel? product,
  }) {
    return VendorProductDetailsModel(
      vendorProduct: vendorProduct ?? this.vendorProduct,
      product: product ?? this.product,
    );
  }
}
