import 'package:flutter/material.dart';

class TempBloc extends ChangeNotifier{

  // ignore: prefer_final_fields
  List<int> _selectedIndexList = [];
  List<int> get selectedIndexList => _selectedIndexList;

  int _points = 0;
  int get points => _points;

  int _totalQuestions = 0;
  int get totalQuestions => _totalQuestions;

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;

  double _percentage = 0.0;
  double get percentage => _percentage;

  int _correctAnsCount = 0;
  int get currentAnsCount => _correctAnsCount;

  int _incorrectAnsCount = 0;
  int get incorrectAnsCount => _incorrectAnsCount;

  int _pointsEarned = 0;
  int get pointsEarned => _pointsEarned;

  int _pointsLoss = 0;
  int get pointLoss => _pointsLoss;


  setParcentage (int qIndex, int totalQ){
    _currentQuestionIndex = qIndex + 1;
    _totalQuestions = totalQ;
    _percentage = _currentQuestionIndex/_totalQuestions;
    notifyListeners();
  }

  updateTempData (int selctedIndex, int newPoints, int newPointsEarned, bool isCorrect, int newPointLoss){
    _selectedIndexList.add(selctedIndex);
    _points = newPoints;
    _correctAnsCount = isCorrect ? _correctAnsCount + 1 : _correctAnsCount;
    _incorrectAnsCount = !isCorrect ? _incorrectAnsCount + 1 : _incorrectAnsCount;
    _pointsEarned = _pointsEarned + newPointsEarned;
    _pointsLoss = _pointsLoss + newPointLoss;
    notifyListeners();
  }

  intializeTempData (int userPoints){
    _selectedIndexList.clear();
    _currentQuestionIndex = 0;
    _totalQuestions = 0;
    _percentage = 0.0;
    _points = userPoints;
    _correctAnsCount = 0;
    _incorrectAnsCount = 0;
    _pointsEarned = 0;
    _pointsLoss = 0;
    notifyListeners();
  }
  
}