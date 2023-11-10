import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/pages/home.dart';
import 'package:quiz_app/pages/intro.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:simple_animations/simple_animations.dart';

import '../blocs/ads_bloc.dart';
import '../blocs/settings_bloc.dart';
import '../blocs/user_bloc.dart';
import '../configs/color_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  _getRequiredData() async {
    await AuthService().checkUserState().then((bool isSignedIn) async {
      if (isSignedIn) {
        await context.read<UserBloc>().getUserData().then((value) async =>
        await context.read<SettingsBloc>().getSettingsData()
        .then((value) async => await context.read<AdsBloc>().checkAds()).then((value) async{
          await context.read<SettingsBloc>().getSpecialCategories();
          debugPrint('Data getting done');
          await Future.delayed(const Duration(seconds: 1)).then((_)=> NextScreen().nextScreenReplaceAnimation(context, const HomePage()));
        }));
      } else {
        await Future.delayed(const Duration(seconds: 2))
        .then((_)=> NextScreen().nextScreenReplaceAnimation(context, const IntroPage()));
        
      }
    });
  }
  



  @override
  void initState() {
    super.initState();
    _getRequiredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConfig.secondaryBgColor,
        body: MirrorAnimationBuilder<double>(
          curve: Curves.easeInOut,
          tween: Tween(begin: 100.0, end: 180),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, _) {
            return Center(
                child: Image.asset(
              Config.splashIcon,
              height: value,
              width: value,
            ));
          },
        ));
  }
}
