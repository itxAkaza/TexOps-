import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/chat_bot/chat_bot_screen.dart';
import 'package:texops/screens/lab_engineer/dashboard/components/drawer/drawer.dart';
import 'package:texops/screens/drawerScreens/notification_screen.dart';
import '../../controllers/quality_testing/quality_dashboard.dart';

class QualityPersondashboard extends StatelessWidget {
  QualityPersondashboard({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QualityDashboardController());

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.backgroundLightPeach,
      drawer: Obx(() => MYDrawer(
          userName: controller.userName.value,
          userEmail: controller.userEmail.value,
          userRole: controller.userRole.value,
          userImageUrl: controller.userProfilePic.value)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // HEADER ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState?.openDrawer(),
                        child: Obx(() => CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.primaryDarkTeal,
                          backgroundImage: controller.userProfilePic.value.isNotEmpty
                              ? NetworkImage(controller.userProfilePic.value) : null,
                          child: controller.userProfilePic.value.isEmpty
                              ? const Icon(Icons.person, color: Colors.white) : null,
                        )),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            controller.userName.value,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal),
                          )),
                          Obx(() => Text(
                            controller.userRole.value,
                            style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                          )),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_active_outlined, color: AppColors.accentOrange, size: 28),
                    onPressed: () => Get.to(() => const NotificationsScreen()),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // STATS CONTAINERS
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.pending_actions, color: Colors.white),
                          const SizedBox(height: 10),
                          const Text("Pending Tests", style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Obx(() => Text("${controller.pendingBales.length}",
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.primaryDarkTeal, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.verified, color: Colors.white),
                          const SizedBox(height: 10),
                          const Text("Completed", style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Obx(() => Text("${controller.completedBales.length}",
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // TAB TOGGLE
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.switchTab(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: controller.isPendingTab.value ? AppColors.backgroundLightPeach : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text("Pending Bales",
                              style: TextStyle(fontWeight: FontWeight.bold, color: controller.isPendingTab.value ? AppColors.accentOrange : AppColors.textGrey))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.switchTab(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !controller.isPendingTab.value ? AppColors.primaryDarkTeal.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text("Tested Bales",
                              style: TextStyle(fontWeight: FontWeight.bold, color: !controller.isPendingTab.value ? AppColors.primaryDarkTeal : AppColors.textGrey))),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(height: 20),

              // LIST VIEW
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.builder(itemCount: 4, itemBuilder: (context, index) => _buildShimmerTile());
                  }

                  var currentList = controller.isPendingTab.value ? controller.pendingBales : controller.completedBales;

                  if (currentList.isEmpty) {
                    return const Center(child: Text("No bales found in this category.", style: TextStyle(color: AppColors.textGrey)));
                  }

                  return ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      var bale = currentList[index];
                      return _buildBaleTile(bale, controller.isPendingTab.value);
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
        Get.to(()=>ChatBotScreen());
      },
        backgroundColor: AppColors.accentOrange,
      child: Icon(
        Iconsax.gps5,
        size: 30,
        color: AppColors.primaryDarkTeal,
      ),

      ),
    );
  }

  Widget _buildBaleTile(Map<String, dynamic> bale, bool isPending) {
    return GestureDetector(
      onTap: () {
        // Navigates directly to your friend's screen with the correct data!
        Get.toNamed(RoutesNames.qualityChooseCategory, arguments: {
          'baleRecordId': bale['baleRecordId'],
          'baleId': bale['baleId'],
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border(left: BorderSide(color: isPending ? AppColors.accentOrange : AppColors.primaryDarkTeal, width: 5)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isPending ? AppColors.accentOrange.withOpacity(0.1) : AppColors.primaryDarkTeal.withOpacity(0.1),
              child: Icon(isPending ? Icons.science_outlined : Icons.check_circle_outline, color: isPending ? AppColors.accentOrange : AppColors.primaryDarkTeal),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bale['supplier'] ?? 'Unknown Supplier', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("GatePass: #${bale['gatePassRef'] ?? bale['baleId'] ?? 'N/A'}", style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400)
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 100, height: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}