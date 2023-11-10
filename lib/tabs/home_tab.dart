import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/ads_bloc.dart';
import 'package:quiz_app/blocs/settings_bloc.dart';
import 'package:quiz_app/blocs/tab_controller.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/configs/color_config.dart';
import 'package:quiz_app/pages/notifications.dart';
import 'package:quiz_app/pages/self_challenge.dart';
import 'package:quiz_app/pages/settings.dart';
import 'package:quiz_app/tabs/leaderboard_tab.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/avatar_circle.dart';
import 'package:quiz_app/widgets/custom_chip.dart';
import 'package:quiz_app/widgets/rewarded_ad_container.dart';
// import '../IAP/iap_config.dart';
// import '../IAP/iap_page.dart';
import '../widgets/home_categories.dart';
import '../widgets/featured.dart';
import '../widgets/sp_category1.dart';
import '../widgets/sp_category2.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopBar(),
            Column(
              children: [
                const FeaturedCategories(),
                const HomeCategories(),
                Visibility(
                    visible: context.watch<SettingsBloc>().specialCategory.enabled!,
                    child: SpecialCategory1(
                      catID: context.read<SettingsBloc>().specialCategory.id1!,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                    visible: context.watch<SettingsBloc>().specialCategory.enabled!,
                    child: SpecialCategory2(
                      catID: context.read<SettingsBloc>().specialCategory.id2!,
                    )),
                Visibility(
                  visible: context.read<SettingsBloc>().selfChallengeModeEnabled,
                  child: const _SelfChallengeContainer(),
                ),
                Visibility(visible: context.read<AdsBloc>().isRewardedEnabled, child: const RewardedAdContainer()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SelfChallengeContainer extends StatelessWidget {
  const _SelfChallengeContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NextScreen.nextScreenNormal(
          context,
          const SelfChallengePage(
            imageString: Config.selfChallengeCoverImage,
          )),
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'self-challenge-mode',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ).tr()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(fit: BoxFit.cover, image: AssetImage(Config.selfChallengeCoverImage)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'challenge-yourself',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                  ).tr(),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white60,
                        )),
                    child: Text(
                      'play-now',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ).tr(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserBloc>().userData;
    final int rank = context.watch<UserBloc>().userRank;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 15),
      height: 140,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'welcome-back',
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ).tr(),
                        const SizedBox(
                          width: 5,
                        ),
                        //Image.asset(Config.hiEmoji, width: 25, height: 25,)
                        LottieBuilder.asset(
                          Config.hiAnimation,
                          height: 25,
                          width: 25,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      user!.name!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                AvatarGlow(
                  endRadius: 36,
                  animate: true,
                  repeat: true,
                  showTwoGlows: false,
                  child: InkWell(
                    onTap: () => context.read<TabControllerBloc>().controlTab(2),
                    child: AvatarCircle(assetString: user.avatarString, imageUrl: user.imageUrl, size: 60, bgColor: ColorConfig.avatarBg1),
                  ),
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                InkWell(
                  child: CustomChip1(label: user.points.toString(), icon: IconUtils.starFill, bgColor: ColorConfig.chip1),
                  onTap: () => context.read<TabControllerBloc>().controlTab(2),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: CustomChip1(label: '#$rank', icon: IconUtils.leaderboard1, bgColor: ColorConfig.chip2),
                  onTap: () => NextScreen.nextScreenNormal(context, const LeaderboardTab()),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => NextScreen.nextScreenNormal(context, const Notifications()),
                  child: CircleAvatar(
                    backgroundColor: ColorConfig.iconBg,
                    child: const Icon(
                      IconUtils.bell,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => NextScreen.nextScreenNormal(context, const SettingsPage()),
                  child: CircleAvatar(
                    backgroundColor: ColorConfig.iconBg,
                    child: const Icon(
                      IconUtils.settings,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // Visibility(
                //   visible: IAPConfig.iAPEnabled,
                //   child: InkWell(
                //     onTap: () => NextScreen.nextScreenNormal(context, const IAPScreen()),
                //     child: CircleAvatar(
                //       backgroundColor: ColorConfig.iconBg,
                //       child: const Icon(
                //         IconUtils.store,
                //         size: 22,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
