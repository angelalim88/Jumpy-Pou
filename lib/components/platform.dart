import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Platform extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final bool isGround;
  final int index;
  final Vector2 initialPos;

  Platform(this.initialPos, {required this.isGround, required this.index});

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
      await gameRef.images.load(
        isGround ? 'terrain_big.png' : 'batu_kecil.png',
      ),
    );

    if (isGround) {
      size = Vector2(gameRef.size.x, 100);
      anchor = Anchor.center;
      position = Vector2(gameRef.size.x / 2, (gameRef.size.y - size.y / 2) + 60);
    } else {
      size = Vector2(80, 50);
      anchor = Anchor.center;
      position = initialPos; // platform kecil pakai posisi random
    }

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}