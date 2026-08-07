import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../providers/splash_provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashProvider);

    splashState.whenData((status) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        switch (status) {
          case SplashStatus.login:
            context.go(AppRoutes.login);
            break;

          case SplashStatus.shopSetup:
            context.go(AppRoutes.shopSetup);
            break;

          case SplashStatus.approvalPending:
            context.go(AppRoutes.approvalPending);
            break;

          case SplashStatus.dashboard:
            context.go(AppRoutes.dashboard);
            break;

          case SplashStatus.shopRejected:
            context.go(AppRoutes.shopRejected);
            break;

          case SplashStatus.loading:
            break;
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: 110),
                const SizedBox(height: 24),
                Text(
                  'Sabji Vendor',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fresh • Organic • Fast Delivery',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                const AppLoader(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
