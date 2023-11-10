import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/services/app_service.dart';

class Quiz {
  String? name;
  String? id;
  String? thumbnailUrl;
  String? parentId;
  bool? timer;
  int? quizTime;
  String? description;
  int? questionCount;
  int? pointsRequired;
  String? questionOrder;
  int? index;

  Quiz({
    required this.name,
    required this.id,
    required this.thumbnailUrl,
    required this.parentId,
    required this.timer,
    this.quizTime,
    required this.description,
    this.questionCount,
    this.pointsRequired,
    this.questionOrder,
    this.index
  });

  factory Quiz.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<dynamic, dynamic>;
    return Quiz(
        name: d['name'],
        id: d['id'],
        thumbnailUrl: d['image_url'],
        parentId: d['parent_id'],
        timer: d['timer'],
        quizTime: d['quiz_time'],
        description: d['description'],
        questionCount: d['question_count'],
        pointsRequired: d['points_required'],
        questionOrder: AppService.getQuestionOrder(d['question_order']),
        index: d['index'] ?? 0
    );
  }

  static Map<String, dynamic> getMap(Quiz d) {
    return {
      'name': d.name,
      'id': d.id,
      'image_url': d.thumbnailUrl,
      'parent_id': d.parentId,
      'timer': d.timer,
      'time_per_question': d.quizTime,
      'description': d.description,
      'question_count': d.questionCount,
      'points_required': d.pointsRequired,
      'question_order': d.questionOrder,
      'index': d.index
    };
  }
}
