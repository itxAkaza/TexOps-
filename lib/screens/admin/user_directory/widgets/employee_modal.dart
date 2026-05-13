import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/Utiles/utiles.dart';
import 'package:texops/controllers/admin/user_directory_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class EmployeeModal extends StatelessWidget {
  final UserDirectoryController controller;

  const EmployeeModal({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBF0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DRAG HANDLE
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

              Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      "Register User",
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
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 50), () {
                        Navigator.pop(context);
                      });
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

              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Obx(() {
                        final path = controller.selectedImagePath.value;
                        final hasImage = path.isNotEmpty;

                        return Container(
                          height: 86,
                          width: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFDF2E9),
                            border: Border.all(
                              color: hasImage
                                  ? const Color(0xFF23424C)
                                  : const Color(0xFFF5E6D3),
                              width: 2,
                            ),
                            image: hasImage
                                ? DecorationImage(
                                    image: FileImage(File(path)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: hasImage
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
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
                                )
                              : const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 28,
                                  color: Color(0xFFE67E22),
                                ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        controller.selectedImagePath.value.isEmpty
                            ? "Upload Photo"
                            : "Tap to change",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// FORM
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Full Name"),
                    _field(
                      controller: controller.name,
                      hint: "e.g Ali Ahmed",
                      keyboardType: TextInputType.name,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Full name is required";
                        }
                        if (v.trim().length < 3) {
                          return "Name must be at least 3 characters";
                        }
                        if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(v.trim())) {
                          return "Name must contain letters only";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    _label("Email Address"),
                    _field(
                      controller: controller.email,
                      hint: "name@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex = RegExp(
                          r"^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$",
                        );
                        if (!emailRegex.hasMatch(v.trim())) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _label("Role"),
              _dropdown(),

              const SizedBox(height: 14),

              _label("Date Joined"),
              _readOnly("Auto-set to Today"),

              const SizedBox(height: 26),

              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (controller.formKey.currentState!.validate()) {
                            if (controller.selectedImagePath.value.isEmpty) {
                              Utils.toastMesseges(
                                "Please upload a profile photo",
                              );
                              return;
                            }
                            if (controller.role.value.isEmpty) {
                              Utils.toastMesseges("Please select a role");
                              return;
                            }
                            controller.registerUser(
                              name: controller.name.text.trim(),
                              role: controller.role.value,
                              personalEmail: controller.email.value.text,
                            );
                          }
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
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Register User",
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
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
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
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF23424C)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _dropdown() {
    final roles = ["Lab Engineer", "Quality Engineer"];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5E6D3)),
      ),
      child: Obx(() {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.role.value.isEmpty ? null : controller.role.value,
            isExpanded: true,
            hint: Text(
              "Select Role",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
            ),
            items: roles
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: GoogleFonts.poppins(fontSize: 13)),
                  ),
                )
                .toList(),
            onChanged: (val) => controller.role.value = val ?? '',
          ),
        );
      }),
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
