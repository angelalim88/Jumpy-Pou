import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:jumpy_pou/components/GameNavbar.dart';
import 'package:jumpy_pou/pages/IntroductionPage.dart';
import 'go_up_game.dart';

void main() {
  runApp(const GoUpApp());
}

class GoUpApp extends StatelessWidget {
  const GoUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameWidget<GoUpGame>.controlled(
          gameFactory: GoUpGame.new,
          overlayBuilderMap: {
            'GameOverlay': (_, game) => GameOverlay(game: game),
            'GameOverMenu': (BuildContext context, GoUpGame game) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'GAME OVER',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Score: ${game.score}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          game.reset();
                          game.overlays.remove('GameOverMenu');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text(
                          'RELOAD',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLoop(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/text.png',
                  width: 200,
                ),
                const SizedBox(height: 50),
                HomeButton(
                  text: 'Play',
                  onPressed: () => _startGame(context),
                ),
                const SizedBox(height: 20),
                HomeButton(
                  text: 'Introduction',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const IntroductionScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                HomeButton(
                  text: 'How To Play',
                  onPressed: () {
                    showHowToPlayDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showHowToPlayDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '1. Gunakan sensor gyroscope pada perangkat untuk menggerakan karakter.\n'
              '2. Gunakan batu yang mengapung sebagai pijakan\n'
              '3. Pergi setinggi mungkin untuk mendapatkan score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}


class HomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const HomeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}

class BackgroundLoop extends StatefulWidget {
  const BackgroundLoop({super.key});

  @override
  State<BackgroundLoop> createState() => _BackgroundLoopState();
}

class _BackgroundLoopState extends State<BackgroundLoop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final offset = _animation.value * height;

            return Stack(
              children: [
                Positioned(
                  top: -offset,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/background_awan.png',
                    fit: BoxFit.cover,
                    height: height,
                  ),
                ),
                Positioned(
                  top: height - offset,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/background_awan.png',
                    fit: BoxFit.cover,
                    height: height,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
