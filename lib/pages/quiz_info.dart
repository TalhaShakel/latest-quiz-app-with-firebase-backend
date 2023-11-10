import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/settings_bloc.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/constants/constant.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/pages/quiz_screen.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/animation_dialog.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/custom_chip.dart';
import 'package:quiz_app/widgets/html_body.dart';
import 'package:quiz_app/widgets/loading_widget.dart';

import '../blocs/temp_bloc.dart';
import '../models/question.dart';

class QuizInfo extends StatefulWidget {
  const QuizInfo({Key? key, required this.quiz, required this.heroTag}) : super(key: key);

  final Quiz quiz;
  final String heroTag;

  @override
  State<QuizInfo> createState() => _QuizInfoState();
}

class _QuizInfoState extends State<QuizInfo> {

  bool _isLoading = false;

  _updatePointsHistory(int points) async {
    final String userId = context.read<UserBloc>().userData!.uid!;
    final newHistory = "Played A Quiz -$points at ${DateTime.now()}";
    await FirebaseService().updateUserPointHistory(userId, newHistory);
  }

  Future _checkEligibility () async{
    if(context.read<UserBloc>().userData!.points! < widget.quiz.pointsRequired!){
      openAnimationDialog(context, Config.emptyBoxAnimation, 'not-enough-points'.tr(), 'minimum-points-count'.tr(args: [widget.quiz.pointsRequired.toString()]));
    }else{
      setState (()=> _isLoading = true);
      await FirebaseService().getQuestions(widget.quiz.id!).then((List<Question> qList)async{
        if(qList.isNotEmpty){

          //get Questions by order
          if(widget.quiz.questionOrder == Constants.questionOrders[0]){
            qList.shuffle();
          }else if(widget.quiz.questionOrder == Constants.questionOrders[1]){
            qList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!),);
          }else{
            qList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!),);
          }

          await FirebaseService().updateUserPointsByTransection(context.read<UserBloc>().userData!.uid!, false, widget.quiz.pointsRequired!)
          .then((value) => _updatePointsHistory(widget.quiz.pointsRequired!))
          .then((_)=> context.read<UserBloc>().getUserData())
          .then((_)async{
            await context.read<TempBloc>().intializeTempData(context.read<UserBloc>().userData!.points!);
            setState (()=> _isLoading = false);
            // ignore: use_build_context_synchronously
            NextScreen().nextScreenReplace(context, QuizScreen(qList: qList, hasTimer: widget.quiz.timer!, quizTime: widget.quiz.quizTime!, selfChallengeMode: false,));
          });

        }else{
          setState (()=> _isLoading = false);
          openAnimationDialog(context, Config.emptyBoxAnimation, 'not-enough-questions-title'.tr(), 'not-enough-questions-subtitle'.tr());
        }
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc sb = context.read<SettingsBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        onTap: (() async => await _checkEligibility()),
        child: Container(
          alignment: Alignment.center,
          height: 60,
          color: Theme.of(context).primaryColor,
          child: _isLoading == true ? const LoadingIndicatorWidget(color: Colors.white,)
          : Text(
            'start-quiz',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ).tr(),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.large(
            elevation: 0.5,
            titleSpacing: 0,
            stretch: true,
            pinned: true,
            centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(bottom: 16, start: 50, end: 20),
                title: Text('quiz-overview-count', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white
                ),).tr(args: [widget.quiz.name!]),
                centerTitle: false,
                background: Hero(
                  tag: widget.heroTag,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              widget.quiz.thumbnailUrl!,
                            ))),
                  ),
                ),
              )),

              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20,),
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          
                          children: [
                            CustomChip(label: 'points-required-count'.tr(args: [widget.quiz.pointsRequired.toString()]), bgColor: Colors.blueGrey),
                            CustomChip(label: 'reward/question-count'.tr(args: [sb.correctAnsReward.toString()]), bgColor: Colors.pink),
                            CustomChip(label: 'penalty/question-count'.tr(args: [sb.incorrectAnsPenalty.toString()]), bgColor: Colors.orange),
                            Visibility(
                              visible: widget.quiz.timer!,
                              child: CustomChip(label: 'time-count'.tr(args: [widget.quiz.quizTime.toString()]), bgColor: Colors.green)),
                            
                          ],
                        ),
                      ),
                      HtmlBody(description: widget.quiz.description ?? '')
                    ],
                  ),
                ),
              )
        ],
      ),
    );
  }
}
