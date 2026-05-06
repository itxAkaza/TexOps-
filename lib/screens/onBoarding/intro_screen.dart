import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/controllers/onBoarding/onBoarding_controller.dart';
import 'package:texops/screens/Authentication/login_screen.dart';
import 'package:texops/screens/onBoarding/onBoarding_Screens/onBoarding2.dart';
import 'package:texops/screens/onBoarding/onBoarding_Screens/onBoarding3.dart';
import 'package:texops/screens/onBoarding/widgets/my_button.dart';

import 'onBoarding_Screens/onBoarding1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatelessWidget {
   IntroScreen({super.key});

  final introController=Get.put(onBoradingController());

  @override
  Widget build(BuildContext context) {

    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller:introController.controller ,
            onPageChanged: (value){
              !(value==2)?introController.makeLast(false):introController.makeLast(true) ;

            },

            children: [
              OnBoarding1(),
              OnBoarding2(),
              OnBoarding3(),


            ],

          ),

          Container(
            alignment: Alignment(0,0.08),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SmoothPageIndicator(
              controller: introController.controller,
              count: 3,
              effect: WormEffect(
                  dotColor: Colors.white.withValues(alpha: 0.7),
                  activeDotColor: Colors.white,
                  dotWidth: 12,
                  dotHeight: 12,
                  paintStyle: PaintingStyle.stroke
              ),

            ),
          ),

          Container(
            alignment: Alignment(0,0.8),
            child: Obx((){
              return introController.isLast.value
                  ?

              OnBoardingButton(text: "Get Started", height: height*0.06,width: width*0.8,
                  onTap:
                      (){
                    Get.offAll(()=>LoginScreen());
                    Get.delete<onBoradingController>();

                  }
              ) :

              OnBoardingButton(text: "Next",height: height*0.06,width: width*0.8,
                  onTap:
                      ()=>introController.controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn)
              );

            }),
          )




        ],
      ),
    );
  }
}
