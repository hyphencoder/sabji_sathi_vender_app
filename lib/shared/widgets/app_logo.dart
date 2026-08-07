import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 100});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
