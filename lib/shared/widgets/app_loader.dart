import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 28, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? AppColors.primary,
      ),
    );
  }
}
