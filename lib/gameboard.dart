import 'dart:ui';
import 'package:flame/components.dart';
import 'tile.dart'; // Make sure this points to your Tile class file

class GameBoard extends PositionComponent {
  final int rows;
  final int columns;
  late List<Tile> tiles;
  late Vector2 tileSize; // Define the size for each tile

  GameBoard(this.rows, this.columns, this.tileSize) {
    tiles = generateTiles();
  }

  List<Tile> generateDeck() {
    List<Tile> deck = [];
    // Add 20 tiles of Red, Yellow, and Green each, and 10 Blue tiles
    deck.addAll(List.generate(20, (_) => Tile(tileType: TileType.Red)));
    deck.addAll(List.generate(20, (_) => Tile(tileType: TileType.Yellow)));
    deck.addAll(List.generate(20, (_) => Tile(tileType: TileType.Green)));
    deck.addAll(List.generate(10, (_) => Tile(tileType: TileType.Blue)));

    deck.shuffle(); // Shuffle the deck
    return deck;
  }

  List<Tile> generateTiles() {
    List<Tile> generatedTiles = [];
    List<Tile> deck = generateDeck();
    for (int i = 0; i < rows * columns; i++) {
      // Calculate the position for each tile
      Vector2 tilePosition = Vector2(
        (i % columns) * tileSize.x, // x position
        (i ~/ columns) * tileSize.y, // y position
      );

      // Assuming the Tile constructor takes a position
      Tile tile = deck[i];
      tile.position = tilePosition;
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
    // Optional: Custom rendering of the board itself, if needed
  }

  // Optional: Additional methods for handling game logic
}
