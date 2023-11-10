import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/settings_bloc.dart';

import '../configs/app_config.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Image.asset(Config.logo, width: 140,),
          Text('App version: ${context.read<SettingsBloc>().appVersion}')
        ],
      ),
    );
  }
}