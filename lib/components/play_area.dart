import 'dart:ui';
import 'package:flame/components.dart';
import 'package:shift_wizard_flutter/components/tile.dart';

class CollectedCardDisplay extends PositionComponent {
  // The card to display
  Tile? displayedCard;

  // Method to set the card
  void setCard(Tile card) {
    displayedCard = card;
    // Position the card above the gameboard
    // You'll need to set the position based on your game layout
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    displayedCard?.render(canvas);
  }

  // Rest of the component class...
}
