import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 void _navigateToHome() {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // Start from the bottom
            end: Offset.zero, // End at the center
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800), // smooth 0.8s fade
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash_animation.json',
              height: 200,
              fit: BoxFit.cover,
              onLoaded: (composition) {
                // Navigate when animation is loaded and get its duration
                Future.delayed(Duration(milliseconds: composition.duration.inMilliseconds-1), _navigateToHome);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Shoepai',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
