import 'package:flutter/material.dart';

class TabControllerBloc extends ChangeNotifier{

  final PageController pageController = PageController(initialPage: 0);
  int _currectIndex = 0;
  int get currentIndex => _currectIndex;

  controlTab (int newIndex){
    _currectIndex = newIndex;
    pageController.animateToPage(newIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    notifyListeners();
  }



}