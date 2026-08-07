import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

final loginProvider = AsyncNotifierProvider<LoginProvider, void>(
  LoginProvider.new,
);

class LoginProvider extends AsyncNotifier<void> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);

  @override
  Future<void> build() async {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
      obscurePassword.dispose();
    });
  }

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    state = const AsyncLoading();

    try {
      await AuthService.login(
        email: emailController.text.trim(),
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
}
