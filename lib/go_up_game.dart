import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'components/alien.dart';
import 'components/platform.dart';
import 'components/reload_button.dart';

class GoUpGame extends FlameGame with HasCollisionDetection {
  late Alien alien;
  int score = 0;
  bool isGameOver = false;
  List<Platform> platforms = [];
  Set<int> platformsPassed = {};

  late PositionComponent gameWorld;
  List<SpriteComponent> backgroundTiles = [];
  double backgroundHeight = 0;
  late ReloadButton reloadButton;

  double cameraOffsetY = 0;

  @override
  Future<void> onLoad() async {
    debugMode = false;

    gameWorld = PositionComponent();
    add(gameWorld);

    await _setupBackgrounds();
    _generatePlatforms();

    // Ini cara benar: tunggu setiap platform benar2 selesai di add & load.
    for (final plat in platforms) {
      await gameWorld.add(plat);  // await!
    }

    alien = Alien();
    await gameWorld.add(alien); // Pastikan alien juga di-load penuh

    _setCameraToShowGround();
    overlays.add('GameOverlay');
  }

  void _setCameraToShowGround() {
    cameraOffsetY = -(size.y - 80) + size.y * 0.8;
    gameWorld.position.y = cameraOffsetY;
  }

  Future<void> _setupBackgrounds() async {
    final bg = await images.load('background_awan.png');
    backgroundHeight = size.y;

    for (int i = -20; i <= 20; i++) {
      final bgTile = SpriteComponent(
        sprite: Sprite(bg),
        size: Vector2(size.x, backgroundHeight),
        position: Vector2(0, i * backgroundHeight),
      );
      backgroundTiles.add(bgTile);
      gameWorld.add(bgTile);
    }
  }

  void _generatePlatforms() {
    final random = Random();
    double currentY = size.y - 50;
    platforms.clear();

    platforms
        .add(Platform(Vector2(size.x / 2, currentY), isGround: true, index: 0));

    for (int i = 1; i <= 300; i++) {
      double gapY = random.nextDouble() * 60 + 60;
      currentY -= gapY;
      double x = random.nextDouble() * (size.x - 100) + 50;
      platforms.add(Platform(Vector2(x, currentY), isGround: false, index: i));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    double targetCameraY = -(alien.position.y) + size.y * 0.3;

    if (targetCameraY > cameraOffsetY) {
      cameraOffsetY = targetCameraY;
      gameWorld.position.y = cameraOffsetY;
    }

    _generateMorePlatforms();

    if (alien.position.y > size.y + 200) {
      isGameOver = true;
      overlays.add('GameOverMenu');
    }
  }

  Future<void> _generateMorePlatforms() async {
    if (platforms.isNotEmpty) {
      double highestY =
          platforms.map((p) => p.position.y).reduce((a, b) => a < b ? a : b);

      if (alien.position.y < highestY + 500) {
        final random = Random();
        double currentY = highestY;

        for (int i = 0; i < 50; i++) {
          double gapY = random.nextDouble() * 60 + 60;
          currentY -= gapY;
          double x = random.nextDouble() * (size.x - 100) + 50;
          int newIndex = platforms.length;
          Platform newPlatform =
              Platform(Vector2(x, currentY), isGround: false, index: newIndex);
          platforms.add(newPlatform);
          gameWorld.add(newPlatform);
        }

        for (int i = 0; i < 10; i++) {
          final bgTile = SpriteComponent(
            sprite: Sprite(await images.load('background_awan.png')),
            size: Vector2(size.x, backgroundHeight),
            position: Vector2(0, currentY - (i * backgroundHeight)),
          );
          backgroundTiles.add(bgTile);
          gameWorld.add(bgTile);
        }
      }
    }
  }

  void addScore(int platformIndex) {
    if (!platformsPassed.contains(platformIndex) && platformIndex != 0) {
      score++;
      platformsPassed.add(platformIndex);
    }
  }

  Future<void> reset() async {
    score = 0;
    isGameOver = false;
    platformsPassed.clear();

    try {
      alien.restartGyro();
    } catch (e) {
      print("Error restarting gyro: $e");
    }

    gameWorld.removeAll(gameWorld.children);
    platforms.clear();
    backgroundTiles.clear();

    gameWorld.position = Vector2.zero();

    await _setupBackgrounds();
    _generatePlatforms();

    for (final plat in platforms) {
      gameWorld.add(plat);
    }

    alien.position = Vector2(size.x / 2, size.y - 180);
    alien.velocity = Vector2.zero();
    alien.previousY = alien.position.y;
    alien.lastPlatformIndex = 0;
    alien.horizontalSpeed = 0;

    alien.restartGyro();

    gameWorld.add(alien);

    _setCameraToShowGround();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final textPaint = TextPaint(
      style: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
    textPaint.render(canvas, "Score: $score", Vector2(10, 10));
  }
}
