import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/data/models/dashboard_model.dart';
import 'package:texops/data/models/gate_pass_model.dart';

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Must return Stream<DashboardStatsModel>
  Stream<DashboardStatsModel> getDashboardStats() {
    return _db.collection('records').doc('dashboard_stats').snapshots().map((
      doc,
    ) {
      return DashboardStatsModel.fromSnapshot(doc);
    });
  }

  // Must return Stream<List<GatePassModel>>
  Stream<List<GatePassModel>> getAllBailData() {
    return _db.collectionGroup('bail_data').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GatePassModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}
