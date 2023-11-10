import 'dart:async';
import 'dart:io';
import 'package:auto_animated/auto_animated.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/ads_bloc.dart';
import 'package:quiz_app/blocs/audio_controller.dart';
import 'package:quiz_app/blocs/question_bloc.dart';
import 'package:quiz_app/blocs/temp_bloc.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:quiz_app/constants/constant.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/widgets/control_settings.dart';
import 'package:quiz_app/services/app_service.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/banner_ad.dart';
import 'package:quiz_app/utils/cached_image.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/image_preview.dart';
import 'package:quiz_app/utils/snackbars.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import 'package:quiz_app/widgets/video_player_widget.dart';
import '../blocs/settings_bloc.dart';
import '../cards/image_option_card.dart';
import '../cards/option_card.dart';
import '../utils/next_screen.dart';
import '../widgets/audio_widget.dart';
import '../widgets/timer_countdown.dart';
import 'quiz_complete.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key, required this.qList, required this.hasTimer, required this.quizTime, required this.selfChallengeMode})
      : super(key: key);
  final List<Question> qList;
  final bool hasTimer;
  final int quizTime;
  final bool selfChallengeMode;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedOptionIndex;
  bool _isLoading = false;

  _initInterstitalAds() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (context.read<AdsBloc>().isInterstitialEnabled) {
        context.read<AdsBloc>().createInterstitialAd();
      }
    });
  }

  @override
  void initState() {
    Future.microtask(() {
      context.read<QuestionBloc>().updateQuestion(widget.qList[0]);
      context.read<TempBloc>().setParcentage(0, widget.qList.length);
      _initInterstitalAds();
    });
    super.initState();
  }

  _updatePointsHistory() async {
    final String userId = context.read<UserBloc>().userData!.uid!;
    String newHistory = '';
    final int rewardAmount = (context.read<TempBloc>().pointsEarned - context.read<TempBloc>().pointLoss);
    if (rewardAmount.isNegative) {
      newHistory = 'Completed A Quiz $rewardAmount at ${DateTime.now()}';
    } else {
      newHistory = 'Completed A Quiz +$rewardAmount at ${DateTime.now()}';
    }
    await FirebaseService().updateUserPointHistory(userId, newHistory);
  }

  Future _onNextButtonPressed(int questionIndex) async {
    final UserModel user = context.read<UserBloc>().userData!;
    if (_selectedOptionIndex != null) {
      _updateTempData(questionIndex);

      if (widget.qList.length == (questionIndex + 1)) {
        setState(() => _isLoading = true);
        if (widget.selfChallengeMode == false) {
          //not for self challenge mode
          await FirebaseService().updateUserPoints(user.uid!, context.read<TempBloc>().points);
          // ignore: use_build_context_synchronously
          await context.read<UserBloc>().updateUserPointsToBloc(context.read<TempBloc>().points);
          await _updateUserStat();
          await _updatePointsHistory();
          await FirebaseService().updateCompletedQuizzes(widget.qList[questionIndex].quizId!, user);
          // ignore: use_build_context_synchronously
          await context.read<UserBloc>().getUserData();
        }
        setState(() => _isLoading = false);
        _showAd();
        // ignore: use_build_context_synchronously
        NextScreen().nextScreenReplace(
            context,
            QuizComplete(
              qList: widget.qList,
              isTimeOver: false,
            ));
      } else {
        context.read<QuestionBloc>().updateQuestion(widget.qList[questionIndex + 1]);
        context.read<TempBloc>().setParcentage(questionIndex + 1, widget.qList.length);
        if (context.read<SoundControllerBloc>().audioEnabled) {
          context.read<SoundControllerBloc>().playSound(context.read<SoundControllerBloc>().optionSoundId);
        }
      }

      setState(() => _selectedOptionIndex = null);
      // ignore: use_build_context_synchronously
      context.read<QuestionBloc>().controlPage(questionIndex + 1);
    } else {
      openSnackbar(context, "Select an option to continue");
    }
  }

  _showAd() {
    if (context.read<AdsBloc>().isInterstitialEnabled && context.read<AdsBloc>().isInterstitialAdLoaded) {
      context.read<AdsBloc>().showInterstitialAd();
    }
  }

  _updateUserStat() async {
    final user = context.read<UserBloc>().userData;
    final tb = context.read<TempBloc>();
    await FirebaseService().updateUserStatToDatabase(user!.uid!, user.totalQuizPlayed! + 1, user.totalQuestionAnswered! + tb.selectedIndexList.length,
        user.totalCorrectAns! + tb.currentAnsCount, user.totalIncorrectAns! + tb.incorrectAnsCount);
  }

  _updateTempData(int questionIndex) {
    TempBloc tb = context.read<TempBloc>();
    SettingsBloc sb = context.read<SettingsBloc>();
    if (_selectedOptionIndex == widget.qList[questionIndex].correctAnswerIndex) {
      int newPoints = tb.points + context.read<SettingsBloc>().correctAnsReward;
      tb.updateTempData(_selectedOptionIndex!, newPoints, widget.selfChallengeMode ? 0 : sb.correctAnsReward, true, 0);
    } else {
      int newPoints = tb.points - context.read<SettingsBloc>().incorrectAnsPenalty;
      tb.updateTempData(_selectedOptionIndex!, newPoints, 0, false, widget.selfChallengeMode ? 0 : sb.incorrectAnsPenalty);
    }
  }

  _onOptionPressed(int questionIndex, int optionIndex) async {
    setState(() => _selectedOptionIndex = optionIndex);
    if (context.read<SoundControllerBloc>().audioEnabled) {
      context.read<SoundControllerBloc>().playSound(context.read<SoundControllerBloc>().clickSoundId);
    }
    if (context.read<SoundControllerBloc>().vibrationEnabled) {
      if (Platform.isAndroid) {
        HapticFeedback.vibrate();
      } else if (Platform.isIOS) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  _openControlDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: const ControllSettings(),
            title: const Text('settings').tr(),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
          );
        }));
  }

  _openCloseDialog() async {
    return Dialogs.materialDialog(
        context: context,
        title: 'quit-quiz-title'.tr(),
        msg: 'quit-quiz-subtitle'.tr(),
        color: Colors.white,
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        msgAlign: TextAlign.center,
        msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        lottieBuilder: LottieBuilder.asset(
          Config.quitAnimation,
          fit: BoxFit.contain,
        ),
        actions: [
          IconsOutlineButton(
            text: 'no'.tr(),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            onPressed: () => Navigator.pop(context),
          ),
          IconsOutlineButton(
            text: 'yes'.tr(),
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]);
  }

  _handleAddToBookmark() async {
    final Question? question = context.read<QuestionBloc>().question;
    if (question != null) {
      await FirebaseService().addToBookmark(question.id!).then((value) {
        openSnackbar(context, 'bookmark-message'.tr());
      });
    } else {
      openSnackbar(context, 'Error on adding bookmark');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _openCloseDialog(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: SafeArea(
          child: Visibility(visible: context.read<AdsBloc>().isBannerAdEnabled, child: const BannerAdWidget()),
        ),
        appBar: _progressBar(context),
        body: PageView.builder(
          pageSnapping: true,
          physics: const NeverScrollableScrollPhysics(),
          padEnds: true,
          reverse: false,
          controller: context.read<QuestionBloc>().pageController,
          itemCount: widget.qList.length,
          itemBuilder: (context, questionIndex) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 3,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'question-count-title',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey[800]),
                              ).tr(args: [context.watch<TempBloc>().currentQuestionIndex.toString(), widget.qList.length.toString()]),
                              Text(widget.qList[questionIndex].questionTitle!,
                                  style:
                                      Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.blueGrey.shade900))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.qList[questionIndex].questionType == Constants.questionTypes.keys.elementAt(1),
                    child: InkWell(
                      onTap: () => NextScreen().nextScreenPopup(context, FullImagePreview(imageUrl: widget.qList[questionIndex].questionImageUrl!)),
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: CustomCacheImage(
                          imageUrl: widget.qList[questionIndex].questionImageUrl,
                          radius: 5,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.qList[questionIndex].questionType == Constants.questionTypes.keys.elementAt(3),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: VideoPlayerWidget(
                          videoUrl: widget.qList[questionIndex].questionVideoUrl.toString(),
                          videoType: AppService.getVideoType(widget.qList[questionIndex].questionVideoUrl.toString()),
                        )),
                  ),
                  Visibility(
                      visible: widget.qList[questionIndex].questionType == Constants.questionTypes.keys.elementAt(2),
                      child: AudioWidget(
                        audioUrl: widget.qList[questionIndex].questionAudioUrl.toString(),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 50, top: 20),
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey[200]!, blurRadius: 10, offset: const Offset(0, 5))]),
                          child: LiveList(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.qList[questionIndex].options!.length,
                              itemBuilder: (context, optionIndex, animation) {
                                bool isSelected = _selectedOptionIndex != null && _selectedOptionIndex == optionIndex;

                                return FadeTransition(
                                  opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                                  child: SlideTransition(
                                    position: Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(animation),
                                    child: InkWell(
                                      child: widget.qList[questionIndex].optionsType == Constants.optionTypes.keys.elementAt(0) ||
                                              widget.qList[questionIndex].optionsType == Constants.optionTypes.keys.elementAt(1)
                                          ? OptionCard(
                                              isSelected: isSelected,
                                              optionTitle: widget.qList[questionIndex].options![optionIndex],
                                            )
                                          : ImageOptionCard(
                                              isSelected: isSelected,
                                              optionImage: widget.qList[questionIndex].options![optionIndex],
                                            ),
                                      onTap: () => _onOptionPressed(questionIndex, optionIndex),
                                    ),
                                  ),
                                );
                              }))),
                  _NextButton(questionIndex, context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _progressBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: LinearPercentIndicator(
        animation: true,
        animationDuration: 400,
        lineHeight: 20.0,
        leading: IconButton(
            padding: const EdgeInsets.only(left: 10),
            onPressed: () => _openCloseDialog(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        trailing: Row(
          children: [
            Visibility(
                visible: widget.hasTimer && widget.quizTime != 0,
                child: TimerCountDown(
                  quizTime: widget.quizTime,
                  qList: widget.qList,
                  selfChallengeMode: widget.selfChallengeMode,
                )),
            Visibility(
              visible: FeatureConfig.bookmarkQuestionEnabled,
              child: InkWell(
                onTap: () => _handleAddToBookmark(),
                child: Container(
                    width: 40,
                    height: 30,
                    margin: const EdgeInsets.only(right: 0, left: 10),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(IconUtils.addBookmark)),
              ),
            ),
            InkWell(
              onTap: () => _openControlDialog(),
              child: Container(
                width: 40,
                height: 30,
                margin: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(20)),
                child: const Icon(
                  Ionicons.options,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        percent: context.watch<TempBloc>().percentage,
        progressColor: Theme.of(context).primaryColor,
        barRadius: const Radius.circular(30),
        animateFromLastPercent: true,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  OutlinedButton _NextButton(int questionIndex, BuildContext context) {
    return OutlinedButton(
      onPressed: () => _onNextButtonPressed(questionIndex),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
          fixedSize: MaterialStateProperty.resolveWith((states) => Size(MediaQuery.of(context).size.width * 0.70, 50))),
      child: _isLoading
          ? const LoadingIndicatorWidget(
              color: Colors.white,
            )
          : Text(
              'next',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            ).tr(),
    );
  }
}
