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
  // ─── Employee fields ───────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final RxString role = ''.obs;

  // ─── Vendor fields ─────────────────────────────────────────────
  final vendorFormKey = GlobalKey<FormState>();
  final TextEditingController vendorName = TextEditingController();
  final TextEditingController vendorEmail = TextEditingController();

  final RxString vendorSupplyType = ''.obs;

  // ─── Shared State ─────────────────────────────────────────────
  final RxInt selectedTab = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<VendorModel> allVendors = <VendorModel>[].obs;

  final RxString selectedImagePath = ''.obs;

  final PageController pageController = PageController();

  final List<String> categories = ["Lab", "Quality", "Vendors"];

  final List<String> supplyTypes = ["Cotton", "Polyester"];

  final UserFirebaseService _service = UserFirebaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  // ─── INIT ─────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    allUsers.bindStream(_service.getUsers());
    allVendors.bindStream(_service.getVendors());
  }

  // ─── IMAGE PICK ───────────────────────────────────────────────
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

  // ─── FILTER DATA ──────────────────────────────────────────────
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

  // ─── TAB CHANGE ───────────────────────────────────────────────
  void changeTab(int index) {
    selectedTab.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    selectedTab.value = index;
  }

  // ─── ID GENERATION ────────────────────────────────────────────
  Future<String> generateNextID(String role) async {
    final String prefix = role.toLowerCase().contains('lab') ? 'Lab' : 'Qual';

    final counterRef = FirebaseFirestore.instance
        .collection('counters')
        .doc(prefix.toLowerCase());

    int nextNumber = 1000;

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snapshot = await tx.get(counterRef);

      nextNumber = snapshot.exists
          ? (snapshot.data()?['last'] ?? 999) + 1
          : 1000;

      tx.set(counterRef, {'last': nextNumber});
    });

    return "$prefix-$nextNumber";
  }

  // ─── REGISTER USER ────────────────────────────────────────────
  Future<void> registerUser({
    required String name,
    required String personalEmail,
    required String role,
  }) async {
    isLoading.value = true;

    try {
      final employeeID = await generateNextID(role);
      final generatedEmail = '$employeeID@texops.com';
      final password = "Tex@${employeeID.split('-')[1]}";

      final imageUrl = await uploadProfileImage();

      final user = await _authService.registerUserWithEmailAndPass(
        email: generatedEmail,
        password: password,
      );

      if (user == null) return;

      final newUser = UserModel(
        uid: user.user!.uid,
        personalEmail: personalEmail,
        generatedEmail: generatedEmail,
        profilePic: imageUrl,
        name: name,
        role: role,
        employeeId: employeeID,
        dateJoined: DateTime.now(),
      );

      await _service.saveUser(newUser);

      await EmailService.sendCredentials(
        toEmail: personalEmail,
        name: name,
        employeeId: employeeID,
        generatedEmail: generatedEmail,
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

  // ─── REGISTER VENDOR (FIXED) ───────────────────────────────────
  Future<void> registerVendor({
    required String name,
    required String email,
    required String supplyType,
  }) async {
    isLoading.value = true;

    try {
      final exists = await _service.isVendorNameExists(name);

      if (exists) {
        Utils.toastMesseges("Vendor already exists with this name");
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

  // ─── CLEAR ─────────────────────────────────────────────────────
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

  // ─── DISPOSE ──────────────────────────────────────────────────
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
