import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/validators/app_validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordProvider);
    final provider = ref.read(forgotPasswordProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: provider.formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                const AppLogo(size: 90),

                const SizedBox(height: 24),

                Text(
                  "Reset Password",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 8),

                Text(
                  "Enter your registered email address to receive a password reset link.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 40),

                AppTextField(
                  controller: provider.emailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),

                const SizedBox(height: 32),

                AppButton(
                  text: "Send Reset Link",
                  isLoading: state.isLoading,
                  onPressed: () async {
                    try {
                      final success = await provider.sendResetLink();

                      if (!context.mounted) return;

                      if (success) {
                        AppSnackBar.show(
                          context,
                          message: "Password reset link sent successfully.",
                        );

                        context.pop();
                      }
                    } on AuthException catch (e) {
                      AppSnackBar.show(context, message: e.message);
                    } catch (_) {
                      AppSnackBar.show(
                        context,
                        message: "Something went wrong.",
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
