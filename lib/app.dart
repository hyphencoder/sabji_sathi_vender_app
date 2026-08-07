import 'package:flutter/material.dart';
import 'package:vender_app/core/routes/app_routers.dart';

import 'core/theme/app_theme.dart';

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sabji Vendor',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      routerConfig: AppRouter.router,
    );
  }
}
