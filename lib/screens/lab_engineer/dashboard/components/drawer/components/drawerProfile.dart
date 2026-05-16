import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';

class DrawerProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String imageUrl;

  const DrawerProfileHeader({
    Key? key,
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl = '',
  }) : super(key: key);

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));
    if (nameParts.isEmpty || nameParts[0].isEmpty) return "U";
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return "${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        color: AppColors.primaryDarkTeal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty
                ? Text(
              _getInitials(name),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
                : null,
          ),
          const SizedBox(height: 15),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),

          Text(
            email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role,
              style: const TextStyle(
                color: AppColors.primaryDarkTeal,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}