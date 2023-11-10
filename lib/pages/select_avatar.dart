import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/pages/home.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/utils/snackbars.dart';
import 'package:quiz_app/widgets/loading_widget.dart';

import '../blocs/ads_bloc.dart';
import '../blocs/settings_bloc.dart';
import '../blocs/user_bloc.dart';

class SelectAvatar extends StatefulWidget {
  const SelectAvatar({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<SelectAvatar> createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  String? _selectedAssetString;
  bool? _updateStarted;

  _onSelection(int index, String assetString) {
    setState(() {
      _selectedAssetString = assetString;
    });
  }

  _updateUserProfile() async {
    if (_selectedAssetString != null) {
      setState(() => _updateStarted = true);
      await FirebaseService()
            .updateUserDataAfterAvatarSeclection(widget.userId, _selectedAssetString!)
            .then((_) async {
          await _getRequiredData();
          setState(() {
            _updateStarted = false;
          });
          Future.delayed(const Duration(milliseconds: 300))
              .then((value) => _afterUpdte());
        });
    }else{
      openSnackbar(context, 'Select your avatar');
    }
  }

  _afterUpdte() {
    NextScreen().nextScreenCloseOthers(
        context,
        const HomePage(
        ));
  }

  Future _getRequiredData() async {
    await context.read<UserBloc>().getUserData()
    .then((value) => context.read<SettingsBloc>().getSettingsData()
    .then((value) => context.read<SettingsBloc>().getSpecialCategories()
    .then((value) => context.read<AdsBloc>().checkAds())));

    debugPrint('Data getting done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('select-avatar', style: TextStyle(color: Colors.white),).tr(),
      ),
      bottomNavigationBar: _bottomWidget(context),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        scrollDirection: Axis.horizontal,
        itemCount: Config.userAvatars.length,
        separatorBuilder: ((context, index) => const SizedBox(
              width: 20,
            )),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              _avatarCard(index, Config.userAvatars[index]),
            ],
          );
        },
      ),
    );
  }

  Widget _bottomWidget(BuildContext context) {
    return InkWell(
      onTap: () => _updateUserProfile(),
      child: Container(
          alignment: Alignment.center,
          height: 60,
          color: Theme.of(context).primaryColor,
          child: _updateStarted != null && _updateStarted == true
              ? const LoadingIndicatorWidget(
                  color: Colors.white,
                )
              : Text(
                  'done',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ).tr()),
    );
  }

  InkWell _avatarCard(int listIndex, String assetString) {
    bool selected = assetString == _selectedAssetString ? true : false;
    return InkWell(
      onTap: () => _onSelection(listIndex, Config.userAvatars[listIndex]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? Colors.blueGrey : Colors.transparent),
                shape: BoxShape.circle,
                color: Colors.green[100],
                image: DecorationImage(image: AssetImage(assetString))),
          ),
          Visibility(
            visible: selected,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.done,
                size: 60,
                color: Colors.grey[800],
              ),
            ),
          )
        ],
      ),
    );
  }
}
