import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/data/models/gate_pass_model.dart';
import 'package:texops/data/models/vendor_quality_model.dart';

class QualityController extends GetxController {
  final _db = FirebaseFirestore.instance;
  RxList<GatePassModel> allBails = <GatePassModel>[].obs;

  RxString searchQuery = "".obs;
  RxString selectedMaterial = "All".obs;
  RxString selectedRating = "All".obs;

  @override
  void onInit() {
    super.onInit();
    // CollectionGroup fetches ALL bail_data documents across all engineer IDs
    _db.collectionGroup('bail_data').snapshots().listen((snapshot) {
      allBails.value = snapshot.docs.map((doc) {
        return GatePassModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  List<VendorQualityModel> get vendorSummaries {
    Map<String, List<GatePassModel>> grouped = {};

    // Group all bails by their supplier name
    for (var bail in allBails) {
      grouped.putIfAbsent(bail.supplier, () => []).add(bail);
    }

    return grouped.entries
        .map(
          (e) => VendorQualityModel(
            vendorName: e.key,
            materialType: e.value.first.baleType,
            bails: e.value,
          ),
        )
        .where((VendorQualityModel v) {
          bool mSearch = v.vendorName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
          bool mMat =
              selectedMaterial.value == "All" ||
              v.materialType.toLowerCase() ==
                  selectedMaterial.value.toLowerCase();
          bool mRate =
              selectedRating.value == "All" ||
              (v.hasData && getRatingTag(v.totalScore) == selectedRating.value);

          return mSearch && mMat && mRate;
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
