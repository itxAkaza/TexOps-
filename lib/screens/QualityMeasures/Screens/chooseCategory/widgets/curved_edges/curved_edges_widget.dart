import 'package:flutter/material.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/curved_edges/curved_edges.dart';

class ECurvedEdgesWidget extends StatelessWidget {
  const ECurvedEdgesWidget({super.key, this.child});

  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: ECustomCurvedEdges(), child: child);
  }
}
