import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({Key? key, required this.audioUrl}) : super(key: key);

  final String audioUrl;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final player = AudioPlayer();

  _initAudioPlayer() async {
    await player.setLoopMode(LoopMode.all);
    await player.setUrl(widget.audioUrl);
  }

  _onPresssed() async {
    if (player.playing) {
      await player.pause();
      _controller.reverse();
    } else {
      player.play();
      _controller.forward();
    }
  }

  _onRestart ()async{
    if(player.playing){
      await player.seek(Duration.zero);
      _controller.reverse();
      player.play();
      _controller.forward();
    }else{
      await player.seek(Duration.zero);
      player.play();
      _controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
          radius: 25,
          child: InkWell(
            onTap: () => _onRestart(),
            child: const Icon(Icons.restart_alt, color: Colors.white, size: 30,)
          ),
        ),
        const SizedBox(width: 10,),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 40,
          child: InkWell(
            onTap: () => _onPresssed(),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _controller,
              size: 60.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
