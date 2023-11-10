import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/audio_controller.dart';

class ControllSettings extends StatelessWidget {
  const ControllSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile.adaptive(
          activeColor: Theme.of(context).primaryColor,
          title: Text('sound', style: Theme.of(context).textTheme.titleLarge).tr(),
          value: context.watch<SoundControllerBloc>().audioEnabled,
          onChanged: (value)=> context.read<SoundControllerBloc>().controlSoundSettings(value),
        ),
        SwitchListTile.adaptive(
          activeColor: Theme.of(context).primaryColor,
          title: Text('vibration', style: Theme.of(context).textTheme.titleLarge).tr(),
          value: context.watch<SoundControllerBloc>().vibrationEnabled,
          onChanged: (value) => context.read<SoundControllerBloc>().controlVibrationSettings(value),
        )
      ],
    );
  }
}
