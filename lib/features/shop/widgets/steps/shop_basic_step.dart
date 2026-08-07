import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/core/validators/app_validators.dart';
import 'package:vender_app/features/shop/providers/shop_setup_provider.dart';
import 'package:vender_app/shared/widgets/app_text_field.dart';

class ShopBasicStep extends ConsumerWidget {
  const ShopBasicStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Basic Information",
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 6),

        Text(
          "Enter your shop details.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        AppTextField(
          controller: provider.shopNameController,
          labelText: "Shop Name",
          hintText: "Enter shop name",
          prefixIcon: const Icon(Icons.store_outlined),
          validator: AppValidators.requiredField,
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.ownerNameController,
          labelText: "Owner Name",
          hintText: "Owner name",
          readOnly: true,
          prefixIcon: const Icon(Icons.person_outline),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.mobileController,
          labelText: "Mobile Number",
          hintText: "Mobile number",
          keyboardType: TextInputType.phone,
          readOnly: true,
          prefixIcon: const Icon(Icons.phone_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.emailController,
          labelText: "Email Address",
          hintText: "Email address",
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
          prefixIcon: const Icon(Icons.email_outlined),
        ),

        const SizedBox(height: 10),

        Text(
          "Owner details are taken from your vendor account. You can edit them later from your profile.",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
