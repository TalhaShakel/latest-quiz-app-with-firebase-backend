import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/utils/cached_image.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import '../models/quiz.dart';
import '../pages/quiz_info.dart';
import '../utils/next_screen.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({Key? key, required this.quiz, required this.heroTag, this.enablePlayAgain}) : super(key: key);

  final Quiz quiz;
  final String heroTag;
  final bool? enablePlayAgain;

  @override
  Widget build(BuildContext context) {
    final List completedIds = context.watch<UserBloc>().userData!.completedQuizzes ?? [];
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: InkWell(
              onTap: () => NextScreen.nextScreenNormal(
                  context,
                  QuizInfo(
                    quiz: quiz,
                    heroTag: heroTag,
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Hero(tag: heroTag, child: CustomCacheImage(imageUrl: quiz.thumbnailUrl, radius: 10)),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          quiz.name.toString(),
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Wrap(
                          children: [
                            const Text('questions-count').tr(args: [quiz.questionCount.toString()]),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: quiz.timer == true,
                              child: Wrap(
                                children: [
                                  const Icon(
                                    IconUtils.timer,
                                    size: 20,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  const Text('minute-count').tr(args: [quiz.quizTime.toString()]),
                                ],
                              ),
                            ),
                            Visibility(visible: enablePlayAgain == true, child: Chip(label: const Text('play-again').tr()))
                          ],
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )),
        Visibility(
          visible: completedIds.contains(quiz.id),
          child: Align(
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), topRight: Radius.circular(10)),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  color: Theme.of(context).primaryColor,
                  child: const Icon(
                    IconUtils.done,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
