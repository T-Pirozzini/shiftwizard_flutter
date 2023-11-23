import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:shift_wizard_flutter/components/win_overlay.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  ShiftWizardGame game = ShiftWizardGame();
  runApp(
    SafeArea(
        child: GameWidget(
      game: kDebugMode ? ShiftWizardGame() : game,
      overlayBuilderMap: {
        'P1WinningOverlay': (context, game) => WinningOverlay(1),
        'P2WinningOverlay': (context, game) => WinningOverlay(2),
      },
    )),
  );
}
