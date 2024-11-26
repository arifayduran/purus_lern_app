import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart';

Future<void> playSplashSound() async {
  AudioPlayer audioPlayer = AudioPlayer();

  try {
    await audioPlayer.setSource(AssetSource("sounds/splash_sound.wav"));
    await audioPlayer.resume();
    debugPrint("Sound played successfully!");
    logAny("splash_sound", "Sound played successfully!");

    await Future.delayed(Duration(seconds: 10));
    audioPlayer.dispose();
    debugPrint("Audio player disposed after 10 seconds.");
    debugPrint("-------------");
  } catch (e) {
    debugPrint("-------------");
    debugPrint("Error playing sound: $e");
    logAny("splash_sound", "Error playing sound: $e");
    debugPrint("-------------");
  }
}
