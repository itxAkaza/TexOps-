import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      body: Stack(
        children: [
          // ── DARK TEAL TOP ZONE ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.44,
            child: Container(
              color: AppColors.primaryDarkTeal,
              child: Stack(
                children: [
                  // Geometric ring 1
                  Positioned(
                    top: -70,
                    right: -70,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentOrange.withOpacity(0.15),
                          width: 40,
                        ),
                      ),
                    ),
                  ),
                  // Geometric ring 2
                  Positioned(
                    top: 36,
                    right: 22,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentOrange.withOpacity(0.1),
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                  // Bottom soft blob
                  Positioned(
                    bottom: -50,
                    left: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentOrange.withOpacity(0.07),
                      ),
                    ),
                  ),
                  // Dot grid
                  Positioned(
                    bottom: 24,
                    right: 20,
                    child: _DotGrid(),
                  ),
                ],
              ),
            ),
          ),

          // ── SAFE AREA CONTENT ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accentOrange, Color(0xFFFF8C2A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "T",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          children: const [
                            TextSpan(text: "Tex"),
                            TextSpan(
                              text: "Ops",
                              style: TextStyle(color: AppColors.accentOrange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Hero Text
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Mill Management",
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, AppColors.accentOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          "Welcome\nBack, Boss.",
                          style: GoogleFonts.poppins(
                            color: Colors.white, // must be white for ShaderMask to work
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accentOrange.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "🏭  Textile ERP Platform",
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── WHITE CARD ──
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: size.height * 0.04),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 34, 24, 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email
                            _fieldLabel("Email Address"),
                            const SizedBox(height: 8),
                            _buildField(
                              ctrl: controller.emailController,
                              hint: "you@texops.com",
                              icon: Icons.mail_outline_rounded,
                              type: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return "Email is required";
                                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Password
                            _fieldLabel("Password"),
                            const SizedBox(height: 8),
                            Obx(() => _buildField(
                              ctrl: controller.passwordController,
                              hint: "••••••••",
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              obscure: controller.hidePassword.value,
                              onToggle: controller.togglePassword,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return "Password is required";
                                if (v.trim().length < 6) return "Minimum 6 characters";
                                return null;
                              },
                            )),

                            // Forgot
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.to(() => ForgotPasswordScreen()),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.accentOrange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ── LOGIN BUTTON ──
                            Obx(() => SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.accentOrange,
                                  borderRadius: BorderRadius.circular(17),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentOrange.withOpacity(0.3),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: AppColors.primaryDarkTeal.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.login();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                      : Text(
                                    "LOGIN  →",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            )),

                            const SizedBox(height: 28),

                            // Bottom note

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
    text.toUpperCase(),
    style: GoogleFonts.poppins(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryDarkTeal,
      letterSpacing: 0.9,
    ),
  );

  Widget _buildField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    TextInputType type = TextInputType.text,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: validator,
      keyboardType: type,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: GoogleFonts.poppins(
        color: AppColors.primaryDarkTeal,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textFormText,
          fontSize: 13.5,
        ),
        filled: true,
        fillColor: AppColors.backgroundLightPeach.withOpacity(0.5),
        prefixIcon: Icon(icon, color: AppColors.primaryDarkTeal.withOpacity(0.7), size: 21),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textGrey,
            size: 20,
          ),
          onPressed: onToggle,
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accentOrange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }
}

// Decorative dot grid
class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (row) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: List.generate(5, (col) => Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          )),
        ),
      )),
    );
  }
}