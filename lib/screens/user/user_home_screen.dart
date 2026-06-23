import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/library_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/user_home_controller.dart';
import '../../models/book_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(UserHomeController());
    Get.put(LibraryController());
    Get.put(ProfileController());

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(navController.currentIndex.value),
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: const [_HomeTab(), _ProfileTab()],
        ),
        bottomNavigationBar: _UserBottomNav(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeTab,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int index) {
    if (index == 0) {
      return AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        title: const Row(
          children: [
            Icon(Icons.library_books_rounded, color: Colors.white, size: 22),
            SizedBox(width: 10),
            Text(
              'Library Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,

      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _UserBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _UserBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 80.w, right: 80.w, bottom: 16.h),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: "Home",
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            SizedBox(width: 8.w),
            _NavItem(
              icon: Icons.person_rounded,
              label: "Profile",
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.r,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isSelected
                  ? Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        label,
                        key: ValueKey(label),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LibraryController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discover Books',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  controller.isLoading.value
                      ? 'Loading your library...'
                      : '${controller.filteredBooks.length} book${controller.filteredBooks.length == 1 ? '' : 's'} available',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.searchController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search books by title or author...',
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (controller.filteredBooks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.menu_book_outlined,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No books found',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.searchController.text.trim().isEmpty
                            ? 'Books added by admin will appear here'
                            : 'Try a different search term',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              itemCount: controller.filteredBooks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final book = controller.filteredBooks[index];
                return _BookListTile(book: book);
              },
            );
          }),
        ),
      ],
    );
  }
}

class _BookListTile extends StatelessWidget {
  final BookModel book;

  const _BookListTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.libraryDetails, arguments: book),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                BookCoverWidget(
                  title: book.title,
                  imageUrl: book.coverImageUrl,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.initials,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                controller.nameController.text.isEmpty
                    ? 'Student'
                    : controller.nameController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  controller.email.value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _ProfileSection(
                title: 'Personal Information',
                child: Column(
                  children: [
                    _buildLabel('Full Name'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: controller.nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.textHint,
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Student ID'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: controller.studentIdController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. 2021-CS-45',
                        prefixIcon: Icon(
                          Icons.badge_outlined,
                          color: AppColors.textHint,
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Student ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.updateProfile,
                  icon: controller.isSaving.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save_outlined, size: 20),
                  label: Text(
                    controller.isSaving.value ? 'Saving...' : 'Save Changes',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ProfileSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
