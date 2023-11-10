import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/quiz.dart';
import '../models/category.dart';
import '../models/sp_category.dart';
import '../models/user.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    List<Category> data = [];
    await firestore.collection('categories').orderBy('quiz_count', descending: true).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Category.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Category>> getHomeCategories() async {
    List<Category> data = [];
    await firestore.collection('categories').orderBy('quiz_count', descending: true).limit(3).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Category.fromFirestore(e)).toList();
    });
    return data;
  }


  Future<List<Quiz>> getCategoryBasedQuizes(String selectedParentId) async {
    List<Quiz> data = [];
    await firestore.collection('quizes').where('parent_id', isEqualTo: selectedParentId).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Quiz.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Quiz>> getCategoryBasedQuizesByLimit(String selectedParentId, int limit) async {
    List<Quiz> data = [];
    await firestore.collection('quizes').where('parent_id', isEqualTo: selectedParentId).limit(limit).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Quiz.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Quiz>> getQuizes() async {
    List<Quiz> data = [];
    await firestore.collection('quizes').get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Quiz.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Category>> getFeaturedCategories() async {
    List<Category> data = [];
    await firestore
        .collection('categories')
        .where('featured', isEqualTo: true)
        .limit(10)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Category.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Question>> getQuestions(String quizId) async {
    List<Question> data = [];
    await firestore.collection('questions').where('quiz_id', isEqualTo: quizId).orderBy('created_at', descending: false).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Question.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Question>> getQuestionsforBookmark(List ids) async {
    List<Question> data = [];
    await firestore.collection('questions').where('id', whereIn: ids).orderBy('created_at', descending: false).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Question.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Question>> getQuestionForSelfChallengeMode(String quizId, int questionAmount) async {
    List<Question> data = [];
    await firestore.collection('questions').where('quiz_id', isEqualTo: quizId).limit(questionAmount).get().then((QuerySnapshot? snapshot){
      data = snapshot!.docs.map((e) => Question.fromFirestore(e)).toList();
    });
    return data;
  }

  Future saveUserData(String id, String username, String email, String? avatarString, int initialReward) async {
    return await firestore.collection('users').doc(id).set({
      'id': id,
      'email': email,
      'name': username,
      'avatar_string': avatarString,
      'points': initialReward,
      'disabled': false,
      'created_at': DateTime.now(),
    });
  }

  Future<UserModel> getUserData() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot snap = await firestore.collection('users').doc(userId).get();
    UserModel user = UserModel.fromFirestore(snap);
    return user;
  }

  Future updateUserDataAfterAvatarSeclection(String userId, String avatarString) async {
    return await firestore.collection('users').doc(userId).update({
      'avatar_string': avatarString,
      'updated_at': DateTime.now(),
    });
  }

  Future updateUserProfileOnEditScreen(String id, String name, String? avatarString, String? imageUrl) async {
    return await firestore.collection('users').doc(id).update({
      'name': name,
      'avatar_string': avatarString,
      'image_url': imageUrl,
      'updated_at': DateTime.now(),
    });
  }

  Future<bool> checkUserExists(String userId) async {
    DocumentSnapshot snap = await firestore.collection('users').doc(userId).get();
    if (snap.exists) {
      debugPrint('User Exists');
      return true;
    } else {
      debugPrint('new user');
      return false;
    }
  }

  Future<int> getTotalUsersCount() async {
    const String fieldName = 'count';
    final DocumentReference ref =
        firestore.collection('item_count').doc('users_count');
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true) {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    } else {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseUserCount() async {
    await getTotalUsersCount().then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc('users_count')
          .update({'count': documentCount + 1});
    });
  }

  Future decreaseUserCount() async {
    await getTotalUsersCount().then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc('users_count')
          .update({'count': documentCount - 1});
    });
  }

  Future deleteUserDatafromDatabase(String userId) async {
    await firestore.collection('users').doc(userId).delete();
  }

  Future<int> getNewUserReward () async{
    int reward = 0;
    DocumentSnapshot snap = await firestore.collection('settings').doc('points').get();
    if(snap.exists){
      reward = snap.get('new_user_reward') ?? 0;
    }else{
      reward = 0;
    }
    return reward;
  }

  Future<int> updateUserPointsByTransection (String userId, bool increment, int amount)async{
    final docRef = firestore.collection("users").doc(userId);
    int newPoints = 0;
    await firestore.runTransaction((transaction) {
      return transaction.get(docRef).then((snapshot) {
        final UserModel userModel = UserModel.fromFirestore(snapshot);
        final int getPoints = userModel.points ?? 0;
        if(increment){
          newPoints = getPoints + amount;
        }else{
          newPoints = getPoints - amount;
        }
        transaction.update(docRef, {"points": newPoints});
      });
    });
    debugPrint('newPoints: $newPoints');
    return newPoints;
    
  }

  Future updateUserPoints (String userId, int newPoints)async{
    final docRef = firestore.collection("users").doc(userId);
    return await docRef.update({
      'points': newPoints
    });
    
  }


  Future updateUserStatToDatabase (String userId, int quizPlayed, int questionAnswered, int correctAns, int inCorrectAns) async{
    final docRef = firestore.collection("users").doc(userId);
    return await docRef.set({
      'total_quiz_played': quizPlayed,
      'question_ans_count': questionAnswered,
      'correct_ans_count': correctAns,
      'incorrect_ans_count': inCorrectAns
    }, SetOptions(merge: true));
  }


  Future<List<UserModel>> getTopUsersData(int userAmout) async {
    List<UserModel> data = [];
    await firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(userAmout)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => UserModel.fromFirestore(e)).toList();
    });
    return data;
  }

  Future updateUserPointHistory (String userId, String newString)async{
    const String fieldName = 'points_history';
    final docRef = firestore.collection("users").doc(userId);
    await docRef.get().then((snapshot)async{
      bool exists = snapshot.data()!.containsKey(fieldName);
      List historyList = [];
      if(exists){
        historyList = snapshot.get(fieldName);
        historyList.add(newString); 
      }else{
        historyList.add(newString);
      }
      await docRef.update({
        'points_history': FieldValue.arrayUnion(historyList)
      });
      
    }); 
  }

  Future<SpecialCategory> getSpecialCategories () async{
    SpecialCategory specialCategory;
    final DocumentReference ref = firestore.collection('settings').doc('special_categories');
    DocumentSnapshot snapshot = await ref.get();
    if(snapshot.exists){
      specialCategory = SpecialCategory.fromFirestore(snapshot);
    }else{
      specialCategory = SpecialCategory(enabled: false, id1: null, id2: null);
    }
    return specialCategory;
  }

  Future<Category> getCategory(String docId) async {
    final DocumentSnapshot snap = await firestore.collection('categories').doc(docId).get();
    Category category = Category.fromFirestore(snap);
    return category;
  }

  Future addToBookmark (String questionId) async{
    const String fieldName = 'bookmarked_questions';
    UserModel userData = await getUserData();
    List itemList = userData.bookmarkedQuestions ?? [];
    if(!itemList.contains(questionId)){
      itemList.add(questionId);
      await firestore.collection('users').doc(userData.uid).update({
        fieldName : FieldValue.arrayUnion(itemList)
      });
    }else{
      debugPrint('Already available');
    }
  }

  Future removeFromBookmark (questionId) async{
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    const String fieldName = 'bookmarked_questions';
    await firestore.collection('users').doc(userId).update({
        fieldName : FieldValue.arrayRemove([questionId])
    }).catchError((e)=> debugPrint('error on deleting bookmarks'));
  }

  Future<List> getBookmakedIds () async{
    UserModel userData = await getUserData();
    List itemList = userData.bookmarkedQuestions ?? [];
    return itemList;
    
  }

  Future<List<Question>> getBookmakedQuestions () async{
    List<Question> qList = [];
    List ids = await getBookmakedIds();
    if(ids.isNotEmpty){
      qList = await getQuestionsforBookmark(ids);
    }
    return qList;  
  }

  Future updateCompletedQuizzes (String quizId, UserModel user) async{
    const String fieldName = 'completed_quizzes';
    List itemList = user.completedQuizzes ?? [];
    if(!itemList.contains(quizId)){
      itemList.add(quizId);
      await firestore.collection('users').doc(user.uid).update({
        fieldName : FieldValue.arrayUnion(itemList)
      });
    }else{
      debugPrint('Already available');
    }
  }




}
