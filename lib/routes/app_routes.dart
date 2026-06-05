import 'package:get/get.dart';

import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_login_view.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/user/user_home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const adminDashboard = '/admin-dashboard';
  static const userHome = '/user-home';
  static const adminLoginView = '/admin-login-view';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: adminDashboard, page: () => const AdminDashboardScreen()),
    GetPage(name: userHome, page: () => const UserHomeScreen()),
    GetPage(name: adminLoginView, page: () => const AdminLoginView()),
  ];
}
