import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../go_up_game.dart';
import 'platform.dart';

class Alien extends SpriteComponent
    with HasCollisionDetection, HasGameReference<GoUpGame> {
  Vector2 velocity = Vector2.zero();
  final double gravity = 500;
  final double jumpSpeed = -400;
  double previousY = 0;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double horizontalSpeed = 0;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await game.images.load('alien.png'));
    size = Vector2(40, 40);
    position = Vector2(game.size.x / 2, game.size.y - 120);
    previousY = position.y;
    add(RectangleHitbox());
    _setupGyroControl();
  }

  void _setupGyroControl() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      horizontalSpeed = event.x * -50;
    });
  }

  @override
  void update(double dt) {
    previousY = position.y;
    velocity.y += gravity * dt;
    position.x += horizontalSpeed * dt;

    if (position.x < -size.x / 2) {
      position.x = game.size.x + size.x / 2;
    } else if (position.x > game.size.x + size.x / 2) {
      position.x = -size.x / 2;
    }

    position.y += velocity.y * dt;
    _checkPlatformCollisions();
    super.update(dt);
  }

  void _checkPlatformCollisions() {
    final platforms = game.children.whereType<Platform>();

    for (final platform in platforms) {
      if (velocity.y > 0) {
        double platformTop = platform.position.y - platform.size.y / 2;
        bool crossedPlatform = previousY + size.y / 2 <= platformTop &&
            position.y + size.y / 2 >= platformTop;
        bool horizontalOverlap = (position.x + size.x / 2 >
                platform.position.x - platform.size.x / 2) &&
            (position.x - size.x / 2 <
                platform.position.x + platform.size.x / 2);

        if (crossedPlatform && horizontalOverlap) {
          print(
              "Manual collision with ${platform.isGround ? 'ground' : 'floating'} platform!");
          position.y = platformTop - size.y / 2;
          velocity.y = jumpSpeed;
          break;
        }
      }
    }
  }

  @override
  void onRemove() {
    _accelerometerSubscription.cancel();
    super.onRemove();
  }
}
