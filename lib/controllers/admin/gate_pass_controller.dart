import 'package:get/state_manager.dart';
import 'package:texops/data/fireStoreDB/admin/gate_pass_firebase_service.dart';
import 'package:texops/data/models/gate_pass_model.dart';

class GatePassController extends GetxController {
  final GatePassFirebaseService _service = GatePassFirebaseService();

  RxList<GatePassModel> allPasses = <GatePassModel>[].obs;
  RxList<GatePassModel> displayedPasses = <GatePassModel>[].obs;
  RxString searchQuery = ''.obs;
  RxString selectedStatus = 'All'.obs;
  RxString selectedType = 'All'.obs;

  @override
  void onInit() {
    allPasses.bindStream(_service.getGatePass());

    everAll([allPasses, searchQuery, selectedStatus, selectedType], (_) {
      _filterList();
    });
    super.onInit();
  }

  void _filterList() {
    final q = searchQuery.value.toLowerCase();
    final status = selectedStatus.value;
    final type = selectedType.value;

    displayedPasses.value = allPasses.where((record) {
      final searchMatch =
          record.vehicleNumber.toLowerCase().contains(q) ||
          record.supplier.toLowerCase().contains(q);
      final statusMatch =
          status == "All" ||
          (status == "Pending" ? !record.qualityStatus : record.qualityStatus);
      final typeMatch = type == "All" || record.baleType == type;

      return searchMatch && statusMatch && typeMatch;
    }).toList();
  }
}
