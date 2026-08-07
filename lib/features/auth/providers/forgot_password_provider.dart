import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

final forgotPasswordProvider =
    AsyncNotifierProvider<ForgotPasswordProvider, void>(
      ForgotPasswordProvider.new,
    );

class ForgotPasswordProvider extends AsyncNotifier<void> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;

  @override
  Future<void> build() async {
    emailController = TextEditingController();

    ref.onDispose(() {
      emailController.dispose();
    });
  }

  Future<bool> sendResetLink() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    state = const AsyncLoading();

    try {
      await AuthService.forgotPassword(email: emailController.text.trim());

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
}
