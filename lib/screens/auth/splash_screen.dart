import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final bool isAdminLoggedIn =
        GetStorage().read<bool>('isAdminLoggedIn') ?? false;
    if (isAdminLoggedIn) {
      Get.offAllNamed(AppRoutes.adminDashboard);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAllNamed(AppRoutes.userHome);
      return;
    }

    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 100, onPrimaryBackground: true),
            const SizedBox(height: 28),
            const Text(
              'Library Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your digital library, simplified',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 56),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
