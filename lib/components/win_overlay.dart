// Create a new Flame overlay widget
import 'package:flutter/material.dart';

class WinningOverlay extends StatelessWidget {
  final int winningPlayer;

  WinningOverlay(this.winningPlayer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Player $winningPlayer wins!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
