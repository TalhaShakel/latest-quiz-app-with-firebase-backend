import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/pages/splash.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/next_screen.dart';

import '../services/auth_service.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _isLoading = false;

  Future<void> _openDeleteDialog() {
    return Dialogs.materialDialog(
        context: context,
        title: 'account-delete-title'.tr(),
        msg: 'account-delete-subtitle'.tr(),
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        msgAlign: TextAlign.center,
        msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        actions: [
          IconsOutlineButton(
            text: 'cancel'.tr(),
            iconData: Icons.close,
            onPressed: () => Navigator.pop(context),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          IconsOutlineButton(
            text: 'account-delete-confirm'.tr(),
            color: Colors.red,
            iconData: Icons.delete_forever,
            iconColor: Colors.white,
            textStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            onPressed: () async {
              Navigator.pop(context);
              await _handleDeleteAccount();
            },
          ),
        ]);
  }

  _handleDeleteAccount() async {
    final UserBloc ub = context.read<UserBloc>();
    setState(() => _isLoading = true);
    await FirebaseService().deleteUserDatafromDatabase(ub.userData!.uid!)
    .then((value) async => await FirebaseService().decreaseUserCount()
    .then((value) async => await AuthService().deleteUserAuth()
    .then((value) async => await AuthService().userLogOut()
    .then((value) async => await context.read<UserBloc>().clearUserData().then((value){
      setState(() => _isLoading = false);
      Future.delayed(const Duration(seconds: 1)).then(
          (value) => NextScreen().nextScreenCloseOthers(context, const SplashPage()));
    })))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('security', style: TextStyle(color: Colors.white),).tr(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              LineIcons.trash,
                              size: 25,
                            ),
                            title: Text('delete-user', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16
                            ),).tr(),
                            trailing: const Icon(Icons.arrow_right),
                            onTap: () => _openDeleteDialog(),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          Align(
            child:
                _isLoading == true ? const CircularProgressIndicator() : Container(),
          )
        ],
      ),
    );
  }
}
