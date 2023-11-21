import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  ShiftWizardGame game = ShiftWizardGame();
  runApp(
    GameWidget(game: kDebugMode ? ShiftWizardGame() : game),
  );
}
