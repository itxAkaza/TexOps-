import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';

import '../../../../../data/fireBaseAuthService/fireBase_Auth_Serivce.dart';
import '../../../../drawerScreens/scan/scan_screen.dart';
import 'components/drawerMenuItem.dart';
import 'components/drawerProfile.dart';



class MYDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String userImageUrl;

  const MYDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundLightPeach,
      child: Column(
        children: [

          DrawerProfileHeader(
            name: userName,
            email: userEmail,
            role: userRole,
            imageUrl: userImageUrl,
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerMenuItem(
                    icon: Icons.notifications_none_outlined,
                    title: "Notifications",
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.qr_code_scanner_outlined,
                    title: "Scan",
                    onTap: () {
                      Get.to(()=>TexOpsBarcodeScanner());
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: "Help and Support",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.black12, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: DrawerMenuItem(
              icon: Icons.logout_outlined,
              title: "Logout",
              color: AppColors.accentOrange,
              onTap: () {
                FirebaseAuthService.signOut();
                Get.offAllNamed(RoutesNames.loginScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}