import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/audio_controller.dart';
import 'package:quiz_app/blocs/temp_bloc.dart';
import 'package:quiz_app/configs/color_config.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/pages/question_overview.dart';
import 'package:quiz_app/utils/next_screen.dart';

class QuizComplete extends StatefulWidget {
  const QuizComplete({Key? key, required this.qList, required this.isTimeOver})
      : super(key: key);

  final List<Question> qList;
  final bool isTimeOver;

  @override
  State<QuizComplete> createState() => _QuizCompleteState();
}

class _QuizCompleteState extends State<QuizComplete> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      if(context.read<SoundControllerBloc>().audioEnabled){
        context.read<SoundControllerBloc>().playSound(context.read<SoundControllerBloc>().congratsSoundId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 60,
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            child: Text(
              'done',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ).tr(),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.isTimeOver ? 'time-over' : 'good-job',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.grey[900],
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    widget.isTimeOver ? Container()
                    : Text(
                      'quiz-complete',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 18
                          ),
                    ).tr(),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: CircularPercentIndicator(
                        animation: true,
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: context.read<TempBloc>().currentAnsCount /
                            widget.qList.length,
                        center: Text(
                          "${context.read<TempBloc>().currentAnsCount}/${widget.qList.length}",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontSize: 30, color: Colors.white),
                        ),
                        progressColor: Colors.blueAccent,
                        backgroundColor: Colors.white,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                    InkWell(
                      onTap: () => NextScreen.openBottomSheet(
                          context, QuestionOverview(qList: widget.qList)),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        decoration: BoxDecoration(
                            color: ColorConfig.overviewBtn,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'quiz-overview',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                fontSize: 16,
                                color: Colors.white, fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
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
                  crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
              children: [
                _infoCard(context, 'correct-answer'.tr(), context.read<TempBloc>().currentAnsCount.toString()),
                _infoCard(context, 'incorrect-answer'.tr(), context.read<TempBloc>().incorrectAnsCount.toString()),
                _infoCard(context, 'not-answered'.tr(), _getSkippedCount(context)),
                _infoCard(context, 'points-earned'.tr(), '+${context.read<TempBloc>().pointsEarned}'),
                _infoCard(context, 'points-loss'.tr(), '-${context.read<TempBloc>().pointLoss}'),
                _infoCard(context, 'completion'.tr(), '${(context.read<TempBloc>().selectedIndexList.length/widget.qList.length * 100).round()}%'),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getSkippedCount(BuildContext context) {
    if (widget.qList.length == context.read<TempBloc>().selectedIndexList.length) {
      return '0';
    } else {
      int count =
          widget.qList.length - context.read<TempBloc>().selectedIndexList.length;
      return count.toString();
    }
  }

  Widget _infoCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10)
      ),
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
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
