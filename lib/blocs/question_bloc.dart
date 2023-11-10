import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

class QuestionBloc extends ChangeNotifier{


  PageController pageController = PageController(initialPage: 0);

  Question? _question;
  Question? get question => _question;

  updateQuestion (Question newQuestion){
    _question = newQuestion;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  controlPage (int newPage){
    _pageIndex = newPage;
    pageController.animateToPage(newPage, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

  



  
}