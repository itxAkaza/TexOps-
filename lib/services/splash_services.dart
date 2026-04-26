//
//
//
//
// import 'package:get/get_core/src/get_main.dart';
//
// class SplashServices {
//   final userPref = UserPreference();
//
//   void isLogin() async {
//     final isFirst = await userPref.isFirstLogin();
//
//     if (isFirst==true)
//     {
//       await userPref.setFirstLoginDone();
//
//       Timer(const Duration(seconds: 3),
//               ()=>Get.offAll(()=>IntroScreen())
//       );
//
//
//     } else
//     {
//       Timer(const Duration(seconds: 3),
//               ()=>Get.offAll(()=>MainHomeScreen())
//       );
//
//     }
//   }
// }
