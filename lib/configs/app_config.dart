import 'package:flutter/material.dart';

class Config{


  //App Name
  static const String appName = "QuizHour";
  //Support Email
  static const String supportEmail = "YOUR_EMAIL";
  //iOS App Id (Only for iOS)
  static const String iOSAppId = '000000';
  
  
  //Links
  static const String privacyPolicyUrl = "https://www.mrb-lab.com/privacy-policy";
  static const String termsAndServiceUrl = "https://www.mrb-lab.com/privacy-policy/";
  static const String yourWebsiteUrl = "https://mrb-lab.com";
  static const String fbPageUrl = 'https://www.facebook.com/mrblab24';
  static const String youtubeChannelUrl = 'https://www.youtube.com/c/MRBLab';

  

  //App Icons & Logo
  static const String icon = 'assets/images/icon.png';
  static const String logo = 'assets/images/logo.png';
  static const String splashIcon = 'assets/images/splash.png';

  
  //Introduction/On-Borading Screen Assets
  static final Map<int, List> intros = {
    //serical : background color, asset image
    1 : [Colors.orange.shade400, "assets/images/intro_1.svg"],
    2 : [Colors.red.shade300, "assets/images/intro_2.svg"],
    3 : [Colors.pink.shade200, "assets/images/intro_3.svg"],
  };


  //Lottie animation files
  static const String emptyAnimation = 'assets/animations/empty.json';
  static const String notificationAnimation = 'assets/animations/notification.json';
  static const String rewardAnimation = 'assets/animations/reward.json';
  static const String emptyBoxAnimation = 'assets/animations/empty_box.json';
  static const String quitAnimation = 'assets/animations/quit.json';
  static const String hiAnimation = 'assets/animations/hi.json';

  
  //Self chnalange mode thumnail cover image
  static const String selfChallengeCoverImage = 'assets/images/self_ch_cover.jpg';

  //Default user avatar
  static const String defaultAvatarString = 'assets/images/user_avatars/user1.png';

  
  
  //User Avatar List
  static const List<String> userAvatars = [
    'assets/images/user_avatars/user1.png',
    'assets/images/user_avatars/user2.png',
    'assets/images/user_avatars/user3.png',
    'assets/images/user_avatars/user4.png',
    'assets/images/user_avatars/user5.png',
    'assets/images/user_avatars/user6.png',
    'assets/images/user_avatars/user7.png',
    'assets/images/user_avatars/user8.png',
    'assets/images/user_avatars/user9.png',
    'assets/images/user_avatars/user10.png',
    'assets/images/user_avatars/user11.png',
    'assets/images/user_avatars/user12.png',
    'assets/images/user_avatars/user13.png',
    'assets/images/user_avatars/user14.png',
    'assets/images/user_avatars/user15.png',
    'assets/images/user_avatars/user16.png',
    'assets/images/user_avatars/user17.png'
  ];


  //Audio Files
  static const String clickSound = 'assets/sounds/click.mp3';
  static const String optionsSound = 'assets/sounds/options.mp3';
  static const String congratsSound = 'assets/sounds/congrats.mp3';
  

}