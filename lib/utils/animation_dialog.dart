import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

Future<void> openAnimationDialog (context, String animationString, String title, String subtitle){
    return Dialogs.materialDialog(
        context: context,
        title: title,
        msg: subtitle,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),
        msgAlign: TextAlign.center,
        msgStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
        lottieBuilder: LottieBuilder.asset(
          animationString,
          fit: BoxFit.contain,
        ),
        actions: <Widget>[
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 20),
            child: IconsButton(
              onPressed: ()=> Navigator.pop(context),
              text: 'Ok'.tr(),
              iconData: Icons.check,
              color: Theme.of(context).primaryColor,
              textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              iconColor: Colors.white,

            ),
          ),
        ]);
  }