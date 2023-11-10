import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/widgets/html_body.dart';

class QuestionExplaination extends StatelessWidget {
  const QuestionExplaination({Key? key, required this.q}) : super(key: key);

  final Question q;

  @override
  Widget build(BuildContext context) {
    final String correctAnswer = q.options!.elementAt(q.correctAnswerIndex!);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Question Explaination',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.questionTitle.toString(), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        IconUtils.rightAnswerOption,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        correctAnswer,
                        style: Theme.of(context).textTheme.labelLarge,
                      )),
                    ],
                  ),
                ],
              ),
            ),
            HtmlBody(description: q.explaination.toString())
          ],
        ),
      ),
    );
  }
}
