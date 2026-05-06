


import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/Authentication/login_screen.dart';

import '../../screens/onBoarding/intro_screen.dart';

class AppRoutes {

  static appRoutes()=>[
    GetPage(
        name: RoutesNames.introScreen,
        page: ()=>IntroScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 250)

    ),

    GetPage(
        name: RoutesNames.loginScreen,
        page: ()=>LoginScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 250)

    ),











  ];


}