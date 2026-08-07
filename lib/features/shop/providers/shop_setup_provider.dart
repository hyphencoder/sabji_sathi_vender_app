import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/features/shop/providers/shop_image_provider.dart';
import 'package:vender_app/services/location_service.dart';

import '../../auth/services/auth_service.dart';
import '../models/vendor_bank_model.dart';
import '../models/vendor_model.dart';
import '../services/shop_service.dart';

final shopSetupProvider = AsyncNotifierProvider<ShopSetupProvider, void>(
  ShopSetupProvider.new,
);

class ShopSetupProvider extends AsyncNotifier<void> {
  final formKey = GlobalKey<FormState>();

  // ==========================================================
  // Basic
  // ==========================================================

  final shopNameController = TextEditingController();

  final ownerNameController = TextEditingController();

  final mobileController = TextEditingController();

  final emailController = TextEditingController();

  // ==========================================================
  // Address
  // ==========================================================

  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final stateController = TextEditingController();

  final pincodeController = TextEditingController();

  // ==========================================================
  // Documents
  // ==========================================================

  final gstController = TextEditingController();

  final panController = TextEditingController();

  // ==========================================================
  // Bank
  // ==========================================================

  final accountHolderController = TextEditingController();

  final accountNumberController = TextEditingController();

  final ifscController = TextEditingController();

  final bankNameController = TextEditingController();

  // ==========================================================
  // Location
  // ==========================================================

  double? latitude;

  double? longitude;

  @override
  Future<void> build() async {
    final profile = await AuthService.getProfile();

    ownerNameController.text = profile?['full_name'] ?? '';

    mobileController.text = profile?['phone'] ?? '';

    emailController.text = profile?['email'] ?? '';

    accountHolderController.text = profile?['full_name'] ?? '';

    ref.onDispose(() {
      shopNameController.dispose();

      ownerNameController.dispose();

      mobileController.dispose();

      emailController.dispose();

      addressController.dispose();

      cityController.dispose();

      stateController.dispose();

      pincodeController.dispose();

      gstController.dispose();

      panController.dispose();

      accountHolderController.dispose();

      accountNumberController.dispose();

      ifscController.dispose();

      bankNameController.dispose();
    });
  }

  // ==========================================================
  // Location
  // ==========================================================

  void updateLocation({required double lat, required double lng}) {
    latitude = lat;
    longitude = lng;
  }

  Future<void> getCurrentLocation() async {
    try {
      final data = await LocationService.getAddressFromLocation();

      if (data == null) return;

      latitude = data['latitude'];
      longitude = data['longitude'];

      addressController.text = data['address'];
      cityController.text = data['city'];
      stateController.text = data['state'];
      pincodeController.text = data['pincode'];

      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // ==========================================================
  // Load Existing Shop
  // ==========================================================

  Future<void> loadExistingShop() async {
    try {
      final shop = await ShopService.getShop();

      if (shop == null) return;

      shopNameController.text = shop.shopName;

      ownerNameController.text = shop.ownerName;

      mobileController.text = shop.mobile;

      emailController.text = shop.email ?? '';

      addressController.text = shop.address;

      cityController.text = shop.city;

      stateController.text = shop.state;

      pincodeController.text = shop.pincode;

      gstController.text = shop.gstNumber ?? '';

      panController.text = shop.panNumber ?? '';

      latitude = shop.latitude;

      longitude = shop.longitude;

      state = AsyncData(state.value);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // ==========================================================
  // Reset Form
  // ==========================================================

  void resetForm() {
    shopNameController.clear();

    ownerNameController.clear();

    mobileController.clear();

    emailController.clear();

    addressController.clear();

    cityController.clear();

    stateController.clear();

    pincodeController.clear();

    gstController.clear();

    panController.clear();

    accountHolderController.clear();

    accountNumberController.clear();

    ifscController.clear();

    bankNameController.clear();

    latitude = null;

    longitude = null;

    state = AsyncData(state.value);
  }

  // ==========================================================
  // Save Shop
  // ==========================================================

  Future<void> saveShop() async {
    if (!formKey.currentState!.validate()) return;

    state = const AsyncLoading();

    try {
      final user = AuthService.currentUser!;

      final vendor = VendorModel(
        id: user.id,
        shopName: shopNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        mobile: mobileController.text.trim(),
        email: emailController.text.trim(),

        // Images
        profileImage: null,
        shopImage: null,

        // Address
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),

        // Location
        latitude: latitude,
        longitude: longitude,

        // Documents
        gstNumber: gstController.text.trim().isEmpty
            ? null
            : gstController.text.trim(),

        panNumber: panController.text.trim().isEmpty
            ? null
            : panController.text.trim(),

        status: 'pending',
        shopCompleted: false,

        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final bank = VendorBankModel(
        vendorId: user.id,
        accountHolder: accountHolderController.text.trim(),
        bankName: bankNameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        ifscCode: ifscController.text.trim().toUpperCase(),
      );

      final profileImage = ref.read(profileImageProvider);
      final shopImage = ref.read(shopImageProvider);

      await ShopService.createCompleteShop(
        vendor: vendor,
        bank: bank,
        profileImage: profileImage,
        shopImage: shopImage,
      );

      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}
