import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/text.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'dart:async';
import '../go_up_game.dart';

class ReloadButton extends PositionComponent
    with HasGameRef<GoUpGame>, TapCallbacks {
  late RectangleComponent buttonRect;
  late TextComponent buttonText;

  @override
  Future<void> onLoad() async {
    size = Vector2(80, 40);
    position = Vector2(10, 50);

    buttonRect = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF4CAF50),
    );
    add(buttonRect);

    buttonText = TextComponent(
      text: 'RELOAD',
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(10, 10),
    );
    add(buttonText);

    add(RectangleHitbox());
  }

  @override
  bool onTapDown(TapDownEvent event) {
    unawaited(gameRef.reset());
    return true;
  }
}
