import 'package:shift_wizard_flutter/shiftwizard_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = ShiftWizardGame();
  runApp(
    GameWidget(game: game),
  );
}

