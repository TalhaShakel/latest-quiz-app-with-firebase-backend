
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? name;
  String? id;
  String? thumbnailUrl;
  int? quizCount;
  bool? featured;

  Category({
    required this.name,
    required this.id,
    this.thumbnailUrl,
    this.quizCount,
    this.featured
  });

  factory Category.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<dynamic, dynamic>;
    return Category(
        name: d['name'],
        id: d['id'],
        quizCount: d['quiz_count'],
        thumbnailUrl: d['image_url'],
        featured: d['featured'] ?? false
    );
  }
}
