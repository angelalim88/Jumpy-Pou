import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../go_up_game.dart';

class Platform extends SpriteComponent
    with HasCollisionDetection, HasGameReference<GoUpGame>, CollisionCallbacks {
  final bool isGround;

  Platform(Vector2 pos, {this.isGround = false}) {
    position = pos;
  }

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
        await game.images.load(isGround ? 'batu_besar.png' : 'batu_kecil.png'));
    size = isGround ? Vector2(200, 60) : Vector2(80, 20);
    anchor = Anchor.center;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}
