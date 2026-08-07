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
import '../providers/login_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final provider = ref.read(loginProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: provider.formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),

                const AppLogo(size: 100),

                const SizedBox(height: 24),

                Text(
                  "Vendor Login",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 8),

                Text(
                  "Welcome back 👋",
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

                const SizedBox(height: 16),

                ValueListenableBuilder(
                  valueListenable: provider.obscurePassword,
                  builder: (context, obscure, child) {
                    return AppTextField(
                      controller: provider.passwordController,
                      labelText: "Password",
                      hintText: "Enter your password",
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

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push(AppRoutes.forgotPassword);
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: "Login",
                  isLoading: state.isLoading,
                  onPressed: () async {
                    try {
                      final success = await provider.login();

                      if (!context.mounted) return;

                      if (success) {
                        context.go(AppRoutes.splash);
                      }
                    } on AuthException catch (e) {
                      AppSnackBar.show(context, message: e.message);
                    } catch (_) {
                      AppSnackBar.show(
                        context,
                        message: "Something went wrong",
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.signup);
                      },
                      child: const Text("Sign Up"),
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
