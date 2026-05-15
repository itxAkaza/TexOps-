import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
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
  final RxBool hidePassword = true.obs;

  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  Future<void> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

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
          msg = "Invalid email or password";
          break;

        case 'user-not-found':
          msg = "No account found";
          break;

        case 'wrong-password':
          msg = "Wrong password";
          break;

        case 'invalid-email':
          msg = "Invalid email";
          break;

        case 'user-disabled':
          msg = "User account disabled";
          break;

        case 'too-many-requests':
          msg = "Too many attempts";
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

  void navigateOnRole(String role) {
    final String lowerCaseRole = role.toLowerCase();

    if (lowerCaseRole.contains("admin")) {
      Get.offAllNamed(RoutesNames.adminDashboard);
    }else if(lowerCaseRole.contains("lab")){
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
