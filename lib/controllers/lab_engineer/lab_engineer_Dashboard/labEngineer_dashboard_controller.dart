import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/fireStoreDB/labEnginner/dashboard_data.dart';


class LabEngineerController extends GetxController {
  var isLoading = true.obs;

  // User Data
  var userName = 'Loading...'.obs;
  var userRole = 'Lab Engineer'.obs;
  var userProfilePic = ''.obs;
  var totalSystemValue = 0.0.obs;

  // Recent Activity Data
  var recentBales = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // 1. Fetch User
      final userData = await LabEngineerFirebaseService.getUserProfile();
      if (userData != null) {
        userName.value = userData['name'] ?? 'Unknown User';
        userRole.value = userData['role'] ?? 'Lab Engineer';
        userProfilePic.value = userData['profilePic'] ?? '';

        // If 'totalBalesAmount' is not found in DB yet, it defaults to 0.0
        totalSystemValue.value = (userData['totalBalesAmount'] ?? 0.0).toDouble();
      }

      // 2. Fetch List
      final bales = await LabEngineerFirebaseService.getRecentBales();
      recentBales.assignAll(bales);

    } catch (e) {
      print("Error fetching dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Dynamic Quarter Logic based on current month
  String getCurrentQuarter() {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    int quarter = ((month - 1) / 3).floor() + 1;
    return "This Quarter (Q$quarter $year)";
  }

  // Calculates the price * count for individual list tiles
  double calculateGatePassTotal(Map<String, dynamic> bale) {
    double price = double.tryParse(bale['price']?.toString() ?? '0') ?? 0.0;
    int count = int.tryParse(bale['baleCount']?.toString() ?? '0') ?? 0;
    return price * count;
  }
}