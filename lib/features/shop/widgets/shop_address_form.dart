import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/validators/app_validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/shop_setup_provider.dart';

class ShopAddressForm extends ConsumerWidget {
  const ShopAddressForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Address", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 20),

            AppTextField(
              controller: provider.addressController,
              labelText: "Address",
              validator: AppValidators.requiredField,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.cityController,
              labelText: "City",
              validator: AppValidators.requiredField,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.stateController,
              labelText: "State",
              validator: AppValidators.requiredField,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: provider.pincodeController,
              labelText: "Pincode",
              keyboardType: TextInputType.number,
              validator: AppValidators.requiredField,
            ),
          ],
        ),
      ),
    );
  }
}
