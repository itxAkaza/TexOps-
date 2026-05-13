import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:texops/resources/route/routes.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/lab_engineer/dashboard/lab_enigneer_dashboard.dart';

import 'firebase_options.dart';

void main() async{
// hi

import 'package:texops/screens/admin/dashboard/admin_dashboard.dart';

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
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )
      ),

      initialRoute: RoutesNames.introScreen,
      getPages: AppRoutes.appRoutes(),

    );
  }
}

















