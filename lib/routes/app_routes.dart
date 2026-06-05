import 'package:get/get.dart';
import 'package:library_mangement/screens/admin/admin_login_view.dart';

import '../screens/admin/add_book_screen.dart';
import '../screens/admin/admin_book_details_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/book_saved_screen.dart';
import '../screens/admin/user_requests_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/user/book_request_screen.dart';
import '../screens/user/library_details_screen.dart';
import '../screens/user/user_home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const adminDashboard = '/admin-dashboard';
  static const userHome = '/user-home';
  static const adminLogin = '/admin-login';
  static const addBook = '/add-book';
  static const adminBookDetails = '/admin-book-details';
  static const bookSaved = '/book-saved';
  static const userRequests = '/user-requests';
  static const libraryDetails = '/library-details';
  static const bookRequest = '/book-request';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: adminDashboard, page: () => const AdminDashboardScreen()),
    GetPage(name: userHome, page: () => const UserHomeScreen()),
    GetPage(name: adminLogin, page: () => const AdminLoginView()),
    GetPage(name: addBook, page: () => const AddBookScreen()),
    GetPage(
      name: adminBookDetails,
      page: () => const AdminBookDetailsScreen(),
    ),
    GetPage(name: bookSaved, page: () => const BookSavedScreen()),
    GetPage(name: userRequests, page: () => const UserRequestsScreen()),
    GetPage(name: libraryDetails, page: () => const LibraryDetailsScreen()),
    GetPage(name: bookRequest, page: () => const BookRequestScreen()),
  ];
}
