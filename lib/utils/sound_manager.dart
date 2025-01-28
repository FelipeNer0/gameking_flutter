import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final AudioPlayer _audioPlayer = AudioPlayer();

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
}
