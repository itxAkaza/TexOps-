import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/data/models/gate_pass_model.dart';
import 'package:texops/data/models/vendor_quality_model.dart';

class QualityController extends GetxController {
  final _db = FirebaseFirestore.instance;
  RxList<GatePassModel> allBails = <GatePassModel>[].obs;
  RxList<VendorQualityModel> vendorSummaries = <VendorQualityModel>[].obs;

  RxString searchQuery = "".obs;
  RxString selectedMaterial = "All".obs;
  RxString selectedRating = "All".obs;

  @override
  void onInit() {
    super.onInit();
    ever(allBails, (_) => _updateVendorSummaries());
    ever(searchQuery, (_) => _updateVendorSummaries());
    ever(selectedMaterial, (_) => _updateVendorSummaries());
    ever(selectedRating, (_) => _updateVendorSummaries());

    _db.collectionGroup('bail_data').snapshots().listen((snapshot) {
      allBails.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return GatePassModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  void _updateVendorSummaries() {
    List<GatePassModel> filteredBails = selectedMaterial.value == "All"
        ? allBails
        : allBails
              .where(
                (bail) =>
                    bail.baleType.trim().toLowerCase() ==
                    selectedMaterial.value.toLowerCase(),
              )
              .toList();

    Map<String, List<GatePassModel>> grouped = {};

    for (var bail in filteredBails) {
      final key = bail.supplier.trim().toLowerCase();
      grouped.putIfAbsent(key, () => []).add(bail);
    }

    vendorSummaries.value = grouped.entries
        .map(
          (e) => VendorQualityModel(
            vendorName: e.value.first.supplier,
            materialType: e.value.first.baleType,
            bails: e.value,
          ),
        )
        .where((VendorQualityModel v) {
          bool mSearch = v.vendorName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

          bool mRate =
              selectedRating.value == "All" ||
              (v.hasData && getRatingTag(v.totalScore) == selectedRating.value);

          return mSearch && mRate;
        })
        .toList();
  }

  Color getRatingColor(double s) => s >= 90
      ? const Color(0xFF1B434D)
      : s >= 75
      ? const Color(0xFFFFA726)
      : const Color(0xFFFFCC80);

  String getRatingTag(double s) => s >= 90
      ? "Excellent"
      : s >= 75
      ? "Good"
      : "Fair";
}
