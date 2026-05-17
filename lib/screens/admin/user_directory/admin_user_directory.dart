import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/user_directory_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/admin/user_directory/widgets/category_tabs.dart';
import 'package:texops/screens/admin/user_directory/widgets/employee_modal.dart';
import 'package:texops/screens/admin/user_directory/widgets/user_card.dart';
import 'package:texops/screens/admin/user_directory/widgets/vendor_modal.dart';

class AdminUserDirectory extends StatelessWidget {
  AdminUserDirectory({super.key});

  final UserDirectoryController controller = Get.put(UserDirectoryController());

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => controller.selectedTab.value == 2
          ? VendorModal(controller: controller)
          : EmployeeModal(controller: controller),
    );
  }

  Widget _buildList(int tab) {
    return Obx(() {
      final list = controller.filteredDataByTab(tab);

      if (list.isEmpty) {
        return Center(
          child: Text(
            tab == 2 ? "No vendors found" : "No users found",
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 80),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return UserCard(item: list[index]);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryDarkTeal),
        ),
        title: Text(
          "User Directory",
          style: GoogleFonts.poppins(
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor: AppColors.primaryDarkTeal,
          foregroundColor: AppColors.cardOffWhite,
          onPressed: () => _openModal(context),
          child: Icon(
            controller.selectedTab.value == 2
                ? Icons.store_outlined
                : Icons.person_add_alt_1_outlined,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 10),

            TextField(
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: (val) => controller.searchQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Search by name',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 10),

            CategoryTabs(controller: controller),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [_buildList(0), _buildList(1), _buildList(2)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
