import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/settings_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/pages/quiz_screen.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/animation_dialog.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import '../blocs/temp_bloc.dart';
import '../blocs/user_bloc.dart';
import '../models/question.dart';
import '../utils/next_screen.dart';
import '../widgets/custom_chip.dart';

class SelfChallengePage extends StatefulWidget {
  const SelfChallengePage({Key? key, required this.imageString}) : super(key: key);

  final String imageString;

  @override
  State<SelfChallengePage> createState() => _SelfChallengePageState();
}

class _SelfChallengePageState extends State<SelfChallengePage> {
  final formKey = GlobalKey<FormState>();
  String? _selectedQuizId;
  int? _selectedMinutes;
  int? _selectedQuestionAmount;

  late Future _quizes;
  bool _isLoading = false;

  static const List<int> _quizAmoutList = [2, 10, 20, 30, 40, 50, 60];
  static const List<int> _timeListInMinutes = [1, 2, 3, 5, 6, 7, 8, 9, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    _quizes = FirebaseService().getQuizes();
  }

  Future _checkEligibility() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final SettingsBloc sb = context.read<SettingsBloc>();
      if (context.read<UserBloc>().userData!.points! < sb.requiredPointsPlaySelfChallengeMode) {
        openAnimationDialog(context, Config.emptyBoxAnimation, 'not-enough-points'.tr(),
            'minimum-points-count'.tr(args: [sb.requiredPointsPlaySelfChallengeMode.toString()]));
      } else {
        setState(() => _isLoading = true);
        await FirebaseService().getQuestionForSelfChallengeMode(_selectedQuizId!, _selectedQuestionAmount!).then((List<Question> qList) async {
          if (qList.isEmpty || qList.length < _selectedQuestionAmount!) {
            setState(() => _isLoading = false);
            openAnimationDialog(context, Config.emptyBoxAnimation, 'not-enough-questions-title'.tr(), 'not-enough-questions-subtitle'.tr());
          } else {
            await FirebaseService()
                .updateUserPointsByTransection(context.read<UserBloc>().userData!.uid!, false, sb.requiredPointsPlaySelfChallengeMode)
                .then((int newPoints) => context.read<UserBloc>().updateUserPointsToBloc(newPoints))
                .then((_) async {
              context.read<TempBloc>().intializeTempData(context.read<UserBloc>().userData!.points!);
              setState(() => _isLoading = false);
              NextScreen().nextScreenReplace(
                  context,
                  QuizScreen(
                    qList: qList,
                    hasTimer: true,
                    quizTime: _selectedMinutes!,
                    selfChallengeMode: true,
                  ));
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc sb = context.read<SettingsBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        onTap: () => _checkEligibility(),
        child: Container(
          alignment: Alignment.center,
          height: 60,
          color: Theme.of(context).primaryColor,
          child: _isLoading == true
              ? const LoadingIndicatorWidget(
                  color: Colors.white,
                )
              : Text(
                  'start-quiz',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ).tr(),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.medium(
            elevation: 0.5,
            titleSpacing: 0,
            stretch: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(bottom: 16, start: 50, end: 20),
              title: Text(
                'self-challenge-mode',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 20),
              ).tr(),
              centerTitle: false,
              background: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(widget.imageString),
              ))),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CustomChip(
                            label: 'points-required-count'.tr(args: [sb.requiredPointsPlaySelfChallengeMode.toString()]), bgColor: Colors.pink),
                        CustomChip(label: 'reward/question-count'.tr(args: [0.toString()]), bgColor: Colors.orange),
                        CustomChip(label: 'penalty/question-count'.tr(args: [0.toString()]), bgColor: Colors.red),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    FutureBuilder(
                      future: _quizes,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<Quiz> qList = snapshot.data;
                          return _quizDropdown(qList);
                        }

                        return const LoadingIndicatorWidget();
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    _questionAmountDropdown(),
                    const SizedBox(
                      height: 25,
                    ),
                    _timerDropdown(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quizDropdown(List<Quiz> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quiz',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        const SizedBox(
          height: 5,
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
                itemHeight: 50,
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (dynamic value) {
                  setState(() {
                    _selectedQuizId = value;
                  });
                },
                validator: (value) => value == null ? 'Select an option' : null,
                value: _selectedQuizId,
                hint: const Text('select-quiz').tr(),
                items: categories.map((f) {
                  return DropdownMenuItem(
                    value: f.id,
                    child: Text(f.name!),
                  );
                }).toList())),
      ],
    );
  }

  Widget _questionAmountDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'question-amount',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        const SizedBox(
          height: 5,
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
                itemHeight: 50,
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (dynamic value) {
                  setState(() {
                    _selectedQuestionAmount = value;
                    debugPrint(_selectedQuestionAmount.toString());
                  });
                },
                value: _selectedQuestionAmount,
                validator: (value) => value == null ? 'Select an option' : null,
                hint: const Text('select-question-amount').tr(),
                items: _quizAmoutList.map((f) {
                  return DropdownMenuItem(
                    value: f,
                    child: Text('$f Questions'),
                  );
                }).toList())),
      ],
    );
  }

  Widget _timerDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'duration',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        const SizedBox(
          height: 5,
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
                itemHeight: 50,
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (dynamic value) {
                  setState(() {
                    _selectedMinutes = value;
                  });
                },
                value: _selectedMinutes,
                validator: (value) => value == null ? 'select-option'.tr() : null,
                hint: const Text('select-duration').tr(),
                items: _timeListInMinutes.map((f) {
                  return DropdownMenuItem(
                    value: f,
                    child: const Text('minute-count').tr(args: [f.toString()]),
                  );
                }).toList())),
      ],
    );
  }
}
