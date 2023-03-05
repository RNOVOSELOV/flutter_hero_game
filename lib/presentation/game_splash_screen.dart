import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/presentation/game_page.dart';
import 'package:spacehero/resources/app_images.dart';

class GameSplashScreen extends StatefulWidget {
  const GameSplashScreen({Key? key}) : super(key: key);

  @override
  State<GameSplashScreen> createState() => _GameSplashScreenState();
}

class _GameSplashScreenState extends State<GameSplashScreen> {
  late FlameSplashController controller;

  @override
  void initState() {
    super.initState();
    controller = FlameSplashController(
        fadeInDuration: const Duration(seconds: 1),
        fadeOutDuration: const Duration(milliseconds: 250),
        waitDuration: const Duration(seconds: 2),
        autoStart: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showAfter: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImages.backgroundImage),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "SPACE CLEANER",
                  style: TextStyle(fontSize: 32, color: Colors.white60),
                ),
                const SizedBox(
                  height: 24,
                ),
                Image.asset(
                  'assets/images/plane_4.png',
                  height: 150,
                )
              ],
            ),
          );
        },
        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.of(context).push(
            MaterialPageRoute<GamePage>(
                builder: (context) => const GamePage())),
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
