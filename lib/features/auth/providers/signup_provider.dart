import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

final signupProvider = AsyncNotifierProvider<SignupProvider, void>(
  SignupProvider.new,
);

class SignupProvider extends AsyncNotifier<void> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> obscureConfirmPassword = ValueNotifier(true);

  @override
  Future<void> build() async {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    ref.onDispose(() {
      fullNameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();

      obscurePassword.dispose();
      obscureConfirmPassword.dispose();
    });
  }

  Future<bool> signup() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    state = const AsyncLoading();

    try {
      await AuthService.signup(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      state = const AsyncData(null);
      return true;
    } on AuthException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
}
