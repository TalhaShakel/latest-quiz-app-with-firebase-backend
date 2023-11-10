import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/temp_bloc.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/pages/question_explaination.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/next_screen.dart';

import '../constants/constant.dart';
import '../services/app_service.dart';
import '../utils/cached_image.dart';
import '../utils/image_preview.dart';
import '../widgets/audio_widget.dart';
import '../widgets/video_player_widget.dart';

class QuestionOverview extends StatelessWidget {
  final List<Question> qList;
  const QuestionOverview({Key? key, required this.qList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey[900],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('quiz-overview').tr(),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
        itemCount: qList.length,
        itemBuilder: (BuildContext context, int index) {
          Question q = qList[index];
          return Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Q${index + 1}. ${q.questionTitle}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
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
                        title: _getOption(q, index, optionIndex, context),
                        leading: Icon(
                          _getIcon(q, optionIndex, context),
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        )))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getOption(Question q, int listIndex, int optionIndex, BuildContext context) {
    if (q.optionsType == Constants.optionTypes.keys.elementAt(0) || q.optionsType == Constants.optionTypes.keys.elementAt(1)) {
      return RichText(
        text: TextSpan(
          text: '${q.options![optionIndex]}   ',
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
          children: <TextSpan>[
            TextSpan(text: _getSelectedAnswer(listIndex, optionIndex, context), style: const TextStyle(color: Colors.blueGrey)),
          ],
        ),
      );
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

  String _getSelectedAnswer(int index, int optionIndex, BuildContext context) {
    final list = XList(context.read<TempBloc>().selectedIndexList);
    if (list[index] == null) {
      return 'not-answered()'.tr();
    } else if (optionIndex == context.read<TempBloc>().selectedIndexList[index]) {
      return 'your-answer()'.tr();
    } else {
      return '';
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
