import 'package:flutter/material.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/sp_service.dart';
import 'package:quiz_app/utils/notification_permission_dialog.dart';

class NotificationBloc extends ChangeNotifier {

  bool _subscribed = false;
  bool get subscribed => _subscribed;


  Future checkPermission ()async{
    await NotificationService().checkingPermisson().then((bool? accepted)async{
      if(accepted != null && accepted){
        checkSubscription();
      }else{
        await SPService().setNotificationSubscription(false);
        _subscribed = false;
        notifyListeners();
      }
    });
  }

  Future checkSubscription ()async{
    await SPService().getNotificationSubscription().then((bool value)async{
      if(value){
        await NotificationService().subscribe();
        _subscribed = true;
      }else{
        await NotificationService().unsubscribe();
        _subscribed = false;
      }
    });
    notifyListeners();
  }

  handleSubscription (context, bool newValue) async{
    if(newValue){
      await NotificationService().checkingPermisson().then((bool? accepted)async{
        if(accepted != null && accepted){
          await NotificationService().subscribe();
          await SPService().setNotificationSubscription(newValue);
          _subscribed = true;
          notifyListeners();
        }else{
          openNotificationPermissionDialog(context);
        }
      });
    }else{
      await NotificationService().unsubscribe();
      await SPService().setNotificationSubscription(newValue);
      _subscribed = newValue;
      notifyListeners();
    }
  }

  
}