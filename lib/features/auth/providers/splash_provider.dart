import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shop/services/shop_service.dart';
import '../services/auth_service.dart';

enum SplashStatus {
  loading,
  login,
  shopSetup,
  approvalPending,
  shopRejected,
  dashboard,
}

final splashProvider = AsyncNotifierProvider<SplashProvider, SplashStatus>(
  SplashProvider.new,
);

class SplashProvider extends AsyncNotifier<SplashStatus> {
  @override
  Future<SplashStatus> build() async {
    return _checkSession();
  }

  Future<SplashStatus> _checkSession() async {
    try {
      debugPrint("========== SPLASH START ==========");

      await Future.delayed(const Duration(seconds: 1));

      debugPrint("Current Session : ${AuthService.currentSession != null}");

      debugPrint("Current User : ${AuthService.currentUser?.id}");

      if (!AuthService.isLoggedIn) {
        debugPrint("❌ User Not Logged In");
        return SplashStatus.login;
      }

      final profile = await AuthService.getProfile();

      debugPrint("Profile : $profile");

      if (profile == null) {
        debugPrint("❌ Profile Not Found");

        await AuthService.logout();

        return SplashStatus.login;
      }

      debugPrint("Role : ${profile['role']}");
      debugPrint("Active : ${profile['is_active']}");

      if (profile['role'] != 'vendor') {
        debugPrint("❌ Invalid Role");

        await AuthService.logout();

        return SplashStatus.login;
      }

      if (profile['is_active'] != true) {
        debugPrint("❌ Account Disabled");

        await AuthService.logout();

        return SplashStatus.login;
      }

      /// ============================
      /// Vendors Table Check
      /// ============================

      final vendor = await ShopService.getShop();

      debugPrint("Vendor : $vendor");

      if (vendor == null) {
        debugPrint("➡ Vendor Record Not Found");

        return SplashStatus.shopSetup;
      }

      if (!vendor.shopCompleted) {
        debugPrint("➡ Shop Setup Pending");

        return SplashStatus.shopSetup;
      }

      switch (vendor.status) {
        case 'approved':
          debugPrint("➡ Shop Approved");
          return SplashStatus.dashboard;

        case 'rejected':
          debugPrint("➡ Shop Rejected");
          return SplashStatus.shopRejected;

        case 'pending':
        default:
          debugPrint("➡ Shop Pending Approval");
          return SplashStatus.approvalPending;
      }
    } catch (e, s) {
      debugPrint("SPLASH ERROR : $e");
      debugPrintStack(stackTrace: s);

      await AuthService.logout();

      return SplashStatus.login;
    }
  }

  Future<void> refreshSession() async {
    state = const AsyncLoading();

    state = AsyncData(await _checkSession());
  }
}
