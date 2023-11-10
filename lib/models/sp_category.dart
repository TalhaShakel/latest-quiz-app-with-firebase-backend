
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialCategory {
  String? id1;
  String? id2;
  bool? enabled;

  SpecialCategory({
    this.id1,
    this.id2,
    required this.enabled,
  });

  factory SpecialCategory.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<dynamic, dynamic>;
    return SpecialCategory(
        enabled: d['enabled'] ?? false,
        id1: d['cat_id1'],
        id2: d['cat_id2']
    );
  }
}