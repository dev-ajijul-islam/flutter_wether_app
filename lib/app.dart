import 'package:flutter/material.dart';
import 'package:wether_app/ui/screens/home_screen.dart';

class WetherApp extends StatelessWidget {
  const WetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          onSurface: Colors.white
        ),
        // textField theme
        inputDecorationTheme: InputDecorationThemeData(
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),

        //Outlined button theme

        iconButtonTheme: IconButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            minimumSize: Size(40,48),
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              // side: BorderSide(color: Colors.white)
            )
          )
        )
      ),
      home: HomeScreen(),
    );
  }
}
