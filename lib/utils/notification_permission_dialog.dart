import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

Future<void> openNotificationPermissionDialog(context) {
  return Dialogs.materialDialog(
      context: context,
      title: 'Allow Notifications from Settings',
      titleAlign: TextAlign.center,
      msg: 'You need to allow notifications from your settings first to enable this',
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      msgAlign: TextAlign.center,
      msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      barrierDismissible: false,
      actions: <Widget>[
        IconsOutlineButton(
          onPressed: ()=> Navigator.pop(context),
          text: 'Close',
          iconColor: Colors.white,
        ),
        IconsOutlineButton(
          onPressed: (){
            Navigator.pop(context);
            AppSettings.openNotificationSettings();
          },
          text: 'Open Settings',
          color: Theme.of(context).primaryColor,
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
          iconColor: Colors.white,
        ),
        
      ],
    );
}
