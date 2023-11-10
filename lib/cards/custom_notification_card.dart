import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/pages/custom_notification_details.dart';
import 'package:quiz_app/utils/next_screen.dart';
import '../models/notification_model.dart';
import '../services/app_service.dart';
import '../services/notification_service.dart';

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard({Key? key, required this.notificationModel}) : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 20, 20, 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerticalDivider(thickness: 2.0, color: Colors.blueGrey.shade100),
                    Expanded(
                        child: Text(
                      AppService.getNormalText(notificationModel.title!),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.shade900
                      )
                    )),
                    IconButton(
                        constraints: const BoxConstraints(minHeight: 40),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(left: 8),
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onPressed: () => NotificationService().deleteNotificationData(notificationModel.id))
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.time,
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    _getDate(context, notificationModel),
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NextScreen.nextScreenNormal(context, CustomNotificationDeatils(notificationModel: notificationModel));
        });
  }

  static String _getDate (BuildContext context, NotificationModel notificationModel){
    final String date = DateFormat('MMMM dd, yyyy').format(notificationModel.date!);
    return date;
  }
}