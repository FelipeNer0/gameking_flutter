import 'package:flutter/material.dart';
import 'package:game_king/domain/game_stage.dart';
import 'package:game_king/game/game_route.dart';

import '../utils/sound_manager.dart';

final SoundManager _soundManager = SoundManager();
class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
               // Tocar a música de fundo (por exemplo, ao iniciar o jogo)
            await _soundManager.setBackgroundVolume(0.1);
            await _soundManager.playBackgroundMusic('background-music.mp3');
            GameRoute.open(context, GameStagesEnum.stage1);
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
