import 'package:flutter/material.dart';
import 'pages/splash_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna background utama
    final Color bgColor = const Color(0xFF32303B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PancaSaji',
      theme: ThemeData(
        useMaterial3: true,
        
        scaffoldBackgroundColor: bgColor, 
        
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SimpleSlideTransitionBuilder(),
            TargetPlatform.iOS: SimpleSlideTransitionBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SimpleSlideTransitionBuilder extends PageTransitionsBuilder {
  const SimpleSlideTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0); 
    const end = Offset.zero; 
    
    const curve = Curves.easeOutQuart; 

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}