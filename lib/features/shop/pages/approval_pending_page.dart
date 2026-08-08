import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vender_app/features/shop/services/vendor_status_service.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/services/auth_service.dart';

class ApprovalPendingPage extends StatelessWidget {
  const ApprovalPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Verification Pending"),
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
                          color: Colors.green.withOpacity(.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fact_check_rounded,
                          size: 58,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Verification Submitted!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Your shop details and documents have been submitted successfully.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.green.withOpacity(.20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.pending_actions_rounded,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Under Review",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Our verification team is reviewing your shop details and documents.\n\n"
                              "This process usually takes 24-48 hours. "
                              "You'll be notified once your shop is approved.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      AppButton(
                        text: "Refresh Status",
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await VendorStatusService.checkStatus(context);
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
