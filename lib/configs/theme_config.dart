import 'package:flutter/material.dart';

class AppColors {
  // Blue gradient colors - Updated for better contrast
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF1E88E5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF1976D2);
  
  // Light colors for backgrounds
  static const Color veryLightBlue = Color(0xFFE8F4FD);
  static const Color lightBackground = Color(0xFFF0F8FF);
  
  // Gradient definitions - Updated for better readability
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, darkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A3A6B), darkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient lightGradient = LinearGradient(
    colors: [lightBackground, veryLightBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Dark theme gradients
  static const LinearGradient darkGradientBackground = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient darkLightGradient = LinearGradient(
    colors: [Color(0xFF2C2C2C), Color(0xFF3A3A3A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // New button gradient for better contrast
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Text colors
  static const Color textOnGradient = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Color(0xFFFAFAFA);
  
  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkSurfaceColor = Color(0xFF2C2C2C);
  static const Color darkNavBarBackground = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
}

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    
    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textOnGradient),
      titleTextStyle: TextStyle(
        color: AppColors.textOnGradient,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    
    // ElevatedButton theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnGradient,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    
    // TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.primaryBlue, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    
    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.textSecondary,
      elevation: 8,
    ),
    
    // FloatingActionButton theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentBlue,
      foregroundColor: AppColors.textOnGradient,
    ),
  );
  
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    
    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textOnGradient),
      titleTextStyle: TextStyle(
        color: AppColors.textOnGradient,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.darkCardBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    
    // ElevatedButton theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnGradient,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    
    // TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightBlue,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.lightBlue, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
    ),
    
    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkNavBarBackground,
      selectedItemColor: AppColors.lightBlue,
      unselectedItemColor: AppColors.darkTextSecondary,
      elevation: 8,
    ),
    
    // FloatingActionButton theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentBlue,
      foregroundColor: AppColors.textOnGradient,
    ),
  );
  
  // Backward compatibility
  static ThemeData get blueGradientTheme => lightTheme;
}

class AppStyles {
  // Common gradient containers
  static BoxDecoration get primaryGradientDecoration => const BoxDecoration(
    gradient: AppColors.primaryGradient,
  );
  
  static BoxDecoration get primaryGradientWithRadius => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(12),
  );
  
  static BoxDecoration get lightGradientDecoration => const BoxDecoration(
    gradient: AppColors.lightGradient,
  );
  
  static BoxDecoration get darkGradientDecoration => const BoxDecoration(
    gradient: AppColors.darkGradient,
  );
  
  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle whiteTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textOnGradient,
  );
  
  static const TextStyle whiteHeadingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnGradient,
  );
}

class AppWidgets {
  // Gradient background widget
  static Widget gradientBackground({required Widget child, Gradient? gradient}) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
      ),
      child: child,
    );
  }
  
  // Gradient button with better contrast
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    Gradient? gradient,
    double? width,
    double height = 50,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: AppStyles.whiteTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Gradient app bar
  static PreferredSizeWidget gradientAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    bool centerTitle = false,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: AppBar(
          title: Text(title),
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          centerTitle: centerTitle,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}