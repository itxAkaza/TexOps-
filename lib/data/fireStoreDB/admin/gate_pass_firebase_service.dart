import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/data/models/gate_pass_model.dart';

class GatePassFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<GatePassModel>> getGatePass() {
    return _firestore.collectionGroup('bail_data').snapshots().map((snapshot) {
      print("DEBUG: Received ${snapshot.docs.length} documents from bail_data");

      return snapshot.docs.map((doc) {
        return GatePassModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
