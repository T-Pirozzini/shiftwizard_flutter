import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart'
    as material; // Import for colors and text styles
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shift_wizard_flutter/components/tile.dart';

class CollectedCardDisplay extends PositionComponent {
  late List<Tile> displayedCards = [];
  // The card to display
  Tile? displayedCard;
  int currentPlayer = 1; // Start with player 1

  // Update this method when the current player changes
  void setCurrentPlayer(int player) {
    currentPlayer = player;
  }

  // Call this method to update the displayed cards
  void updateCards(List<Tile> cards) {
    displayedCards = cards;
    print('Updated cards: $cards');
    // Update the rendering or layout of the cards
  }

  // Define some constants for the display
  final double borderRadius = 8.0;
  final material.Color boxColor = material.Colors.lightGreen;
  final double padding = 10.0; // Space inside the box
  final double boxHeight = 50.0; // Adjust as needed

  // Method to set the card
  void setCard(Tile card) {
    displayedCard = card;
    // Adjust position based on your game layout
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);    

    // Render the box
    final boxPaint = Paint()
      ..color = boxColor
      ..style = PaintingStyle.fill;
    final boxRect = Rect.fromLTWH(
      0,
      0,
      size.x,
      boxHeight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, Radius.circular(borderRadius)),
      boxPaint,
    );

    // Display which player's turn it is
    final textSpan = TextSpan(
      text: 'Player $currentPlayer\'s turn',
      style: TextStyle(color: Colors.white, fontSize: 24),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.x);
    textPainter.paint(canvas, Offset(10, 10)); // Adjust position as needed
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Additional update logic if needed
  }

  // Rest of the component class...
}
