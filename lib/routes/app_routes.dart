import 'package:get/get.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/user/user_home_screen.dart';
import '../bindings/auth_binding.dart';
import '../bindings/admin_binding.dart';
import '../bindings/user_binding.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const adminDashboard = '/admin-dashboard';
  static const userHome = '/user-home';

  static final pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: signup,
      page: () => const SignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardScreen(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: userHome,
      page: () => const UserHomeScreen(),
      binding: UserBinding(),
    ),
  ];
}
