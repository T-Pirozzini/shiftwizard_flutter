import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';
import 'tile.dart'; // Make sure this points to your Tile class file

class GameBoard extends PositionComponent with HasGameRef<ShiftWizardGame> {
  final int rows;
  final int columns;
  late List<Tile> tiles;
  late Vector2 tileSize; // Define the size for each tile
  final double spacing = 15.0; // Define the spacing between tiles
  final Function(Tile) onTileTapped; // Add this line
  late Map<Tile, Point<int>> tilePositions;

  GameBoard(this.rows, this.columns, this.tileSize, this.onTileTapped)
      : super() {
    tiles = generateTiles(onTileTapped);
  }

  List<Tile> generateDeck(Function(Tile) onTileTapped) {
    List<Tile> deck = [];
    // Add 20 tiles of Red, Yellow, and Green each, and 10 Blue tiles
    deck.addAll(List.generate(
        20, (_) => Tile(tileType: TileType.red, onTileTapped: onTileTapped)));
    deck.addAll(List.generate(20,
        (_) => Tile(tileType: TileType.yellow, onTileTapped: onTileTapped)));
    deck.addAll(List.generate(
        20, (_) => Tile(tileType: TileType.green, onTileTapped: onTileTapped)));
    deck.addAll(List.generate(
        10, (_) => Tile(tileType: TileType.blue, onTileTapped: onTileTapped)));

    deck.shuffle(); // Shuffle the deck
    return deck;
  }

  List<Tile> generateTiles(Function(Tile) onTileTapped) {
    tilePositions = {}; // Initialize the map
    List<Tile> generatedTiles = [];
    List<Tile> deck = generateDeck(onTileTapped);
    for (int i = 0; i < rows * columns; i++) {
      int row = i ~/ columns;
      int col = i % columns;
      Vector2 tilePosition =
          Vector2(col * (tileSize.x + spacing), row * (tileSize.y + spacing));

      // Assuming the Tile constructor takes a position
      Tile tile = deck[i];
      tile.position = tilePosition;
      tilePositions[tile] = Point(col, row); // Store the position in the map
      generatedTiles.add(tile);
    }
    return generatedTiles;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    tiles.forEach(add); // Add each tile to the component
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    drawHighlight(canvas, gameRef.lastCollectedPositionPlayer1, Colors.blue);
    drawHighlight(canvas, gameRef.lastCollectedPositionPlayer2, Colors.red);
  }

  void drawHighlight(Canvas canvas, Point<int>? position, Color color) {
    if (position != null) {
      final paint = Paint()..color = color.withOpacity(0.5);
      final rect = Rect.fromLTWH(position.x * (tileSize.x + spacing),
          position.y * (tileSize.y + spacing), tileSize.x, tileSize.y);
      canvas.drawRect(rect, paint);
    }
  }
}
