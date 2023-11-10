import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/color_config.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/pages/public_profile.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/avatar_circle.dart';
import 'package:quiz_app/widgets/custom_chip.dart';
import 'package:quiz_app/widgets/loading_widget.dart';

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({Key? key}) : super(key: key);

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  late Future _userData;
  final double _topHeaderHeight = 310;
  final int _totalUserforLeaderboard = 30;

  @override
  void initState() {
    _userData = _getData();
    super.initState();
  }

  _onRefresh() async {
    setState(() {});
    _userData = _getData();
  }

  Future<List<UserModel>> _getData() async {
    List<UserModel> data = [];
    await FirebaseService().getTopUsersData(_totalUserforLeaderboard).then((List<UserModel> userList) {
      int index = userList.indexWhere((element) => element.uid == context.read<UserBloc>().userData!.uid);
      int rank = index + 1;
      context.read<UserBloc>().setUserRank(rank);
      debugPrint('rank: $rank');
      data = userList;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'leaderboard',
          style: TextStyle(color: Colors.white),
        ).tr(),
        automaticallyImplyLeading: true,
        centerTitle: false,
        titleSpacing: 0,
        actions: [IconButton(onPressed: () async => await _onRefresh(), icon: const Icon(Icons.refresh_rounded))],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: _userData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      height: _topHeaderHeight,
                      color: Theme.of(context).primaryColor,
                      child: const LoadingIndicatorWidget(color: Colors.white),
                    ),
                  ],
                );
              }
              if (snapshot.hasData && snapshot.data.length != 0) {
                List<UserModel> userList = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_topList(context, userList), _bottomList(userList)],
                );
              }

              return Column(
                children: [
                  Container(
                    height: _topHeaderHeight,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Center(child: Text('No Users Found', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white))),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  DelayedDisplay _bottomList(List<UserModel> userList) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 200),
      child: Container(
        color: ColorConfig.bgColor,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userList.length,
          separatorBuilder: ((context, index) {
            if (index <= 2) return Container();
            return const SizedBox(
              height: 15,
            );
          }),
          itemBuilder: (BuildContext context, int index) {
            if (index <= 2) return Container();
            return InkWell(
              onTap: () => NextScreen.openBottomSheet(context, PublicProfile(user: userList[index], rank: index + 1)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    isThreeLine: false,
                    title: Text(
                      userList[index].name!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700, fontSize: 18),
                    ),
                    trailing: Wrap(
                      children: [
                        const Icon(
                          IconUtils.starFill,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          userList[index].points.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                    subtitle: Visibility(
                      visible: FeatureConfig.userStrengthEnabled,
                      child: const Text('strength-count').tr(args: [userList[index].strength!.toStringAsFixed(2)]),
                    ),
                    leading: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey.shade400),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.blueGrey),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        AvatarCircle(
                            assetString: userList[index].avatarString, imageUrl: userList[index].imageUrl, size: 50, bgColor: ColorConfig.avatarBg3)
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  Container _topList(BuildContext context, List<UserModel> userList) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: _topHeaderHeight,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //2nd
          Flexible(
            flex: 2,
            child: userList.length < 2
                ? Container()
                : DelayedDisplay(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'second',
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                        ).tr(),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () => NextScreen.openBottomSheet(context, PublicProfile(user: userList[1], rank: 2)),
                          child: AvatarCircle(
                              assetString: userList[1].avatarString, imageUrl: userList[1].imageUrl, size: 90, bgColor: ColorConfig.avatarBg2),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          userList[1].name ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomChip1(label: userList[1].points.toString(), icon: IconUtils.starFill, bgColor: ColorConfig.chip3)
                      ],
                    ),
                  ),
          ),

          //1st
          Flexible(
            flex: 3,
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Platform.isAndroid
                  ? _animatedText()
                  : const Text('first', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),).tr(),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () => NextScreen.openBottomSheet(context, PublicProfile(user: userList[0], rank: 1)),
                    child: AvatarCircle(
                        assetString: userList[0].avatarString, imageUrl: userList[0].imageUrl, size: 140, bgColor: ColorConfig.avatarBg2),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userList[0].name!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomChip1(label: userList[0].points.toString(), icon: IconUtils.starFill, bgColor: ColorConfig.chip3)
                ],
              ),
            ),
          ),

          //3rd
          Flexible(
            flex: 2,
            child: userList.length < 3
                ? Container()
                : DelayedDisplay(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'third',
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                        ).tr(),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () => NextScreen.openBottomSheet(context, PublicProfile(user: userList[2], rank: 3)),
                          child: AvatarCircle(
                              assetString: userList[2].avatarString, imageUrl: userList[2].imageUrl, size: 90, bgColor: ColorConfig.avatarBg2),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          userList[2].name!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomChip1(label: userList[2].points.toString(), icon: IconUtils.starFill, bgColor: ColorConfig.chip3)
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  AnimatedTextKit _animatedText() {
    return AnimatedTextKit(
      isRepeatingAnimation: true,
      repeatForever: true,
      animatedTexts: [
        ColorizeAnimatedText('first'.tr(),
            textStyle: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
            speed: const Duration(milliseconds: 800),
            colors: [
              Colors.white,
              Colors.green,
              Colors.yellow,
              Colors.pink,
            ]),
      ],
    );
  }
}
