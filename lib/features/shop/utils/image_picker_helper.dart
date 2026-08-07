import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  ImagePickerHelper._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> showPicker(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),

                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.camera_alt_outlined),
                  ),
                  title: const Text("Camera"),
                  subtitle: const Text("Take a new photo"),
                  onTap: () async {
                    final image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(
                      context,
                      image == null ? null : File(image.path),
                    );
                  },
                ),

                const SizedBox(height: 8),

                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.photo_library_outlined),
                  ),
                  title: const Text("Gallery"),
                  subtitle: const Text("Choose from gallery"),
                  onTap: () async {
                    final image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(
                      context,
                      image == null ? null : File(image.path),
                    );
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
