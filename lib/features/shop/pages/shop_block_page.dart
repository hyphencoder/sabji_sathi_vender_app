import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vender_app/features/shop/services/vendor_status_service.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/services/auth_service.dart';
import '../services/shop_service.dart';

class ShopBlockedPage extends StatefulWidget {
  const ShopBlockedPage({super.key});

  @override
  State<ShopBlockedPage> createState() => _ShopBlockedPageState();
}

class _ShopBlockedPageState extends State<ShopBlockedPage> {
  String? _reason;

  @override
  void initState() {
    super.initState();
    _loadReason();
  }

  Future<void> _loadReason() async {
    final vendor = await ShopService.getShop();

    if (!mounted) return;

    setState(() {
      _reason = vendor?.blockReason;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Blocked"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.orange.shade100,
                        child: const Icon(
                          Icons.block,
                          color: Colors.orange,
                          size: 60,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Shop Temporarily Blocked",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Your shop has been temporarily blocked by the admin.",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Block Reason",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(_reason ?? "No reason provided."),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

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
