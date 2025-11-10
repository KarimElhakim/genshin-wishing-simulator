import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'services/genshin_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  
  try {
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
  }
  
  runApp(const GenshinCompanionApp());
}

class GenshinCompanionApp extends StatelessWidget {
  const GenshinCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = GenshinApiService();
    
    return MaterialApp(
      title: 'Genshin Wishing Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFFB84D),
          secondary: const Color(0xFF7C4DFF),
          background: const Color(0xFF0A0E1A),
          surface: const Color(0xFF1A1F3A),
          error: const Color(0xFFCF6679),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF1A1F3A),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: HomeScreen(apiService: apiService),
    );
  }
}

