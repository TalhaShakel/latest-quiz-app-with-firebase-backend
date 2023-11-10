import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/firebase_service.dart';
import '../configs/app_config.dart';
import '../constants/constant.dart';
import '../services/app_service.dart';
import '../utils/cached_image.dart';
import '../utils/empty_animation.dart';
import '../utils/icon_utils.dart';
import '../utils/image_preview.dart';
import '../utils/next_screen.dart';
import '../widgets/audio_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/video_player_widget.dart';
import 'question_explaination.dart';

class BookmarkedQuestions extends StatefulWidget {
  const BookmarkedQuestions({Key? key}) : super(key: key);

  @override
  State<BookmarkedQuestions> createState() => _BookmarkedQuestionsState();
}

class _BookmarkedQuestionsState extends State<BookmarkedQuestions> {
  late Future _future;

  @override
  void initState() {
    _future = _getItems();
    super.initState();
  }

  Future<List<Question>> _getItems() async {
    List itemIds = await FirebaseService().getBookmakedIds();
    final chunks = partition(itemIds, 10);
    List<Question> qList = [];
    final querySnapshots = await Future.wait(chunks.map((chunk) {
      Query itemsQuery = FirebaseFirestore.instance.collection('questions').where("id", whereIn: chunk);
      return itemsQuery.get();
    }).toList());
    for (var element in querySnapshots) {
      qList.addAll(element.docs.map((e) => Question.fromFirestore(e)).toList());
    }
    return qList;
  }

  _handleRemove(Question q) async {
    await FirebaseService().removeFromBookmark(q.id);
    _refresh();
  }

  _refresh() {
    _future = _getItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: const Text(
          'bookmarks',
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final Question q = snapshot.data[index];
                return _listItem(q, index);
              },
            );
          } else {
            return EmptyAnimation(animationString: Config.emptyAnimation, title: 'no-content'.tr());
          }
        },
      ),
    );
  }

  Container _listItem(Question q, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Q${index + 1}. ${q.questionTitle}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'clear',
                      child: Text(
                        'remove',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ).tr(),
                    ),
                  ];
                },
                child: const Icon(IconUtils.menu),
                onSelected: (value) => _handleRemove(q),
              )
            ],
          ),
          Visibility(
            visible: q.questionType == Constants.questionTypes.keys.elementAt(1),
            child: InkWell(
              onTap: () => NextScreen().nextScreenPopup(context, FullImagePreview(imageUrl: q.questionImageUrl!)),
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                height: 150,
                child: CustomCacheImage(
                  imageUrl: q.questionImageUrl,
                  radius: 5,
                ),
              ),
            ),
          ),
          Visibility(
            visible: q.questionType == Constants.questionTypes.keys.elementAt(3),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: VideoPlayerWidget(
                    videoUrl: q.questionVideoUrl.toString(),
                    videoType: AppService.getVideoType(q.questionVideoUrl.toString()),
                  )),
            ),
          ),
          Visibility(
              visible: q.questionType == Constants.questionTypes.keys.elementAt(2),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AudioWidget(
                  audioUrl: q.questionAudioUrl.toString(),
                ),
              )),
          Visibility(
            visible: q.explaination != null,
            child: Padding( 
              padding: const EdgeInsets.only(top: 15),
              child: ActionChip(
                label: const Text('explanation').tr(),
                onPressed: () {
                  NextScreen().nextScreenPopup(context, QuestionExplaination(q: q));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ...List.generate(
              q.options!.length,
              (optionIndex) => ListTile(
                  horizontalTitleGap: 0,
                  minVerticalPadding: 0,
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  title: _getOption(q, optionIndex),
                  leading: Icon(
                    _getIcon(q, optionIndex, context),
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  )))
        ],
      ),
    );
  }

  Widget _getOption(Question q, int optionIndex) {
    if (q.optionsType == Constants.optionTypes.keys.elementAt(0) || q.optionsType == Constants.optionTypes.keys.elementAt(1)) {
      return Text(q.options![optionIndex], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16));
    } else if (q.optionsType == Constants.optionTypes.keys.elementAt(2)) {
      return Container(
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: CustomCacheImage(imageUrl: q.options![optionIndex], radius: 5),
      );
    } else {
      return Container();
    }
  }

  IconData _getIcon(Question q, int optionIndex, BuildContext context) {
    if (optionIndex == q.correctAnswerIndex) {
      return IconUtils.rightAnswerOption;
    } else {
      return IconUtils.disbbleOption;
    }
  }
}

class XList<E> {
  List<E> list;
  XList(this.list);
  E? operator [](int position) {
    try {
      return list[position];
      // ignore: non_constant_identifier_names
    } catch (IndexOutOfBoundException) {
      return null;
    }
  }
}
