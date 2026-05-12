import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/Utiles/utiles.dart';
import 'package:texops/controllers/admin/user_directory_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class VendorModal extends StatelessWidget {
  final UserDirectoryController controller;

  const VendorModal({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Changed to match employee background
          color: Color(0xFFFFFBF0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          // Added physics to match employee
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Added
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HANDLE
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              /// HEADER
              Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      "Register Vendor",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF23424C),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// IMAGE PICKER
              Center(
                child: GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    final path = controller.selectedImagePath.value;
                    final hasImage = path.isNotEmpty;

                    return Container(
                      height: 86,
                      width: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Circular
                        color: const Color(0xFFFDF2E9),
                        border: Border.all(
                          color: hasImage
                              ? const Color(0xFF23424C)
                              : const Color(0xFFF5E6D3),
                          width: 2,
                        ),
                      ),
                      // Using ClipOval to ensure image stays circular
                      child: ClipOval(
                        child: hasImage
                            ? Stack(
                                children: [
                                  Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                    width: 86,
                                    height: 86,
                                  ),
                                  // Edit icon matched to employee theme
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: const EdgeInsets.all(
                                        5,
                                      ), // Small margin to keep inside border
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryDarkTeal,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Icon(
                                Icons.camera_alt_outlined,
                                size: 28,
                                color: Color(0xFFE67E22),
                              ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 22),

              /// FORM
              Form(
                key: controller.vendorFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Vendor Name"),
                    _field(
                      controller: controller.vendorName,
                      hint: "e.g Ahmed Traders",
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 14),

                    _label("Email Address"),
                    _field(
                      controller: controller.vendorEmail,
                      hint: "vendor@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Required" : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _label("Supply Type"),
              Obx(() {
                return Wrap(
                  spacing: 10,
                  children: ["Cotton", "Polyester"].map((type) {
                    final selected = controller.vendorSupplyType.value == type;

                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      selectedColor: const Color(0xFF23424C),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) {
                        controller.vendorSupplyType.value = type;
                      },
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 14),

              _label("Date Added"),
              _readOnly("Auto-set to Today"),

              const SizedBox(height: 26),

              /// BUTTON
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (!controller.vendorFormKey.currentState!
                              .validate())
                            return;

                          if (controller.vendorSupplyType.value.isEmpty) {
                            Utils.toastMesseges("Select Cotton or Polyester");
                            return;
                          }
                          if (controller.selectedImagePath.value.isEmpty) {
                            Utils.toastMesseges(
                              "Please upload a profile photo",
                            );
                            return;
                          }

                          controller.registerVendor(
                            name: controller.vendorName.text.trim(),
                            email: controller.vendorEmail.text.trim(),
                            supplyType: controller.vendorSupplyType.value,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF23424C),
                    disabledBackgroundColor: const Color.fromRGBO(
                      35,
                      66,
                      76,
                      1,
                    ).withOpacity(0.5),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          // Matched size from employee
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2, // Matched
                          ),
                        )
                      : Text(
                          "Register Vendor",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF23424C),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Completely replaced to match Employee field theme
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true, // Matched
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
        errorStyle: GoogleFonts.poppins(fontSize: 11, color: Colors.redAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF5E6D3)),
        ),
        focusedBorder: OutlineInputBorder(
          // Matched
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF23424C)),
        ),
        errorBorder: OutlineInputBorder(
          // Matched
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // Matched
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _readOnly(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFF23424C).withOpacity(0.7),
        ),
      ),
    );
  }
}
