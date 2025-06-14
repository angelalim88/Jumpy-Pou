import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'go_up_game.dart';

void main() {
  runApp(MaterialApp(
    home: GameWidget(game: GoUpGame()),
  ));
}
