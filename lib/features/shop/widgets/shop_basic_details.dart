import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/validators/app_validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/shop_setup_provider.dart';

class ShopBasicDetails extends ConsumerWidget {
  const ShopBasicDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Basic Details",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            AppTextField(
              controller: provider.shopNameController,
              labelText: "Shop Name",
              validator: AppValidators.requiredField,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.ownerNameController,
              labelText: "Owner Name",
              validator: AppValidators.requiredField,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.mobileController,
              labelText: "Mobile",
              keyboardType: TextInputType.phone,
              validator: AppValidators.phone,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.emailController,
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.email,
            ),
          ],
        ),
      ),
    );
  }
}
