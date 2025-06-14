import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../go_up_game.dart';
import 'platform.dart';

class Alien extends SpriteComponent with HasGameRef<GoUpGame> {
  Vector2 velocity = Vector2.zero();
  final double gravity = 500;
  final double jumpSpeed = -400;
  double previousY = 0;
  late StreamSubscription _gyroSub;
  double horizontalSpeed = 0;
  int lastPlatformIndex = 0;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await gameRef.images.load('alien.png'));
    size = Vector2(40, 40);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 180);
    previousY = position.y;
    add(RectangleHitbox(collisionType: CollisionType.active));

    _setupGyro();
  }

  void _setupGyro() {
    try {
      _gyroSub = accelerometerEvents.listen((event) {
        horizontalSpeed = event.x * -50;
      });
    } catch (e) {
      print("Gyro setup error: $e");
      horizontalSpeed = 0;
    }
  }

  void restartGyro() {
    try {
      _gyroSub.cancel();
    } catch (e) {
      print("Error canceling gyro: $e");
    }
    _setupGyro();
  }

  @override
  void update(double dt) {
    previousY = position.y;
    velocity.y += gravity * dt;

    position.x += horizontalSpeed * dt;

    if (position.x < -size.x / 2) {
      position.x = gameRef.size.x + size.x / 2;
    } else if (position.x > gameRef.size.x + size.x / 2) {
      position.x = -size.x / 2;
    }

    position.y += velocity.y * dt;
    _checkPlatformCollisions();
    super.update(dt);
  }

  void _checkPlatformCollisions() {
    for (final platform in gameRef.platforms) {
      if (velocity.y > 0) {
        double platformTop = platform.position.y - platform.size.y / 2;
        bool crossed = previousY + size.y / 2 <= platformTop &&
            position.y + size.y / 2 >= platformTop;
        bool overlap = (position.x + size.x / 2 >
                platform.position.x - platform.size.x / 2) &&
            (position.x - size.x / 2 <
                platform.position.x + platform.size.x / 2);
        if (crossed && overlap) {
          if (platform.index > lastPlatformIndex) {
            lastPlatformIndex = platform.index;
            gameRef.addScore(platform.index);
          }
          position.y = platformTop - size.y / 2;
          velocity.y = jumpSpeed;
          break;
        }
      }
    }
  }

  @override
  void onRemove() {
    try {
      _gyroSub.cancel();
    } catch (e) {
      print("Error removing gyro: $e");
    }
    super.onRemove();
  }
}
