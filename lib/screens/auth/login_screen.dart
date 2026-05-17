import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/auth/auth_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/auth/forgot_password.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              SizedBox(
                height: screenHeight * 0.28,
                width: double.infinity,
                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Login to Access Your",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDarkTeal,
                      ),
                    ),
                    Text(
                      "Mill Operations",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accentOrange,
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildTextField(
                      controller: controller.emailController,
                      hintText: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex = RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => _buildTextField(
                        controller: controller.passwordController,
                        hintText: "Enter your password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: controller.hidePassword.value,
                        toggleVisibility: () => controller.togglePassword(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          }
                          if (value.trim().length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.to(() => ForgotPasswordScreen()),
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryDarkTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.login();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDarkTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: GoogleFonts.poppins(
        color: AppColors.primaryDarkTeal,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryDarkTeal),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.primaryDarkTeal.withOpacity(0.6),
                  size: 20,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primaryDarkTeal,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.accentOrange,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        errorStyle: GoogleFonts.poppins(
          color: Colors.redAccent.shade400,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
