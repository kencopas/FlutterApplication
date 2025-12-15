import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  static final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop);

  static Future<void> playDiceRoll() async {
    await _player.play(AssetSource('sounds/dice-roll.mp3'));
  }

  static Future<void> playMoneySound() async {
    await _player.play(AssetSource('sounds/cha-ching.mp3'));
  }
}
