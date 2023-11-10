import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/ads_bloc.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/pages/bookmarked_questions.dart';
import 'package:quiz_app/pages/completed_quizzes.dart';
import 'package:quiz_app/pages/edit_profile.dart';
import 'package:quiz_app/pages/points_history.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/avatar_circle.dart';
import 'package:quiz_app/widgets/rewarded_ad_container.dart';

import '../blocs/user_bloc.dart';
import '../configs/color_config.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    UserModel? user = context.watch<UserBloc>().userData;
    final int rank = context.watch<UserBloc>().userRank;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: Visibility(visible: context.read<AdsBloc>().isRewardedEnabled, child: const RewardedAdContainer()),
      appBar: AppBar(
        title: const Text(
          "profile",
          style: TextStyle(color: Colors.white),
        ).tr(),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            icon: const Icon(
              IconUtils.editProfile,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              'edit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ).tr(),
            onPressed: () => NextScreen().nextScreenPopup(
                context,
                EditProfile(
                  userData: context.read<UserBloc>().userData!,
                )),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              height: 60,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: ColorConfig.bgColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        user!.name!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    IconUtils.starFill,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'points',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[400]),
                                  ).tr(),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    user.points.toString(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                  )
                                ],
                              ),
                              const VerticalDivider(
                                width: 20,
                                color: Colors.white,
                                thickness: 0.5,
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    IconUtils.leaderboard1,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'rank',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[400]),
                                  ).tr(),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '#$rank',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1.6, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        children: [
                          _infoCard(context, 'quiz-completed'.tr(), user.totalQuizPlayed.toString()),
                          _infoCard(context, 'question-answered'.tr(), user.totalQuestionAnswered.toString()),
                          _infoCard(context, 'correct-answer'.tr(), user.totalCorrectAns.toString()),
                          _infoCard(context, 'incorrect-answer'.tr(), user.totalIncorrectAns.toString()),
                        ],
                      ),
                      Visibility(
                        visible: FeatureConfig.userStrengthEnabled,
                        child: Container(height: 180, margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), width: double.infinity, child: _strengthCard(context, user.strength!))),
                      Visibility(
                        visible: FeatureConfig.bookmarkQuestionEnabled,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              onTap: ()=> NextScreen.nextScreenNormal(context, const BookmarkedQuestions()),
                              title: Text('bookmarked-questions', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18
                              ),).tr(),
                              leading: Icon(IconUtils.bookmark, color: Theme.of(context).primaryColor,),
                              trailing: const Icon(IconUtils.navigate),
                            )
                        ),
                      ),
                      Visibility(
                        visible: FeatureConfig.completedQuizzesEnabled,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              onTap: ()=> NextScreen.nextScreenNormal(context, const CompletedQuizzes()),
                              title: Text('completed-quizzes', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18
                              ),).tr(),
                              leading: Icon(IconUtils.done, color: Theme.of(context).primaryColor,),
                              trailing: const Icon(IconUtils.navigate),
                            )
                        ),
                      ),
                      Visibility(
                        visible: FeatureConfig.pointsHistoryEnabled,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              onTap: ()=> NextScreen.nextScreenNormal(context, const PointsHistory()),
                              title: Text('points-history', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18
                              ),).tr(),
                              leading: Icon(IconUtils.starFill, color: Theme.of(context).primaryColor,),
                              trailing: const Icon(IconUtils.navigate),
                            )
                        ),
                      ),
                      const SizedBox(height: 50,),
                    ],
                  ),
                ),
                Positioned(
                  top: -55,
                  child: Column(
                    children: [
                      AvatarCircle(assetString: user.avatarString, imageUrl: user.imageUrl, size: 110, bgColor: Colors.greenAccent),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 10, 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _strengthCard(BuildContext context, double strength) {
    final strengthText = '${context.read<UserBloc>().userData!.totalCorrectAns}/${context.read<UserBloc>().userData!.totalQuestionAnswered}';
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'strength',
                  style: Theme.of(context).textTheme.bodyLarge,
                ).tr(),
                Text(
                  strength.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: double.infinity,
              child: CircularPercentIndicator(
                animation: true,
                radius: 60.0,
                lineWidth: 10.0,
                percent: 0.7,
                center: Text(
                  strengthText,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 25),
                ),
                progressColor: Theme.of(context).primaryColor,
                backgroundColor: ColorConfig.bgColor,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ],
        ));
  }
}
