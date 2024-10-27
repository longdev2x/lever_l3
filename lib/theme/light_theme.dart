import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData light({Color color = const Color(0xFF039D55)}) {
  ColorScheme colorScheme = const ColorScheme.light(
    //Bộ màu chính (nút quan trọng, icon chính, ...)
    primary: Color(0xFF039D55), // Màu chính
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF9CFFB9), // Màu nhẹ hơn, cho container
    onPrimaryContainer: Color(0xFF002113),
    // Bộ màu phụ
    secondary: Color(0xFF4F6352),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD1E8D2),
    onSecondaryContainer: Color(0xFF0C1F12),
    //Bề mặt (AppBar, card, dialog, bottomSheet, menu)
    surface: Color(0xFFFBFDF7),
    onSurface: Color(0xFF191C19),
    surfaceContainerHighest: Color(0xFFE4E6E0), // input decoration
    onSurfaceVariant: Color(0xFF414941),
    surfaceContainerLowest: Color(0xFFFFFFFF), //trắng
    //Màu viền
    outline: Color(0xFF717971),
    outlineVariant: Color(0xFFC1C9C1), //mờ hơn
    //Shadow
    shadow: Color(0xFF000000),
    //Lớp mờ
    scrim: Color(0xFF000000),
    //Error
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    // Khác
    surfaceTint: Color(0xFF039D55),
    tertiary: Color(0xFF396661),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBCECE6),
    onTertiaryContainer: Color(0xFF00201E),
    inverseSurface: Color(0xFF2E312E),
    inversePrimary: Color(0xFF80E29D),
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
    surfaceDim: Color(0xFFDBDDD8),
    surfaceBright: Color(0xFFFBFDF7),
    surfaceContainerLow: Color(0xFFF5F7F1),
    surfaceContainer: Color(0xFFEFF1EB),
    surfaceContainerHigh: Color(0xFFE9ECE6),
  );

  return ThemeData(
    brightness: Brightness.light,
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
