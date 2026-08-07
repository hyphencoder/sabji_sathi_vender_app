import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/core/validators/app_validators.dart';
import 'package:vender_app/features/shop/providers/shop_setup_provider.dart';
import 'package:vender_app/shared/widgets/app_text_field.dart';

class ShopBankStep extends ConsumerWidget {
  const ShopBankStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bank Details", style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: 6),

        Text(
          "Payments from customer orders will be transferred to this bank account.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        AppTextField(
          controller: provider.accountHolderController,
          labelText: "Account Holder Name",
          hintText: "Enter account holder name",
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.person_outline),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.bankNameController,
          labelText: "Bank Name",
          hintText: "Enter bank name",
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.account_balance_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.accountNumberController,
          labelText: "Account Number",
          hintText: "Enter account number",
          keyboardType: TextInputType.number,
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.credit_card_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.ifscController,
          labelText: "IFSC Code",
          hintText: "SBIN0001234",
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.qr_code_2_outlined),
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
              const Icon(Icons.security_outlined),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  "Your bank details are encrypted and used only for vendor settlements.",
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
