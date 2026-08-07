import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/features/shop/providers/shop_setup_provider.dart';
import 'package:vender_app/shared/widgets/app_text_field.dart';

class ShopDocumentStep extends ConsumerWidget {
  const ShopDocumentStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Business Documents",
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 6),

        Text(
          "GST and PAN are optional. You can add or update them later.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        AppTextField(
          controller: provider.gstController,
          labelText: "GST Number (Optional)",
          hintText: "22AAAAA0000A1Z5",
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          prefixIcon: const Icon(Icons.receipt_long_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.panController,
          labelText: "PAN Number (Optional)",
          hintText: "ABCDE1234F",
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          prefixIcon: const Icon(Icons.badge_outlined),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  "These documents are optional during registration. "
                  "If required, the admin may ask you to upload them later for verification.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
