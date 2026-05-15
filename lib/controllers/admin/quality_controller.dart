import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/data/models/gate_pass_model.dart';
import 'package:texops/data/models/vendor_Quality_model.dart';
import 'package:texops/data/models/vendor_quality_summary_model.dart';

class QualityController extends GetxController {
  final _db = FirebaseFirestore.instance;
  RxList<GatePassModel> allData = <GatePassModel>[].obs;

  RxString searchQuery = "".obs;
  RxString selectedMaterial = "All".obs;
  RxString selectedRating = "All".obs;

  @override
  void onInit() {
    super.onInit();
    allData.bindStream(
      _db
          .collectionGroup('bail_data')
          .snapshots()
          .map(
            (s) => s.docs
                .map((d) => GatePassModel.fromMap(d.data(), d.id))
                .toList(),
          ),
    );
  }

  List<VendorQualityModel> get vendorSummaries {
    Map<String, List<GatePassModel>> grouped = {};
    for (var p in allData) {
      grouped.putIfAbsent(p.supplier, () => []).add(p);
    }

    return grouped.entries
        .map(
          (e) => VendorQualityModel(
            vendorName: e.key,
            materialType: e.value.first.baleType,
            bails: e.value,
          ),
        )
        .where((v) {
          bool matchesSearch = v.vendorName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
          bool matchesMat =
              selectedMaterial.value == "All" ||
              v.materialType.toLowerCase() ==
                  selectedMaterial.value.toLowerCase();
          bool matchesRate =
              selectedRating.value == "All" ||
              getRatingTag(v.averageScore) == selectedRating.value;
          return matchesSearch && matchesMat && matchesRate;
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
