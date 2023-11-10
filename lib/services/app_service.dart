import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/settings_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/app_config.dart';
import '../constants/constant.dart';
import '../utils/toast.dart';

class AppService {
  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      internet = false;
    }
    return internet;
  }

  Future openLink(context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      openToast(context, "Can't launch the url");
    }
  }

  Future openEmailSupport(context) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: 'subject=About ${Config.appName}&body=', //add subject and body here
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openToast1(context, "Can't open the email app");
    }
  }

  Future openLinkWithCustomTab(BuildContext context, String url) async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: url,
        customTabsOptions: const CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.system,
          //addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: const SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
    } catch (e) {
      openToast1(context, 'Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future launchAppReview(context) async {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    await LaunchReview.launch(
        androidAppId: sb.packageName, iOSAppId: Config.iOSAppId, writeReview: false);
    if (Platform.isIOS) {
      if (Config.iOSAppId == '000000') {
        openToast1(context, 'The iOS version is not available on the AppStore yet');
      }
    }
  }

  static getNormalText(String text) {
    return HtmlUnescape().convert(parse(text).documentElement!.text);
  }

  static String getQuestionOrder(String? questionOrderString) {
    if (questionOrderString == null || questionOrderString == Constants.questionOrders[1]) {
      return 'ascending';
    } else if (questionOrderString == Constants.questionOrders[2]) {
      return 'descending';
    } else {
      return 'random';
    }
  }

  static String getVideoType(String videoSource) {
    if (videoSource.contains('youtu')) {
      return 'youtube';
    } else if (videoSource.contains('vimeo')) {
      return 'vimeo';
    } else {
      return 'network';
    }
  }
}
