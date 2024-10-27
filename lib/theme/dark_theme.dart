import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData dark({Color color = const Color(0xFF54b46b)}) {
  ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF80E29D),
    surfaceTint: Color(0xFF80E29D),
    onPrimary: Color(0xFF00391B),
    primaryContainer: Color(0xFF006D3C),
    onPrimaryContainer: Color(0xFF9CFFB9),
    secondary: Color(0xFFB5CCB7),
    onSecondary: Color(0xFF213527),
    secondaryContainer: Color(0xFF374B39),
    onSecondaryContainer: Color(0xFFD1E8D2),
    tertiary: Color(0xFFA0D0CA),
    onTertiary: Color(0xFF213734),
    tertiaryContainer: Color(0xFF1F4E4A),
    onTertiaryContainer: Color(0xFFBCECE6),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121518),
    onSurface: Color(0xFFE4E6E0),
    onSurfaceVariant: Color(0xFFC1C9C1),
    outline: Color(0xFF8B938B),
    outlineVariant: Color(0xFF414941),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE4E6E0),
    inversePrimary: Color(0xFF039D55),
    primaryFixed: Color(0xFF9CFFB9),
    onPrimaryFixed: Color(0xFF002113),
    primaryFixedDim: Color(0xFF80E29D),
    onPrimaryFixedVariant: Color(0xFF006D3C),
    secondaryFixed: Color(0xFFD1E8D2),
    onSecondaryFixed: Color(0xFF0C1F12),
    secondaryFixedDim: Color(0xFFB5CCB7),
    onSecondaryFixedVariant: Color(0xFF374B39),
    tertiaryFixed: Color(0xFFBCECE6),
    onTertiaryFixed: Color(0xFF00201E),
    tertiaryFixedDim: Color(0xFFA0D0CA),
    onTertiaryFixedVariant: Color(0xFF1F4E4A),
    surfaceDim: Color(0xFF121518),
    surfaceBright: Color(0xFF373A36),
    surfaceContainerLowest: Color(0xFF0C0F0C),
    surfaceContainerLow: Color(0xFF191C19),
    surfaceContainer: Color(0xFF1D201D),
    surfaceContainerHigh: Color(0xFF272B27),
    surfaceContainerHighest: Color(0xFF323532),
  );
  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,

    //app bar
    appBarTheme: AppBarTheme(
      color: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
    ),

    //Bottom Nav
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
    ),
    //Card
    cardTheme: CardTheme(
      color: colorScheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    //Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    //text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        color: colorScheme.onSurface,
      ),
    ),
    //input decoratioin

    inputDecorationTheme: InputDecorationTheme(
      fillColor: colorScheme.surfaceContainerHighest,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    ),
    //Divider
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
    ),
    //icon
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
      size: 24.r,
    ),
  );
}
