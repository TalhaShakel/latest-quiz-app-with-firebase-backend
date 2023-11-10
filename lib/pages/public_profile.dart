import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quiz_app/configs/color_config.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/widgets/avatar_circle.dart';


class PublicProfile extends StatelessWidget {
  const PublicProfile({Key? key, required this.user, required this.rank}) : super(key: key);

  final UserModel user;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: ()=> Navigator.pop(context),),
        elevation: 0,
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
                      color: ColorConfig.bgColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        user.name!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                                    Icons.star_border_outlined,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'points',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[400]),
                                  ).tr(),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    user.points.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
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
                                    Icons.leaderboard_outlined,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'rank',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[400]),
                                  ).tr(),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '#$rank',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        children: [
                          _infoCard(context, 'quiz-completed'.tr(),
                              user.totalQuizPlayed.toString()),
                          _infoCard(context, 'question-answered'.tr(),
                              user.totalQuestionAnswered.toString()),
                          _infoCard(context, 'correct-answer'.tr(),
                              user.totalCorrectAns.toString()),
                          _infoCard(context, 'incorrect-answer'.tr(),
                              user.totalIncorrectAns.toString()),
                        ],
                      ),
                      Visibility(
                        visible: FeatureConfig.userStrengthEnabled,
                        child: Container(
                            height: 180,
                            margin: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: _StrengthCard(context, user.strength!)),
                      ),
                      const SizedBox(height: 50,)
                    ],
                  ),
                ),
                Positioned(
                  top: -55,
                  child: Column(
                    children: [
                      AvatarCircle(
                          assetString: user.avatarString,
                          imageUrl: user.imageUrl,
                          size: 110,
                          bgColor: ColorConfig.avatarBg3),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 10, 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _StrengthCard(BuildContext context, double strength) {
    final strengthText = '${user.totalCorrectAns}/${user.totalQuestionAnswered}';
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
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
              style: Theme.of(context).textTheme.bodyMedium,
            ).tr(),
            Text(
              strength.toStringAsFixed(2),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
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
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 25),
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
