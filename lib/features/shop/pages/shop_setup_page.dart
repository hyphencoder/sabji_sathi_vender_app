import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vender_app/features/shop/widgets/steps/shop_address_step.dart';
import 'package:vender_app/features/shop/widgets/steps/shop_bank_step.dart';
import 'package:vender_app/features/shop/widgets/steps/shop_basic_step.dart';
import 'package:vender_app/features/shop/widgets/steps/shop_document_step.dart';
import 'package:vender_app/features/shop/widgets/steps/shop_photo_step.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../providers/shop_setup_provider.dart';

class ShopSetupPage extends ConsumerStatefulWidget {
  const ShopSetupPage({super.key});

  @override
  ConsumerState<ShopSetupPage> createState() => _ShopSetupPageState();
}

class _ShopSetupPageState extends ConsumerState<ShopSetupPage> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(shopSetupProvider.notifier);
    final state = ref.watch(shopSetupProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Shop Setup"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: provider.formKey,
          child: Stepper(
            currentStep: currentStep,
            type: StepperType.vertical,
            physics: const BouncingScrollPhysics(),
            onStepContinue: () async {
              if (currentStep < 4) {
                setState(() => currentStep++);
                return;
              }

              try {
                await provider.saveShop();

                if (!mounted) return;

                context.go(AppRoutes.approvalPending);
              } catch (e) {
                AppSnackBar.show(context, message: e.toString());
              }
            },
            onStepCancel: () {
              if (currentStep > 0) {
                setState(() => currentStep--);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        text: currentStep == 4 ? "Complete Setup" : "Next",
                        isLoading: state.isLoading,
                        onPressed: details.onStepContinue,
                      ),
                    ),
                    if (currentStep > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          text: "Back",
                          type: AppButtonType.outlined,
                          onPressed: details.onStepCancel,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: const [
              Step(
                title: Text("Basic Details"),
                content: ShopBasicStep(),
                isActive: true,
              ),
              Step(
                title: Text("Photos"),
                content: ShopPhotoStep(),
                isActive: true,
              ),
              Step(
                title: Text("Address"),
                content: ShopAddressStep(),
                isActive: true,
              ),
              Step(
                title: Text("Documents"),
                content: ShopDocumentStep(),
                isActive: true,
              ),
              Step(
                title: Text("Bank Details"),
                content: ShopBankStep(),
                isActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
