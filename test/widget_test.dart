import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/go_up_game.dart';

void main() {
  testWidgets('Game loads without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GameWidget(game: GoUpGame()),
      ),
    );
    expect(find.byType(GameWidget), findsOneWidget);
  });
}
