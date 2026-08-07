import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/features/shop/providers/shop_setup_provider.dart';

class ShopLocationCard extends ConsumerWidget {
  const ShopLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Shop Location",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            const Icon(Icons.location_on, size: 60),

            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: () async {
                await provider.getCurrentLocation();
                // Next Step
              },
              icon: const Icon(Icons.my_location),
              label: const Text("Use Current Location"),
            ),
          ],
        ),
      ),
    );
  }
}
