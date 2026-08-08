import 'package:go_router/go_router.dart';
import 'package:vender_app/features/auth/pages/forgot_password_page.dart';
import 'package:vender_app/features/auth/pages/login_page.dart';
import 'package:vender_app/features/auth/pages/singup_page.dart';
import 'package:vender_app/features/auth/pages/splash_page.dart';
import 'package:vender_app/features/dashboard/pages/dashboard_page.dart';
import 'package:vender_app/features/shop/pages/approval_pending_page.dart';
import 'package:vender_app/features/shop/pages/shop_block_page.dart';
import 'package:vender_app/features/shop/pages/shop_rejected_page.dart';
import 'package:vender_app/features/shop/pages/shop_setup_page.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),

      GoRoute(
        path: AppRoutes.shopSetup,
        builder: (context, state) => const ShopSetupPage(),
      ),

      GoRoute(
        path: AppRoutes.approvalPending,
        builder: (context, state) => const ApprovalPendingPage(),
      ),

      GoRoute(
        path: AppRoutes.shopRejected,
        builder: (context, state) => const ShopRejectedPage(),
      ),

      GoRoute(
        path: AppRoutes.shopBlocked,
        builder: (context, state) => const ShopBlockedPage(),
      ),
    ],
  );
}
