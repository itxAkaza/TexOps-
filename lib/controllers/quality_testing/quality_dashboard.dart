import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/services/notifiction_service.dart'; // Adjust path
import '../../data/fireStoreDB/quality/qulity_firestore.dart';

class QualityDashboardController extends GetxController {
  var isLoading = true.obs;

  // User Data
  var userName = 'Loading...'.obs;
  var userRole = 'Quality Engineer'.obs;
  var userProfilePic = ''.obs;
  var userEmail = ''.obs;

  // Lists and Toggles
  var pendingBales = <Map<String, dynamic>>[].obs;
  var completedBales = <Map<String, dynamic>>[].obs;
  var isPendingTab = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    listenToBales();

    // Boot up the notification engine safely!
    NotificationServices ns = NotificationServices();
    ns.initializeAll();
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await QualityFirebaseService.getUserProfile();
      if (userData != null) {
        userName.value = (userData['name'] ?? 'Unknown').toString().trim();
        userRole.value = (userData['role'] ?? 'Quality Engineer').toString().trim();
        userProfilePic.value = userData['profilePic'] ?? '';
        userEmail.value = (userData["generatedEmail"] ?? "").toString().trim();
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  void listenToBales() {
    QualityFirebaseService.getBalesStream().listen((snapshot) {
      List<Map<String, dynamic>> tempPending = [];
      List<Map<String, dynamic>> tempCompleted = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // We attach the exact IDs your friend's repo needs to save the data
        data['baleId'] = doc.id;
        data['baleRecordId'] = '4U8fQ5BdPYhCorczhBwNWArzPHh1';

        if (data['qualityStatus'] == true) {
          tempCompleted.add(data);
        } else {
          tempPending.add(data);
        }
      }

      pendingBales.assignAll(tempPending);
      completedBales.assignAll(tempCompleted);
      isLoading.value = false;
    }, onError: (e) {
      print("Error streaming bales: $e");
    });
  }

  void switchTab(bool showPending) {
    isPendingTab.value = showPending;
  }
}