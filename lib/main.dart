import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/route/routes.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //main
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const _QualityTestEntryScreen(),
      getPages: AppRoutes.appRoutes(),
    );
  }
}

class _QualityTestEntryScreen extends StatelessWidget {
  const _QualityTestEntryScreen();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offNamed(
        RoutesNames.qualityChooseCategory,
        arguments: {
          'baleRecordId': '4U8fQ5BdPYhCorczhBwNWArzPHh1',
          'baleId': 'fjk7_260516-1200',
        },
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
