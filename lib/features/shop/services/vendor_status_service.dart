import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';
import 'shop_service.dart';

class VendorStatusService {
  VendorStatusService._();

  static Future<void> checkStatus(BuildContext context) async {
    final status = await ShopService.getVendorStatus();

    if (!context.mounted) return;

    switch (status) {
      case 'approved':
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashboard,
          (route) => false,
        );
        break;

      case 'rejected':
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.shopRejected,
          (route) => false,
        );
        break;

      case 'pending':
      default:
        AppSnackBar.show(context, message: "Your shop is still under review.");
        break;
    }
  }
}
