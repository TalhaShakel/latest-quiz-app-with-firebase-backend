import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../configs/color_config.dart';

class SocialLogins extends StatelessWidget {
  const SocialLogins({Key? key, required this.onGooglePressed, required this.onFbPressed, required this.onApplePressed, required this.googleBtnCtlr, required this.fbBtnCtlr, required this.appleBtnCtlr}) : super(key: key);

  final VoidCallback onGooglePressed;
  final VoidCallback onFbPressed;
  final VoidCallback onApplePressed;

  final RoundedLoadingButtonController googleBtnCtlr;
  final RoundedLoadingButtonController fbBtnCtlr;
  final RoundedLoadingButtonController appleBtnCtlr;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5,),
        Text('login-social', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: ColorConfig.bodyTextColor
        ),).tr(),
        const SizedBox(
          height: 20,
        ),
        RoundedLoadingButton(
          animateOnTap: false,
          borderRadius: 5,
          controller: googleBtnCtlr,
          onPressed: onGooglePressed,
          width: MediaQuery.of(context).size.width * 1.0,
          color: Colors.blueAccent,
          elevation: 0,
          child: Wrap(
            children: [
              const Icon(Ionicons.logo_google, color: Colors.white,),
              const SizedBox(
                width: 20,
              ),
              Text(
                'Sign In with Google',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 17
                )
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: FeatureConfig.fbLoginEnabled,
          child: RoundedLoadingButton(
            animateOnTap: false,
            borderRadius: 5,
            controller: fbBtnCtlr,
            onPressed: onFbPressed,
            width: MediaQuery.of(context).size.width * 1.0,
            color: Colors.indigo ,
            elevation: 0,
            child: Wrap(
              children: [
                const Icon(Ionicons.logo_facebook, color: Colors.white,),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Sign In with Facebook',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 17
                  )
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: Platform.isIOS,
          child: RoundedLoadingButton(
            animateOnTap: false,
            borderRadius: 5,
            controller: appleBtnCtlr,
            onPressed: onApplePressed,
            width: MediaQuery.of(context).size.width * 1.0,
            color: Colors.grey[900],
            elevation: 0,
            child: Wrap(
              children: [
                const Icon(Ionicons.logo_apple, color: Colors.white,),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Sign In with Apple',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 17
                  )
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}