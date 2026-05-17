import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/data/models/gate_pass_model.dart';

/// Firestore service for the Quality module.
/// Streams all bail data so QualityController can compute vendor summaries.
class QualityFirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns a real-time stream of all bail records across all vendors.
  Stream<List<GatePassModel>> getAllBails() {
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
