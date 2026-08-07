import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/core/validators/app_validators.dart';
import 'package:vender_app/features/shop/providers/shop_setup_provider.dart';
import 'package:vender_app/shared/widgets/app_text_field.dart';

class ShopAddressStep extends ConsumerWidget {
  const ShopAddressStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(shopSetupProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shop Address", style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: 6),

        Text(
          "Enter your shop location.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        AppTextField(
          controller: provider.addressController,
          labelText: "Full Address",
          hintText: "House No, Street, Area",
          maxLines: 3,
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.location_on_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.cityController,
          labelText: "City",
          hintText: "Enter city",
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.location_city_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.stateController,
          labelText: "State",
          hintText: "Enter state",
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.map_outlined),
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: provider.pincodeController,
          labelText: "Pincode",
          hintText: "Enter pincode",
          keyboardType: TextInputType.number,
          validator: AppValidators.requiredField,
          prefixIcon: const Icon(Icons.pin_drop_outlined),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await provider.getCurrentLocation();
              // Next step me current location connect karenge
            },
            icon: const Icon(Icons.my_location),
            label: const Text("Use Current Location"),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Current location support will automatically fill latitude and longitude.",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
