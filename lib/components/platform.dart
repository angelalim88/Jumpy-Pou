import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Platform extends SpriteComponent with HasGameRef {
  final bool isGround;
  final int index;

  Platform(Vector2 pos, {required this.isGround, required this.index}) {
    position = pos;
  }

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
      await gameRef.images.load(isGround ? 'batu_besar.png' : 'batu_kecil.png'),
    );
    size = isGround ? Vector2(200, 60) : Vector2(80, 20);
    anchor = Anchor.center;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
