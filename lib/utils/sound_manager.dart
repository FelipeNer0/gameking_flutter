import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioPlayer _backgroundPlayer = AudioPlayer();

  // Método para tocar som
  Future<void> playSound(String fileName) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      print('Erro ao tocar o som: $e');
    }
  }

  // Método para parar o som, se necessário
  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Erro ao parar o som: $e');
    }
  }

  // Ajustar o volume (0.0 a 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      print('Erro ao ajustar o volume: $e');
    }
  }

   // Ajustar o volume da música de fundo
  Future<void> setBackgroundVolume(double volume) async {
    try {
      await _backgroundPlayer.setVolume(volume);
    } catch (e) {
      print('Erro ao ajustar o volume da música de fundo: $e');
    }
  }
  
  Future<void> playBackgroundMusic(String fileName) async {
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Loop infinito
    await _backgroundPlayer.play(AssetSource('sounds/$fileName'));
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await _backgroundPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await _backgroundPlayer.resume();
  }
}

