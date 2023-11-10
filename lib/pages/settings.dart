import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/audio_controller.dart';
import 'package:quiz_app/blocs/notification_bloc.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/pages/security.dart';
import 'package:quiz_app/services/app_service.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/widgets/avatar_circle.dart';
import 'package:quiz_app/widgets/language.dart';
import '../services/auth_service.dart';
import '../utils/next_screen.dart';
import '../widgets/version_info.dart';
import 'intro.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<UserBloc>().userData;

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _openLogoutDialog() {
      return Dialogs.materialDialog(
          color: Colors.white,
          context: context,
          title: 'logout-title'.tr(),
          msg: 'logout-subtitle'.tr(),
          titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),
        msgAlign: TextAlign.center,
        msgStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
          actions: [
            IconsOutlineButton(
              text: 'cancel'.tr(),
              iconData: Icons.close,
              onPressed: () => Navigator.pop(context),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            IconsOutlineButton(
              text: 'logout'.tr(),
              color: Colors.red,
              iconData: IconUtils.logout,
              iconColor: Colors.white,
              textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              onPressed: () async {
                await AuthService().userLogOut();
                // ignore: use_build_context_synchronously
                await context.read<UserBloc>().clearUserData();
                await NotificationService().deleteAllNotificationData();
                // ignore: use_build_context_synchronously
                NextScreen().nextScreenCloseOthers(context, const IntroPage());
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
              'settings',
              style: TextStyle(color: Colors.white),
            ).tr(),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Column(
                          children: [
                            ListTile(
                              leading: AvatarCircle(
                                  assetString: user!.avatarString,
                                  imageUrl: user.imageUrl,
                                  size: 35,
                                  bgColor: Colors.blue),
                              title: Text(user.name!, style: titleTextStyle),
                              subtitle: Text(user.email!),
                              trailing: IconButton(
                                icon: Icon(IconUtils.logout, color: Colors.grey.shade900,),
                                onPressed: ()=> _openLogoutDialog(),
                              ),
                            ),
                            const Divider(thickness: 0.7,),
                            ListTile(
                              leading: const Icon(IconUtils.security),
                              title: Text('security', style: titleTextStyle,).tr(),
                              subtitle: const Text('security-subtitle').tr(),
                              trailing: const Icon(Icons.arrow_right),
                              onTap: () => NextScreen.nextScreenNormal(
                                  context, const SecurityPage()),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Column(
                          children: [
                            ListTile(
                                leading: const Icon(IconUtils.bell1),
                                title: Text('notifications', style: titleTextStyle).tr(),
                                subtitle: Text(
                                    context.watch<NotificationBloc>().subscribed
                                        ? 'enabled'
                                        : 'disabled',).tr(),
                                trailing: Switch.adaptive(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: context
                                      .watch<NotificationBloc>()
                                      .subscribed,
                                  onChanged: (value) => context
                                      .read<NotificationBloc>()
                                      .handleSubscription(context, value),
                                )),
                            const Divider(thickness: 0.7,),
                            ListTile(
                                leading: const Icon(IconUtils.sound),
                                title: Text('sound', style: titleTextStyle).tr(),
                                subtitle: Text(
                                    context.watch<SoundControllerBloc>().audioEnabled
                                        ? 'enabled'
                                        : 'disabled').tr(),
                                trailing: Switch.adaptive(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: context
                                      .watch<SoundControllerBloc>()
                                      .audioEnabled,
                                  onChanged: (value) => context
                                      .read<SoundControllerBloc>()
                                      .controlSoundSettings(value),
                                )),
                            const Divider(thickness: 0.7,),
                            ListTile(
                                leading: const Icon(IconUtils.vibration),
                                title: Text('vibration', style: titleTextStyle,).tr(),
                                subtitle: Text(
                                    context.watch<SoundControllerBloc>().vibrationEnabled
                                        ? 'enabled'
                                        : 'disabled').tr(),
                                trailing: Switch.adaptive(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: context
                                      .watch<SoundControllerBloc>()
                                      .vibrationEnabled,
                                  onChanged: (value) => context
                                      .read<SoundControllerBloc>()
                                      .controlVibrationSettings(value),
                                )),
                            Visibility(
                              visible: FeatureConfig.multiLanguageEnabled,
                              child: Column(
                                children: [
                                  const Divider(thickness: 0.7,),
                                  ListTile(
                                    leading: const Icon(IconUtils.language),
                                    title: Text('language', style: titleTextStyle,).tr(),
                                    subtitle: const Text('select-language').tr(),
                                    trailing: const Icon(Icons.arrow_right),
                                    onTap: ()=> NextScreen().nextScreenPopup(context, const LanguagePopup()),
                                  ),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(IconUtils.fb),
                              title: Text('facebook', style: titleTextStyle,).tr(),
                              subtitle: const Text('facebook-subtitle').tr(),
                              trailing: const Icon(Icons.arrow_right),
                              onTap: () => AppService()
                                  .openLink(context, Config.fbPageUrl),
                            ),
                            const Divider(thickness: 0.7,),
                            ListTile(
                              leading: const Icon(IconUtils.youtube),
                              title: Text('youtube', style: titleTextStyle,).tr(),
                              subtitle: const Text('youtube-subtitle').tr(),
                              trailing: const Icon(Icons.arrow_right),
                              onTap: () => AppService().openLink(context, Config.youtubeChannelUrl),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Column(
                          children: [
                            ListTile(
                                leading: const Icon(IconUtils.info),
                                title: Text('about-us', style: titleTextStyle,).tr(),
                                subtitle: const Text(Config.yourWebsiteUrl),
                                trailing: const Icon(Icons.arrow_right),
                                onTap: () => AppService().openLinkWithCustomTab(
                                    context, Config.yourWebsiteUrl)),
                            const Divider(thickness: 0.7,),
                            ListTile(
                              leading: const Icon(IconUtils.email, size: 22,),
                              title: Text('contact-us', style: titleTextStyle,).tr(),
                              subtitle: const Text(Config.supportEmail),
                              trailing: const Icon(Icons.arrow_right),
                              onTap: () => AppService().openEmailSupport(context),
                            ),
                            const Divider(thickness: 0.7,),
                            ListTile(
                              leading: const Icon(IconUtils.lock),
                              title: Text('privacy-policy', style: titleTextStyle).tr(),
                              subtitle: const Text('terms').tr(),
                              trailing: const Icon(Icons.arrow_right),
                              onTap: () => AppService().openLinkWithCustomTab(
                                  context, Config.privacyPolicyUrl),
                            ),
                            const Divider(thickness: 0.7,),
                            ListTile(
                              leading: const Icon(IconUtils.star),
                              title: Text('rate-app', style: titleTextStyle).tr(),
                              subtitle: const Text('rate-app-subtitle').tr(),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_right),
                                onPressed: () => AppService().launchAppReview(context),
                              ),
                              onTap: () => AppService().launchAppReview(context),
                            ),
                          ],
                        ),
                      )),
                  
                  const VersionInfo(),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

TextStyle get titleTextStyle => TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w600,
  color: Colors.grey.shade800
);
