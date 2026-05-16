import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:texops/Utiles/utiles.dart';
import 'package:texops/data/fireBaseAuthService/fireBase_Auth_Serivce.dart';
import 'package:texops/data/fireStoreDB/admin/user_firebase_service.dart';
import 'package:texops/data/models/user_model.dart';
import 'package:texops/data/models/vendor_model.dart';
import 'package:texops/services/cloudinary_services.dart';
import 'package:texops/services/email_service.dart';

class UserDirectoryController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final RxString role = ''.obs;

  final vendorFormKey = GlobalKey<FormState>();
  final TextEditingController vendorName = TextEditingController();
  final TextEditingController vendorEmail = TextEditingController();
  final RxString vendorSupplyType = ''.obs;

  final RxInt selectedTab = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedImagePath = ''.obs;

  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<VendorModel> allVendors = <VendorModel>[].obs;

  final PageController pageController = PageController();
  final List<String> categories = ["Lab", "Quality", "Vendors"];
  final List<String> supplyTypes = ["Cotton", "Polyester"];

  final UserFirebaseService _service = UserFirebaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    allUsers.bindStream(_service.getUsers());
    allVendors.bindStream(_service.getVendors());
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<String?> uploadProfileImage() async {
    if (selectedImagePath.value.isEmpty) return null;
    return await _cloudinaryService.uploadImage(File(selectedImagePath.value));
  }

  List filteredDataByTab(int tab) {
    final q = searchQuery.value.toLowerCase();
    if (tab == 0) {
      return allUsers
          .where(
            (u) =>
                u.role.toLowerCase().contains('lab') &&
                u.name.toLowerCase().contains(q),
          )
          .toList();
    }
    if (tab == 1) {
      return allUsers
          .where(
            (u) =>
                u.role.toLowerCase().contains('quality') &&
                u.name.toLowerCase().contains(q),
          )
          .toList();
    }
    return allVendors
        .where(
          (v) =>
              v.name.toLowerCase().contains(q) ||
              v.email.toLowerCase().contains(q) ||
              v.supplyType.toLowerCase().contains(q),
        )
        .toList();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    selectedImagePath.value = ''; // ← clear image so employee/vendor forms don't share it
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    selectedTab.value = index;
    selectedImagePath.value = ''; // ← clear image on swipe too
  }

  Future<String> generateNextID(String role) async {
    final String? lastID = await _service.getLastEmployeeId(role: role);
    String prefix = role.toLowerCase().contains('lab') ? 'Lab' : 'Qual';
    int nextNumber = 1;

    if (lastID != null && lastID.contains('-')) {
      final parts = lastID.split('-');
      if (parts.length > 1) {
        final parsedNumber = int.tryParse(parts[1]);
        if (parsedNumber != null) {
          nextNumber = parsedNumber + 1;
        }
      }
    }
    return '$prefix-${nextNumber.toString().padLeft(3, '0')}';
  }

  // ─── REGISTER USER (NO PASSWORD FIRESTORE WRITES) ───
  Future<void> registerUser({
    required String name,
    required String generatedEmail, // user-given Gmail — used for auth, stored, and credential delivery
    required String role,
  }) async {
    isLoading.value = true;
    try {
      final emailExists = await _service.isUserEmailExists(generatedEmail);
      if (emailExists) {
        Utils.toastMesseges("This email is already registered as an employee.");
        return;
      }

      final employeeID = await generateNextID(role);
      final password =
          "Tex@${employeeID.split('-')[1]}"; // Initial transient password

      final imageUrl = await uploadProfileImage();

      // Firebase Auth uses the user-given email
      final user = await _authService.registerUserWithEmailAndPass(
        email: generatedEmail.trim().toLowerCase(),
        password: password,
      );
      if (user == null) return;

      // Store user-given email as generatedEmail in Firestore
      final newUser = UserModel(
        uid: user.user!.uid,
        generatedEmail: generatedEmail.trim().toLowerCase(),
        profilePic: imageUrl,
        name: name,
        role: role,
        employeeId: employeeID,
        dateJoined: DateTime.now(),
      );
      await _service.saveUser(newUser);

      // Send credentials to the same email
      await EmailService.sendCredentials(
        toEmail: generatedEmail.trim().toLowerCase(),
        name: name,
        employeeId: employeeID,
        password: password,
      );

      _clearEmployeeFields();
      Get.back();
      Utils.toastMessegessuccess("Created $employeeID");
    } catch (e) {
      Utils.ShowSnackbar("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerVendor({
    required String name,
    required String email,
    required String supplyType,
  }) async {
    isLoading.value = true;
    try {
      if (await _service.isVendorNameExists(name)) {
        Utils.toastMesseges("A vendor with this name already exists.");
        return;
      }
      if (await _service.isVendorEmailExists(email)) {
        Utils.toastMesseges("This email is already registered as a vendor.");
        return;
      }

      final docRef = FirebaseFirestore.instance.collection('vendors').doc();
      final imageUrl = await uploadProfileImage();

      final vendor = VendorModel(
        uid: docRef.id,
        name: name,
        email: email,
        profilePic: imageUrl,
        supplyType: supplyType,
        dateAdded: DateTime.now(),
      );
      await _service.saveVendor(vendor);

      _clearVendorFields();
      Get.back();
      Utils.toastMessegessuccess("Vendor registered");
    } catch (e) {
      Utils.ShowSnackbar("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _clearEmployeeFields() {
    name.clear();
    email.clear();
    role.value = '';
    selectedImagePath.value = '';
    formKey.currentState?.reset();
  }

  void _clearVendorFields() {
    vendorName.clear();
    vendorEmail.clear();
    vendorSupplyType.value = '';
    selectedImagePath.value = '';
    vendorFormKey.currentState?.reset();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    vendorName.dispose();
    vendorEmail.dispose();
    pageController.dispose();
    super.onClose();
  }
}
