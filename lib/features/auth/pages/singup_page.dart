import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/signup_provider.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupProvider);
    final provider = ref.read(signupProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: provider.formKey,
            child: Column(
              children: [
                const AppLogo(size: 90),

                const SizedBox(height: 24),

                Text(
                  "Create Vendor Account",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 32),

                AppTextField(
                  controller: provider.fullNameController,
                  labelText: "Full Name",
                  hintText: "Enter full name",
                  validator: (value) => AppValidators.requiredField(
                    value,
                    fieldName: "Full Name",
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: provider.phoneController,
                  labelText: "Phone Number",
                  hintText: "Enter phone number",
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: provider.emailController,
                  labelText: "Email",
                  hintText: "Enter email",
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),

                const SizedBox(height: 16),

                ValueListenableBuilder<bool>(
                  valueListenable: provider.obscurePassword,
                  builder: (context, obscure, child) {
                    return AppTextField(
                      controller: provider.passwordController,
                      labelText: "Password",
                      hintText: "Enter password",
                      obscureText: obscure,
                      validator: AppValidators.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: provider.togglePassword,
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                ValueListenableBuilder<bool>(
                  valueListenable: provider.obscureConfirmPassword,
                  builder: (context, obscure, child) {
                    return AppTextField(
                      controller: provider.confirmPasswordController,
                      labelText: "Confirm Password",
                      hintText: "Re-enter password",
                      obscureText: obscure,
                      validator: (value) => AppValidators.confirmPassword(
                        value,
                        provider.passwordController.text,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: provider.toggleConfirmPassword,
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                AppButton(
                  text: "Create Account",
                  isLoading: state.isLoading,
                  onPressed: () async {
                    try {
                      final success = await provider.signup();

                      if (!context.mounted) return;

                      if (success) {
                        AppSnackBar.show(
                          context,
                          message: "Account created successfully.",
                        );

                        context.go(AppRoutes.login);
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

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
