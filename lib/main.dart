import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_app/configs/language_config.dart';
import 'app.dart';
import 'constants/constant.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(Constants.notificationTag);
  runApp(EasyLocalization(
    supportedLocales: LanguageConfig.supportedLocals,
    path: 'assets/translations',
    fallbackLocale: const Locale(LanguageConfig.fallbackLocale),
    startLocale: const Locale(LanguageConfig.startLocale),
    useOnlyLangCode: true,
    child: const MyApp(),
  ));
}
