import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/models/category.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/empty_animation.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import '../cards/quiz_card.dart';
import '../models/quiz.dart';

class Quizzes extends StatefulWidget {
  final Category category;
  const Quizzes({Key? key, required this.category}) : super(key: key);

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'quizes';
  late Future _future;

  Future<List<Quiz>> _getQuizzesByIndex() async {
    List<Quiz> quizzes = [];
    await FirebaseService().getCategoryBasedQuizes(widget.category.id!).then((List<Quiz> value) {
      bool hasIndex = value.isEmpty
          ? false
          : value[0].index != null
              ? true
              : false;
      quizzes = value;
      if (hasIndex) {
        quizzes.sort((a, b) => a.index!.compareTo(b.index!));
      }
    });
    return quizzes;
  }

  @override
  void initState() {
    super.initState();
    _future = _getQuizzesByIndex();
  }

  _onRefresh() {
    _future = _getQuizzesByIndex();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          title: Text(
            widget.category.name!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => _onRefresh(),
          child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicatorWidget();
              } else if (snapshot.hasData && snapshot.data.length != 0) {
                return AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Quiz quiz = snapshot.data[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: QuizCard(quiz: quiz, heroTag: quiz.id.toString(),),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return EmptyAnimation(animationString: Config.emptyAnimation, title: 'no-content'.tr());
              }
            },
          ),
        ));
  }
}
