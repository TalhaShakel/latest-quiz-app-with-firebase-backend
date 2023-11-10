import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:quiz_app/cards/custom_notification_card.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/utils/empty_animation.dart';
import '../constants/constant.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationList = Hive.box(Constants.notificationTag);

    // ignore: no_leading_underscores_for_local_identifiers
    void _openClearAllDialog() {
      return Dialogs.bottomMaterialDialog(
          context: context,
          title: 'delete-all-title'.tr(),
          msg: 'delete-all-subtitle'.tr(),
          titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          actions: [
            IconsOutlineButton(
              text: 'cancel'.tr(),
              iconData: Icons.close,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              onPressed: () => Navigator.pop(context),
            ),
            IconsOutlineButton(
              text: 'delete'.tr(),
              color: Colors.red,
              iconData: Icons.delete,
              iconColor: Colors.white,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              onPressed: () async {
                Navigator.pop(context);
                await NotificationService().deleteAllNotificationData();
              },
            ),
          ]);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.medium(
            elevation: 0,
            centerTitle: false,
            titleSpacing: 50,
            title: const Text(
              'notifications',
              style: TextStyle(color: Colors.white),
            ).tr(),
            actions: [
              TextButton(
                onPressed: () => _openClearAllDialog(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                ),
                child: Text(
                  'clear-all',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ).tr(),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: notificationList.listenable(),
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        List items = notificationList.values.toList();
                        items.sort((a, b) => b['date'].compareTo(a['date']));
                        if (items.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                              ),
                              EmptyAnimation(
                                  animationString: Config.notificationAnimation,
                                  title: 'no-content'.tr()),
                            ],
                          );
                        }
                        return _NotificationList(items: items);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        final NotificationModel notificationModel = NotificationModel(
          id: items[index]['id'],
          date: items[index]['date'] ?? '',
          title: items[index]['title'],
          body: items[index]['body'],
        );
        return CustomNotificationCard(notificationModel: notificationModel);
      },
    );
  }
}
