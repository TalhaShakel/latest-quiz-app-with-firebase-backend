import 'package:flutter/material.dart';

class LanguageConfig {
  
  //Initial Language
  static const String startLocale = 'en';

  //Language if any error happens
  static const String fallbackLocale = 'en';

  //Language names
  static const List<String> languages = [
    'English',
    'Hindi',
    'Russian',
    'Spanish',
    'Portuguese',
    'French',
    'Arabic',
    'Bengali',
    'Chinese',
    'Indonesian',
  ];

  //Language codes - Must be align with the language names
  static const List<Locale> supportedLocals = [
    Locale('en'),
    Locale('hi'),
    Locale('ru'),
    Locale('es'),
    Locale('pt'),
    Locale('fr'),
    Locale('ar'),
    Locale('bn'),
    Locale('zh'),
    Locale('id'),
  ];
}