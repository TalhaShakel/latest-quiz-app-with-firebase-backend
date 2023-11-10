import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/audio_controller.dart';
import 'package:quiz_app/blocs/notification_bloc.dart';
import 'package:quiz_app/blocs/settings_bloc.dart';
import 'package:quiz_app/blocs/tab_controller.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/ad_config.dart';
import 'package:quiz_app/tabs/categories_tab.dart';
import 'package:quiz_app/tabs/home_tab.dart';
import 'package:quiz_app/tabs/profile_tab.dart';
import 'package:quiz_app/utils/disable_dialog.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../services/notification_service.dart';
import '../tabs/leaderboard_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _initNotifications () async{
    await NotificationService().initFirebasePushNotification(context)
    .then((value)=> context.read<NotificationBloc>().checkPermission());
  }

  void _checkUserAccess ()async{
    final bool isDisabled  = context.read<UserBloc>().userData!.disabled ?? false;
    if(isDisabled){
      await Future.delayed(const Duration(seconds: 3)).then((value) => openDisableUserDialog(context));
    }
  }


  @override
  void initState() {
    super.initState();
    _initNotifications();
    context.read<SettingsBloc>().initPackageInfo();
    AdConfig().initAdmob();
    context.read<SoundControllerBloc>().initSounds();
    _checkUserAccess();
  }

  final Map<int, List> tabs = {
    1: ['home', IconUtils.home],
    2: ['categories', IconUtils.categories],
    3: ['profile', IconUtils.profile],
    4: ['leaderboard', IconUtils.leaderboard]
  };

  _onBackPressed ()async{
    if(context.read<TabControllerBloc>().currentIndex != 0){
      context.read<TabControllerBloc>().controlTab(0);
    }else{
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> _onBackPressed(),
      child: Scaffold(
          bottomNavigationBar: _bottomNavBar(),
          body: PageView(
            allowImplicitScrolling: true,
            controller: context.read<TabControllerBloc>().pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeTab(), 
              CategoriesTab(),
              ProfileTab(),
              LeaderboardTab(), 
            ],
          )),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      color: Colors.white,
      child: SalomonBottomBar(
        curve: Curves.easeIn,
        currentIndex: context.watch<TabControllerBloc>().currentIndex,
        onTap: (int index){
          if(index == 3){
            NextScreen.nextScreenNormal(context, const LeaderboardTab());
          }else{
            context.read<TabControllerBloc>().controlTab(index);
          }

        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(tabs[1]![1]),
            title: Text(tabs[1]![0]).tr(),
            selectedColor: Colors.purple,
          ),

          /// Categories
          SalomonBottomBarItem(
            icon: Icon(tabs[2]![1]),
            title: Text(tabs[2]![0]).tr(),
            selectedColor: Colors.pink,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(tabs[3]![1]),
            title: Text(tabs[3]![0]).tr(),
            selectedColor: Colors.teal,
          ),

          /// Leaderboard
          SalomonBottomBarItem(
            icon: Icon(tabs[4]![1]),
            title: Text(tabs[4]![0]).tr(),
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
