import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/pages/quizzes.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import '../cards/quiz_card.dart';
import '../models/category.dart';
import '../services/firebase_service.dart';

class SpecialCategory2 extends StatefulWidget {
  const SpecialCategory2({Key? key, required this.catID}) : super(key: key);
  final String catID;

  @override
  State<SpecialCategory2> createState() => _SpecialCategory2State();
}

class _SpecialCategory2State extends State<SpecialCategory2> with AutomaticKeepAliveClientMixin {
  late Future _category;
  late Future _quizzes;

  Future<List<Quiz>> _getQuizzesByIndex() async {
    List<Quiz> quizzes = [];
    await FirebaseService().getCategoryBasedQuizesByLimit(widget.catID, 3).then((List<Quiz> value) {
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
    _category = FirebaseService().getCategory(widget.catID);
    _quizzes = _getQuizzesByIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: FutureBuilder(
              future: _category,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || !snapshot.hasData) {
                  return Container();
                }
                Category category = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.name.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[900], fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                        onPressed: () => NextScreen.nextScreenNormal(context, Quizzes(category: category)), child: const Text('explore-all').tr())
                  ],
                );
              },
            ),
          ),
          FutureBuilder(
            future: _quizzes,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.hasData && snapshot.data.length == 0) {
                return Center(child: const Text('no-content').tr());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    Quiz quiz = snapshot.data[index];
                    return QuizCard(quiz: quiz, heroTag: 'sp2${quiz.id}',);
                  },
                );
              }
              return const LoadingIndicatorWidget();
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
