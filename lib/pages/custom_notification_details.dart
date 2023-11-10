import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quiz_app/widgets/html_body.dart';
import '../models/notification_model.dart';
import '../services/app_service.dart';

class CustomNotificationDeatils extends StatelessWidget {
  const CustomNotificationDeatils({Key? key, required this.notificationModel})
      : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('notification-details', style: TextStyle(color: Colors.white),).tr(),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppService.getNormalText(notificationModel.title!),
              style: const TextStyle(
                  wordSpacing: 1,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    LineIcons.clock,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    _getDate(context, notificationModel),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,),
                  ),
                ],
              ),
            ),
            HtmlBody(description: notificationModel.body ?? ''),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }


  static String _getDate (BuildContext context, NotificationModel notificationModel){
    final String date = DateFormat('MMMM dd, yyyy hh:mm a').format(notificationModel.date!);
    return date;
  }
}