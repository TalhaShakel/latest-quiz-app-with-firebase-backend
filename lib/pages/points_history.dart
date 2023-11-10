import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/utils/empty_animation.dart';

class PointsHistory extends StatelessWidget {
  const PointsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List rawList = context.read<UserBloc>().userData!.pointsHistory ?? [];
    final List pointsHistory = List.from(rawList.reversed);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: const Text(
          'points-history',
          style: TextStyle(color: Colors.white),
        ).tr(),
      ),
      body: pointsHistory.isEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyAnimation(animationString: Config.emptyAnimation, title: 'no-content'.tr())
        ],
      )
      
      : ListView.builder(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
        itemCount: pointsHistory.length,
        itemBuilder: (BuildContext context, int index) {
          final String rawtitle = pointsHistory[index].substring(0, pointsHistory[index].indexOf(' at '));
          final String title = rawtitle.replaceAll(RegExp(r'[^\w\s]+|\d+'), '');
          String reward = rawtitle.replaceAll(RegExp(r'[^0-9\-+]'),'');
          final String subtitle = pointsHistory[index].toString().substring(pointsHistory[index].toString().indexOf('at ')).replaceAll('at ', '').trim();
          final String date = DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.parse(subtitle));
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: Colors.grey.shade800,
                fontSize: 17
              ),),
              subtitle: Text(date),
              trailing: CircleAvatar(
                radius: 25,
                child: Text(reward, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600
                ),),
              ),
            ),
          );
        },
      ),
    );
  }
}