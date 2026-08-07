import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/services/auth_service.dart';

class ShopRejectedPage extends StatelessWidget {
  const ShopRejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Verification Rejected"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_rounded,
                          color: Colors.red,
                          size: 58,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Verification Rejected",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Your shop verification could not be completed because some information or documents need to be updated.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withOpacity(.20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Reason",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "The submitted documents could not be verified.\n\n"
                              "Please review your shop details, upload clear images, "
                              "and submit your application again.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      AppButton(
                        text: "Edit & Resubmit",
                        icon: const Icon(Icons.edit_document),
                        onPressed: () {
                          context.go(AppRoutes.shopSetup);
                        },
                      ),

                      const SizedBox(height: 12),

                      AppButton(
                        text: "Logout",
                        type: AppButtonType.outlined,
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await AuthService.logout();

                          if (!context.mounted) return;

                          context.go(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
