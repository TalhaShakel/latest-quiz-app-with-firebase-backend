import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_app/models/sp_category.dart';
import 'package:quiz_app/services/firebase_service.dart';

class SettingsBloc extends ChangeNotifier{

  int _correctAnsReward = 0;
  int get correctAnsReward => _correctAnsReward;

  int _incorrectAnsPenalty = 0;
  int get incorrectAnsPenalty => _incorrectAnsPenalty;

  int _requiredPointsPlaySelfChallengeMode = 0;
  int get requiredPointsPlaySelfChallengeMode => _requiredPointsPlaySelfChallengeMode;

  int _initalRewardToNewUser = 0;
  int get initialRewardToNewUser => _initalRewardToNewUser;

  bool _selfChallengeModeEnabled = true;
  bool get selfChallengeModeEnabled => _selfChallengeModeEnabled;

  late SpecialCategory _specialCategory;
  SpecialCategory get specialCategory => _specialCategory;

  Future getSpecialCategories ()async{
    _specialCategory = await FirebaseService().getSpecialCategories();
    debugPrint('sepcial categories enabled: ${_specialCategory.enabled.toString()}');
    notifyListeners();
  }

  Future getSettingsData ()async{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snap = await firestore.collection('settings').doc('points').get();
    if(snap.exists){
      _correctAnsReward = snap.get('correct_ans_reward') ?? 0;
      _incorrectAnsPenalty = snap.get('incorrect_ans_penalty') ?? 0;
      _requiredPointsPlaySelfChallengeMode = snap.get('points_req_self_chl_mode') ?? 0;
      _initalRewardToNewUser = snap.get('new_user_reward') ?? 0;
      _selfChallengeModeEnabled = snap.get('self_challenge_mode') ?? true;

    }else{
      _correctAnsReward = 0;
      _incorrectAnsPenalty = 0;
      _requiredPointsPlaySelfChallengeMode = 0;
      _initalRewardToNewUser = 0;
      _selfChallengeModeEnabled = true;
    }

    notifyListeners();
  }


  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  void initPackageInfo () async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
    
  }


}