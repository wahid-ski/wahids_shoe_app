import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/pages/splash_screen.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app_flutter/providers/favorite_provider.dart';
import 'package:shop_app_flutter/providers/theme_provider.dart';
import 'package:shop_app_flutter/providers/search_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState(); 
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 227, 197, 2),
        primary: const Color.fromARGB(255, 230, 147, 21),
        secondary: const Color.fromARGB(255, 255, 255, 255),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Color.fromARGB(255, 44, 45, 52),
        hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
       seedColor: const Color.fromARGB(255, 227, 197, 2),
        primary: const Color.fromARGB(255, 230, 147, 21),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Color.fromARGB(255, 216, 217, 222),
        hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: 
      Consumer<ThemeProvider>(
    
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Shoe Store',
            themeMode: themeProvider.themeMode, 
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
