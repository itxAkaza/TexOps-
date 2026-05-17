import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/Utiles/utiles.dart';
import 'package:texops/data/fireBaseAuthService/fireBase_Auth_Serivce.dart';
import 'package:texops/data/fireStoreDB/role_firestore_service.dart';
import 'package:texops/resources/route/routes_names.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final RoleFirestoreService _roleFirestoreService = RoleFirestoreService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isResetLoading = false.obs;
  final RxBool hidePassword = true.obs;

  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  /// Logs in users natively using their real personal email address
  Future<void> login() async {
    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Utils.toastMesseges("Please enter your credentials");
      return;
    }

    try {
      isLoading.value = true;

      final UserCredential? userCredential = await _authService.signIn(
        email: email,
        pass: password,
      );

      if (userCredential?.user == null) {
        Utils.toastMesseges("Login failed");
        return;
      }

      // Route check using the UID document assignment in Firestore
      final doc = await _roleFirestoreService.getUserDoc(
        userCredential!.user!.uid,
      );

      if (!doc.exists) {
        Utils.toastMesseges("User profile not found");
        return;
      }

      final String role = (doc['role'] ?? "").toString();
      navigateOnRole(role);
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          msg = "Invalid email or password";
          break;
        case 'invalid-email':
          msg = "Please enter a valid email address";
          break;
        case 'user-disabled':
          msg = "This account has been suspended";
          break;
        case 'too-many-requests':
          msg = "Too many failed attempts. Try again later.";
          break;
        default:
          msg = e.message ?? "Authentication error";
      }
      Utils.toastMesseges(msg);
    } catch (e) {
      Utils.toastMesseges("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Sends an official Firebase reset link directly to the user's real email inbox
  Future<void> handleForgotPassword(String emailText) async {
    final String email = emailText.trim().toLowerCase();

    if (email.isEmpty) {
      Utils.toastMesseges(
        "Please enter your registered personal email address",
      );
      return;
    }

    try {
      isResetLoading.value = true;

      // Native Firebase verification deployment
      await _authService.sendPasswordReset(email);

      Get.back(); // Automatically close the reset screen viewport layout
      Utils.toastMessegessuccess(
        "Password reset link sent! Check your personal email inbox.",
      );
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? "Failed to send reset link";
      if (e.code == 'user-not-found') {
        msg = "No account found with this email address.";
      } else if (e.code == 'invalid-email') {
        msg = "Please enter a valid email address.";
      }
      Utils.toastMesseges(msg);
    } catch (e) {
      Utils.toastMesseges("Error: $e");
    } finally {
      isResetLoading.value = false;
    }
  }

  void navigateOnRole(String role) {
    final String lowerCaseRole = role.toLowerCase();
    if (lowerCaseRole.contains("admin")) {
      Get.offAllNamed(RoutesNames.adminDashboard);
    } else if (lowerCaseRole.contains("lab")) {
      Get.offAllNamed(RoutesNames.labEngineerDashboard);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
