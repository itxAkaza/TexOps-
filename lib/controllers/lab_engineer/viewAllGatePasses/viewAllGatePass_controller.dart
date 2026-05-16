
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllBalesController extends GetxController
{

  final RxList<Map<String, dynamic>> allBales = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredBales = <Map<String, dynamic>>[].obs;


  final searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxString selectedQuickFilter = 'All Bales'.obs;
  final List<String> quickFilters = ['All Bales', 'Pending Lab Test', 'Ready for Yarn'];


  final RxString selectedVendor = 'All Vendors'.obs;
  final RxList<String> availableVendors = <String>['All Vendors'].obs;

  final RxDouble maxPriceRange = 200000.0.obs;
  final RxDouble currentPriceLimit = 200000.0.obs;

  final RxString selectedMaterial = 'All'.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      List<Map<String, dynamic>> passedData = List<Map<String, dynamic>>.from(Get.arguments);
      allBales.assignAll(passedData);
      filteredBales.assignAll(passedData);

      // 2. Extract unique vendors for the filter dropdown
      Set<String> vendors = {'All Vendors'};
      for (var bale in passedData) {
        if (bale['supplier'] != null) vendors.add(bale['supplier']);
      }
      availableVendors.assignAll(vendors.toList());
    }

    // Listen to search text changes
    searchController.addListener(() {
      searchText.value = searchController.text;
      applyFilters();
    });
  }

  // Set quick filter chip
  void setQuickFilter(String filter) {
    selectedQuickFilter.value = filter;
    applyFilters();
  }

  // Set bottom sheet material category
  void setMaterialFilter(String material) {
    selectedMaterial.value = material;
    applyFilters();
  }

  // The master filter function
  void applyFilters() {
    var result = allBales.where((bale) {

      // 1. Text Search (Bale ID or GatePass)
      bool matchesSearch = true;
      if (searchText.value.isNotEmpty) {
        String query = searchText.value.toLowerCase();
        String baleId = (bale['baleId'] ?? '').toString().toLowerCase();
        String gatePass = (bale['gatePassRef'] ?? '').toString().toLowerCase();
        String supplier = (bale['supplier'] ?? '').toString().toLowerCase();

        matchesSearch = baleId.contains(query) || gatePass.contains(query) || supplier.contains(query);
      }

      // 2. Quick Filters
      bool matchesQuickFilter = true;
      if (selectedQuickFilter.value == 'Pending Lab Test') {
        matchesQuickFilter = (bale['qualityStatus'] == false || bale['qualityStatus'] == null);
      } else if (selectedQuickFilter.value == 'Ready for Yarn') {
        matchesQuickFilter = (bale['readyForYarn'] == true);
      }

      // 3. Bottom Sheet: Vendor
      bool matchesVendor = true;
      if (selectedVendor.value != 'All Vendors') {
        matchesVendor = bale['supplier'] == selectedVendor.value;
      }

      // 4. Bottom Sheet: Price
      bool matchesPrice = true;
      double price = double.tryParse(bale['price']?.toString() ?? '0') ?? 0.0;
      matchesPrice = price <= currentPriceLimit.value;

      // 5. Bottom Sheet: Material
      bool matchesMaterial = true;
      if (selectedMaterial.value != 'All') {
        String type = (bale['baleType'] ?? '').toString().toLowerCase();
        matchesMaterial = type.contains(selectedMaterial.value.toLowerCase());
      }

      return matchesSearch && matchesQuickFilter && matchesVendor && matchesPrice && matchesMaterial;
    }).toList();

    filteredBales.assignAll(result);
  }

  void resetBottomSheetFilters() {
    selectedVendor.value = 'All Vendors';
    currentPriceLimit.value = maxPriceRange.value;
    selectedMaterial.value = 'All';
    applyFilters();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}