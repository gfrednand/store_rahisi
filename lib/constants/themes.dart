import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static const Color _lightWhiteGreyColor = Color(0xFFF1F1F1);
  static const Color _lightWhiteColor = Color(0xFFFFFFFF);
  static const Color _lightDarkGreyColor = Color(0xFF657786);
  // static const Color _lightVariantColor = Color(0XFFE1E1E1);
  static const Color _lightBlueColor = Color(0xFF1DA1F2);

  static const Color _darkBlack7Color = Color(0xFF14171A);
  static const Color _darkBlackColor = Colors.black87;
  // static const Color _darkVariantColor = Color(0XFFE1E1E1);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightWhiteColor,
    appBarTheme: AppBarTheme(
      color: _lightWhiteGreyColor,
      iconTheme: IconThemeData(
        color: _lightBlueColor,
      ),
    ),
    
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightWhiteGreyColor,
        selectedItemColor: _lightBlueColor,
        unselectedItemColor: _lightDarkGreyColor,
        unselectedIconTheme: IconThemeData(size: 23.0),
        selectedIconTheme: IconThemeData(size: 26.0)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: _lightWhiteColor,
      backgroundColor: _lightBlueColor,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: _lightBlueColor,
      primaryVariant: Colors.white38,
      secondary: _darkBlack7Color,
    ),
    cardTheme: CardTheme(
      color: _lightWhiteColor,
    ),
    iconTheme: IconThemeData(color: _lightBlueColor),
    // buttonBarTheme: ButtonBarThemeData(buttonTextTheme: ButtonTextTheme.accent),
  
    tabBarTheme: TabBarTheme(labelColor:_lightDarkGreyColor ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        // fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.black54,
        // fontSize: 18.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    dividerTheme: DividerThemeData(color: _lightWhiteColor),
    scaffoldBackgroundColor:_darkBlackColor,
    appBarTheme: AppBarTheme(
      color: _darkBlack7Color,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkBlack7Color,
        selectedItemColor: _lightBlueColor,
        unselectedItemColor: _lightDarkGreyColor,
        unselectedIconTheme: IconThemeData(size: 23.0),
        selectedIconTheme: IconThemeData(size: 26.0)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: _lightWhiteColor,
      backgroundColor: _lightBlueColor,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.black54,
      primaryVariant: Colors.black,
      secondary: _lightWhiteColor,
      error: Colors.yellow[50]
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        // fontSize: 20.0,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        // fontSize: 18.0,
      ),
    ),
  );
}
