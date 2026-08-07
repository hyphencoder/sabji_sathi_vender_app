import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../providers/shop_image_provider.dart';

class ShopPhotoStep extends ConsumerWidget {
  const ShopPhotoStep({super.key});

  Future<void> _pickImage({
    required BuildContext context,
    required WidgetRef ref,
    required bool isProfile,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile == null) return;

    final image = File(pickedFile.path);

    if (isProfile) {
      ref.read(profileImageProvider.notifier).state = image;
    } else {
      ref.read(shopImageProvider.notifier).state = image;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileImageProvider);

    final shopImage = ref.watch(shopImageProvider);

    return Column(
      children: [
        _ImageCard(
          title: "Vendor Profile Photo",
          subtitle: "Upload your profile photo",
          icon: Icons.person,
          image: profileImage,
          onTap: () => _pickImage(context: context, ref: ref, isProfile: true),
        ),

        const SizedBox(height: 20),

        _ImageCard(
          title: "Shop Photo",
          subtitle: "Upload your shop photo",
          icon: Icons.store,
          image: shopImage,
          onTap: () => _pickImage(context: context, ref: ref, isProfile: false),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final File? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = image != null;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 24),

            Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: hasImage
                          ? Image.file(
                              image!,
                              fit: BoxFit.cover,
                              width: 125,
                              height: 125,
                            )
                          : Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Icon(
                                icon,
                                size: 46,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                    ),
                  ),
                ),

                Positioned(
                  right: 4,
                  bottom: 4,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                hasImage ? "✓ Image Selected" : "No Image Selected",
                key: ValueKey(hasImage),
                style: TextStyle(
                  color: hasImage
                      ? Colors.green
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 18),

            AppButton(
              text: hasImage ? "Change Image" : "Choose Image",
              icon: Icon(hasImage ? Icons.edit : Icons.upload),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
