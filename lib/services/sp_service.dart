import 'package:shared_preferences/shared_preferences.dart';

class SPService {

  Future<int> getUserRank () async{
    final prefs = await SharedPreferences.getInstance();
    int rank = prefs.getInt('rank') ?? 0;
    return rank;
  }

  Future saveRankToLocal (int newRank) async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('rank', newRank);
  }

  Future clearLocalData () async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future setNotificationSubscription (bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('n_subscribe', value);
  }

  Future<bool> getNotificationSubscription () async{
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('n_subscribe') ?? true;
    return value;
  }

  Future<bool> getSoundSettings () async{
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('sound') ?? true;
    return value;
  }

  Future saveSoundSettings (bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', value);
  }

  Future<bool> getVibrationSettings () async{
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('vibrate') ?? true;
    return value;
  }
  Future saveVibrationSettings (bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrate', value);
  }
}
