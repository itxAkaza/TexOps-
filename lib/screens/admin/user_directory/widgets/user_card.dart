import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/data/models/user_model.dart';
import 'package:texops/resources/colors/app_colors.dart';

class UserCard extends StatelessWidget {
  final dynamic item;

  const UserCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isUser = item is UserModel;
    final String? pic = item.profilePic;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardOffWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildProfileImage(pic, item.name[0]),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryDarkTeal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  // FIXED: Changed item.generatedEmail to item.personalEmail
                  isUser ? item.personalEmail : item.email,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkTeal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  isUser ? item.role : "Vendor",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl, String fallbackChar) {
    const double radius = 28;
    const double size = radius * 2;

    final Widget fallbackWidget = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryDarkTeal,
      ),
      alignment: Alignment.center,
      child: Text(
        fallbackChar.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: (imageUrl == null || imageUrl.isEmpty)
            ? fallbackWidget
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: size.toInt() * 4,
                placeholder: (context, url) => fallbackWidget,
                errorWidget: (context, url, error) => fallbackWidget,
              ),
      ),
    );
  }
}
