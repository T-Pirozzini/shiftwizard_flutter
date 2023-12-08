import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/components/tile.dart';

class StoredElementsDisplay extends PositionComponent with TapCallbacks {
  final List<Tile> collectedTiles;
  final TextPaint textPaint;
  final Vector2 tileSize;
  final String player;

  bool beenPressed = false;

  StoredElementsDisplay(this.collectedTiles, this.player,
      {required this.tileSize})
      : textPaint = TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        super();

  @override
  void update(double dt) {
    updateDisplay();
    super.update(dt);
  }

  void updateDisplay() {
    removeAll(children); // Clear existing tiles

    double y = 50; // Start position for the first tile
    double x = 0;
    for (var tile in collectedTiles) {
      tile.size = Vector2(32, 32);
      // tile.disableTap(); // Disable tap handling
      add(tile..position = Vector2(x, y));
      x += tile.size.y + 5; // Increment Y position for each tile
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(canvas, '$player:', Vector2(0, 0));
    textPaint.render(canvas, 'Stored Elements', Vector2(0, 20));
  }
}
