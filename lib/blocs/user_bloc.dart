import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/services/sp_service.dart';

class UserBloc extends ChangeNotifier {
  
  UserModel? _userData;
  UserModel? get userData => _userData;

  int _userRank = 0;
  int get userRank => _userRank;

  UserBloc(){
    getUserRank();
  }


  

  Future getUserData() async {
    await FirebaseService().getUserData().then((UserModel? userModel) async {
      if (userModel != null) {
        _userData = userModel;
        debugPrint('userdata got from database');
      } 
      notifyListeners();
    });
  }

  setUserRank (int newRank)async{
    await SPService().saveRankToLocal(newRank);
    _userRank = newRank;
    notifyListeners();
  }

  updateUserPointsToBloc (int newPoints){
    _userData!.points = newPoints;
    notifyListeners();
  }


  getUserRank ()async{
    await SPService().getUserRank().then((int rank){
      _userRank = rank;
      notifyListeners();
    });
  }

  Future clearUserData ()async{
    await SPService().clearLocalData();
    _userRank = 0;
    _userData = null;
  }


}
