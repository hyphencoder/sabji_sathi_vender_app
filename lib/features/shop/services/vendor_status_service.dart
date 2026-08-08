import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        context.go(AppRoutes.dashboard);
        break;

      case 'rejected':
        context.go(AppRoutes.shopRejected);
        break;

      case 'blocked':
        context.go(AppRoutes.shopBlocked);
        break;

      case 'pending':
        context.go(AppRoutes.approvalPending);
        break;

      default:
        AppSnackBar.show(context, message: "Unable to fetch your shop status.");
        break;
    }
  }
}
