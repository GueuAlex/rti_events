import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../config/palette.dart';
import '../scan_screen/scan_screen.dart';

class SplashSceen extends StatefulWidget {
  static String routeName = 'splash_screen';
  const SplashSceen({super.key});

  @override
  State<SplashSceen> createState() => _SplashSceenState();
}

class _SplashSceenState extends State<SplashSceen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showLoading = false;

  @override
  void initState() {
    // dropTable();
    super.initState();

    // Initialiser le contrôleur d'animation
    _controller = AnimationController(vsync: this);

    // Écouter l'état de l'animation pour savoir quand elle est terminée
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Action à effectuer à la fin de l'animation
        /* Navigator.pushReplacementNamed(context, IntroScrenn.routeName); */
        _toggleLoading();
        // get logged state
        // bool isLogged = await Functions.getLoggedState();
        Future.delayed(const Duration(seconds: 3)).then(
          (value) {
            if (mounted) {
              Navigator.pushReplacementNamed(
                context,
                /* BottomBar.routeName, */
                /* RegistrationScreen.routeName, */

                /* SetupScreen.routeName, */
                /*  WelcomeScreen.routeName, */
                /* SetupScreen.routeName, */
                ScannerScreen.routeName,
                /* ScanScreen.routeName, */
                /* (route) => false, */
              );
            }
          },
        );
      }
    });
  }

  /*  void dropTable() async {
    LocalService localService = LocalService();
    int r = await localService.dropTable();
    print(r);
  } */

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(),
              SizedBox(
                width: 370,
                child: Lottie.asset(
                  'assets/images/logo-animated.json',
                  controller: _controller,
                  animate: true,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(bottom: 40),
                child: _showLoading
                    ? const CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Palette.appRed,
                        ),
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _toggleLoading() {
    setState(() {
      _showLoading = !_showLoading;
    });
  }
}
