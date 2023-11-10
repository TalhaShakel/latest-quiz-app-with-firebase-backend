import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constant.dart';

class Question {
  String? id;
  String? categoryName;
  String? catId;
  String? quizId;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? questionTitle;
  List? options;
  int? correctAnswerIndex;
  bool? hasFourOptions;
  String? questionType;
  String? questionImageUrl;
  String? questionAudioUrl;
  String? questionVideoUrl;
  String? explaination;
  String? optionsType;

  Question({
    this.id,
    this.categoryName,
    this.catId,
    this.quizId,
    this.createdAt,
    this.updatedAt,
    this.questionTitle,
    this.options,
    this.correctAnswerIndex,
    this.hasFourOptions,
    this.questionType,
    this.questionImageUrl,
    this.questionAudioUrl,
    this.questionVideoUrl,
    this.explaination,
    this.optionsType,
  });

  factory Question.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<dynamic, dynamic>;
    return Question(
        id: d['id'],
        categoryName: null,
        catId: d['cat_id'],
        quizId: d['quiz_id'],
        createdAt: d['created_at'],
        updatedAt: d['updated_at'],
        questionTitle: d['question_title'],
        options: d['options'],
        correctAnswerIndex: d['correct_ans_index'],
        hasFourOptions: d['has_four_options'],
        questionType: d['question_type'],
        questionImageUrl: d['question_image_url'],
        questionAudioUrl: d['question_audio_url'],
        questionVideoUrl: d['question_video_url'],
        explaination: d['explaination'],
        optionsType: _getOptionsTyoe(d['has_four_options'], d['options_type'])
    );
  }

  static Map<String, dynamic> getMap (Question d){
    return {
      'id': d.id,
      'cat_id': d.catId,
      'quiz_id': d.quizId,
      'created_at': d.createdAt,
      'updated_at': d.updatedAt,
      'question_title': d.questionTitle,
      'options': d.options,
      'correct_ans_index': d.correctAnswerIndex,
      'has_four_options': d.hasFourOptions,
      'question_type': d.questionType,
      'question_image_url': d.questionImageUrl,
      'question_audio_url': d.questionAudioUrl,
      'question_video_url': d.questionVideoUrl,
      'explaination': d.explaination,
      'options_type': d.optionsType
    };
  }


  static String _getOptionsTyoe(bool? hasFourOptions, String? optionString) {
    if (hasFourOptions == null) {
      return optionString!;
    } else {
      if (hasFourOptions) {
        return Constants.optionTypes.keys.elementAt(0);
      } else {
        return Constants.optionTypes.keys.elementAt(1);
      }
    }
  }
}
