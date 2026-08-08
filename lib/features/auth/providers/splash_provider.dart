import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/services/auth_service.dart';
import '../../shop/services/shop_service.dart';

enum SplashStatus {
  login,
  shopSetup,
  approvalPending,
  dashboard,
  shopRejected,
  shopBlocked,
}

final splashProvider = AsyncNotifierProvider<SplashProvider, SplashStatus>(
  SplashProvider.new,
);

class SplashProvider extends AsyncNotifier<SplashStatus> {
  @override
  Future<SplashStatus> build() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!AuthService.isLoggedIn) {
      return SplashStatus.login;
    }

    final profile = await AuthService.getProfile();

    if (profile == null) {
      return SplashStatus.login;
    }

    final hasShop = await ShopService.hasShop();

    if (!hasShop) {
      return SplashStatus.shopSetup;
    }

    final status = await ShopService.getVendorStatus();

    switch (status) {
      case 'approved':
        return SplashStatus.dashboard;

      case 'pending':
        return SplashStatus.approvalPending;

      case 'rejected':
        return SplashStatus.shopRejected;

      case 'blocked':
        return SplashStatus.shopBlocked;

      default:
        return SplashStatus.shopSetup;
    }
  }
}
