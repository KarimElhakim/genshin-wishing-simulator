import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'characters_list_screen.dart';
import 'calculator_screen.dart';
import 'enhanced_wish_simulator.dart';
import '../services/genshin_api_service.dart';

class HomeScreen extends StatefulWidget {
  final GenshinApiService apiService;
  
  const HomeScreen({super.key, required this.apiService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0E1A),
              const Color(0xFF1A1F3A),
              const Color(0xFF0A0E1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Header with Icon
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // App Icon/Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB84D).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFB84D), Color(0xFFFF9A3D)],
                              ),
                            ),
                            child: const Icon(Icons.auto_awesome, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0)),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'Genshin Wishing Simulator',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFB84D),
                        shadows: [
                          Shadow(
                            color: const Color(0xFFFFB84D).withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'Your Ultimate Gacha Experience',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .slideY(begin: -0.2, end: 0),
                  ],
                ),
              ),
              
              // Main Menu Cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMenuCard(
                        context,
                        title: 'Character Wiki',
                        description: 'Browse all characters, constellations & builds',
                        icon: Icons.people,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B3D), Color(0xFFFF9A3D)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CharactersListScreen(apiService: widget.apiService),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(begin: -0.2, end: 0),
                      
                      const SizedBox(height: 20),
                      
                      _buildMenuCard(
                        context,
                        title: 'Constellation Calculator',
                        description: 'Calculate pulls needed for constellations',
                        icon: Icons.calculate,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C4DFF), Color(0xFFB085F5)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalculatorScreen(),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 600.ms)
                          .slideX(begin: -0.2, end: 0),
                      
                      const SizedBox(height: 20),
                      
                      _buildMenuCard(
                        context,
                        title: 'Wish Simulator',
                        description: 'Simulate wishes with accurate rates',
                        icon: Icons.auto_awesome,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CC2F1), Color(0xFF74C2A8)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EnhancedWishSimulator(apiService: widget.apiService),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 800.ms)
                          .slideX(begin: -0.2, end: 0),
                    ],
                  ),
                ),
              ),
              
              // Footer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome, size: 24, color: Color(0xFFFFB84D)),
                    const SizedBox(height: 8),
                    Text(
                      'v1.4.0 • Unofficial Fan Project',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Not affiliated with HoYoverse',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white24,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}

