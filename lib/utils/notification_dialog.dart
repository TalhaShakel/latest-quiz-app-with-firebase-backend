import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:quiz_app/models/notification_model.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import '../pages/custom_notification_details.dart';
import 'next_screen.dart';

Future<void> openNotificationDialog(context, NotificationModel notificationModel) {
  return Dialogs.materialDialog(
      context: context,
      title: "New Notification Alert!",
      titleAlign: TextAlign.start,
      msg: notificationModel.title,
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      msgAlign: TextAlign.start,
      msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      barrierDismissible: true,
      actions: <Widget>[
        IconsOutlineButton(
          onPressed: ()=> Navigator.pop(context),
          text: 'Close',
          iconData: Icons.close,
        ),
        IconsOutlineButton(
          onPressed: (){
            Navigator.pop(context);
            NextScreen.nextScreenNormal(context, CustomNotificationDeatils(notificationModel: notificationModel));
          },
          text: 'Open Details',
          iconData: IconUtils.bell1,
          color: Theme.of(context).primaryColor,
          iconColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white),
        ),
      ],
    );
}