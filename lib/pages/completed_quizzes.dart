import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/cards/quiz_card.dart';
import 'package:quiz_app/models/quiz.dart';
import '../configs/app_config.dart';
import '../utils/empty_animation.dart';
import '../widgets/loading_widget.dart';

class CompletedQuizzes extends StatefulWidget {
  const CompletedQuizzes({Key? key}) : super(key: key);

  @override
  State<CompletedQuizzes> createState() => _CompletedQuizzesState();
}

class _CompletedQuizzesState extends State<CompletedQuizzes> {
  late Future _future;

  @override
  void initState() {
    _future = _getItems();
    super.initState();
  }

  Future<List<Quiz>> _getItems() async {
    List itemIds = _getQuizIds();
    final chunks = partition(itemIds, 10);
    List<Quiz> qList = [];
    final querySnapshots = await Future.wait(chunks.map((chunk) {
      Query itemsQuery = FirebaseFirestore.instance.collection('quizes').where("id", whereIn: chunk);
      return itemsQuery.get();
    }).toList());
    for (var element in querySnapshots) {
      qList.addAll(element.docs.map((e) => Quiz.fromFirestore(e)).toList());
    }
    return qList;
  }


  List _getQuizIds (){
    List ids = context.read<UserBloc>().userData!.completedQuizzes ?? [];
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: const Text(
          'completed-quizzes',
          style: TextStyle(color: Colors.white),
        ).tr(),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.30),
                const LoadingIndicatorWidget(),
              ],
            );
          } else if (snapshot.hasData && snapshot.data.length != 0) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final Quiz q = snapshot.data[index];
                return QuizCard(quiz: q, heroTag: 'completed${q.id}', enablePlayAgain: true,);
              },
            );
          } else {
            return EmptyAnimation(animationString: Config.emptyAnimation, title: 'no-content'.tr());
          }
        },
      ),
    );
  }

  
}
