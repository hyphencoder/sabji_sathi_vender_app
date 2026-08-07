import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_text_field.dart';
import '../providers/shop_setup_provider.dart';

class ShopDocumentForm extends ConsumerWidget {
  const ShopDocumentForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Documents (Optional)",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            AppTextField(
              controller: provider.gstController,
              labelText: "GST Number",
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.panController,
              labelText: "PAN Number",
            ),
          ],
        ),
      ),
    );
  }
}
