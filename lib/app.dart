import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/audio_controller.dart';
import 'package:quiz_app/pages/splash.dart';
import 'blocs/ads_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/question_bloc.dart';
import 'blocs/settings_bloc.dart';
import 'blocs/tab_controller.dart';
import 'blocs/temp_bloc.dart';
import 'blocs/user_bloc.dart';
import 'configs/color_config.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =  FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<QuestionBloc>(create: (context) => QuestionBloc()),
          ChangeNotifierProvider<UserBloc>(create: (context) => UserBloc()),
          ChangeNotifierProvider<SettingsBloc>(create: (context) => SettingsBloc()),
          ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
          ChangeNotifierProvider<TabControllerBloc>(create: (context) => TabControllerBloc()),
          ChangeNotifierProvider<TempBloc>(create: (context) => TempBloc()),
          ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
          ChangeNotifierProvider<SoundControllerBloc>(create: (context) => SoundControllerBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorObservers: [firebaseObserver],
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorConfig.appThemeColor,
              outline: Colors.grey.shade400,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: ColorConfig.appThemeColor,
            scaffoldBackgroundColor: ColorConfig.bgColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: ColorConfig.appThemeColor,
              actionsIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            textTheme: GoogleFonts.dmSansTextTheme()
          ),
          home: const SplashPage()
        ));
  }
}