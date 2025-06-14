import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/alien.dart';
import 'components/platform.dart';

class GoUpGame extends FlameGame with HasCollisionDetection {
  late Alien alien;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    final bg = await images.load('background_awan.png');
    add(SpriteComponent(sprite: Sprite(bg), size: size));
    alien = Alien();
    add(alien);
    await addPlatforms();
  }

  Future<void> addPlatforms() async {
    add(Platform(Vector2(size.x / 2, size.y - 25), isGround: true));
    for (int i = 1; i < 10; i++) {
      add(Platform(Vector2(
          (i % 2 == 0) ? size.x * 0.3 : size.x * 0.7, size.y - (i * 80))));
    }
  }
}
