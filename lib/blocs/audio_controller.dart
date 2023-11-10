import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/services/sp_service.dart';
import 'package:soundpool/soundpool.dart';

import '../configs/app_config.dart';

class SoundControllerBloc extends ChangeNotifier{

  SoundControllerBloc(){
    checkSoundSettings();
  }


  bool _audioEnabled = true;
  bool get audioEnabled => _audioEnabled;

  bool _vibrationEnabled = true;
  bool get vibrationEnabled => _vibrationEnabled;

  late int _clickSoundId;
  int get clickSoundId => _clickSoundId;

  late int _optionSoundId;
  int get optionSoundId => _optionSoundId;

  late int _congratsSoundId;
  int get congratsSoundId => _congratsSoundId;

  final Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);


  initSounds ()async{
    _clickSoundId = await rootBundle.load(Config.clickSound).then((ByteData soundData) => pool.load(soundData));
    _optionSoundId = await rootBundle.load(Config.optionsSound).then((ByteData soundData) => pool.load(soundData));
    _congratsSoundId = await rootBundle.load(Config.congratsSound).then((ByteData soundData) => pool.load(soundData));
    notifyListeners();
  }

  playSound(int newSoundId){
    pool.play(newSoundId);
  }

  checkSoundSettings () async{
    await SPService().getSoundSettings().then((value){
      _audioEnabled = value;
    });
    await SPService().getVibrationSettings().then((value){
      _vibrationEnabled = value;
    });
    notifyListeners();
  }

  controlSoundSettings (bool newValue){
    debugPrint(newValue.toString());
    SPService().saveSoundSettings(newValue);
    _audioEnabled = newValue;
    notifyListeners();
  }

  controlVibrationSettings (bool newValue){
    debugPrint(newValue.toString());
    SPService().saveVibrationSettings(newValue);
    _vibrationEnabled = newValue;
    notifyListeners();
  }



  
}