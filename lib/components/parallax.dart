import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';

class MyParallaxComponent extends ParallaxComponent<ShiftWizardGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('parallax/bg.png'),
        ParallaxImageData('parallax/8.png'),
        ParallaxImageData('parallax/7.png'),
        ParallaxImageData('parallax/6.png'),
        ParallaxImageData('parallax/5.png'),
        ParallaxImageData('parallax/4.png'),
        ParallaxImageData('parallax/3.png'),
        ParallaxImageData('parallax/2.png'),
        ParallaxImageData('parallax/1.png'),
        ParallaxImageData('parallax/fg.png'),
      ],
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
      filterQuality: FilterQuality.none,
      fill: LayerFill.height,
    );
  }
}
