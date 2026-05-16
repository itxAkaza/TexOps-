import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/fireStoreDB/labEnginner/bail_data.dart';


class ViewAllBalesController extends GetxController
{

  final RxList<Map<String, dynamic>> allBales = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredBales = <Map<String, dynamic>>[].obs;


  final searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxString selectedQuickFilter = 'All Bales'.obs;
  final List<String> quickFilters = ['All Bales', 'Pending Lab Test', 'Ready for Yarn'];


  final RxString selectedVendor = 'All Vendors'.obs;
  final RxList<String> availableVendors = <String>['All Vendors'].obs; // Defaults with 'All Vendors'

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
    }


    _loadVendors();


    searchController.addListener(() {
      searchText.value = searchController.text;
      applyFilters();
    });

  }

  Future<void> _loadVendors() async {
    List<String> vendors = await BailRecordService.fetchSuppliers();
    availableVendors.assignAll(['All Vendors', ...vendors]);
  }


  void setQuickFilter(String filter) {
    selectedQuickFilter.value = filter;
    applyFilters();
  }


  void setMaterialFilter(String material) {
    selectedMaterial.value = material;
    applyFilters();
  }

  void applyFilters()
  {
    var result = allBales.where((bale) {

      bool matchesSearch = true;
      if (searchText.value.isNotEmpty)
      {
        String query = searchText.value.toLowerCase();
        String baleId = (bale['baleId'] ?? '').toString().toLowerCase();
        String gatePass = (bale['gatePassRef'] ?? '').toString().toLowerCase();
        String supplier = (bale['supplier'] ?? '').toString().toLowerCase();
        matchesSearch = baleId.contains(query) || gatePass.contains(query) || supplier.contains(query);
      }


      bool matchesQuickFilter = true;
      if (selectedQuickFilter.value == 'Pending Lab Test')
      {
        matchesQuickFilter = (bale['qualityStatus'] == false || bale['qualityStatus'] == null);
      } else if (selectedQuickFilter.value == 'Ready for Yarn')
      {
        matchesQuickFilter = (bale['readyForYarn'] == true);
      }


      bool matchesVendor = true;
      if (selectedVendor.value != 'All Vendors')
      {
        matchesVendor = bale['supplier'] == selectedVendor.value;
      }

      bool matchesPrice = true;
      double price = double.tryParse(bale['price']?.toString() ?? '0') ?? 0.0;
      matchesPrice = price <= currentPriceLimit.value;


      bool matchesMaterial = true;
      if (selectedMaterial.value != 'All')
      {
        String type = (bale['baleType'] ?? '').toString().toLowerCase();
        matchesMaterial = type.contains(selectedMaterial.value.toLowerCase());
      }

      return matchesSearch && matchesQuickFilter && matchesVendor && matchesPrice && matchesMaterial;
    }).toList();

    filteredBales.assignAll(result);

  }

  void resetBottomSheetFilters()
  {
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