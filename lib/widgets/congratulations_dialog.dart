import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/character_model.dart';
import '../services/genshin_api_service.dart';
import '../screens/character_detail_screen.dart';

class CongratulationsDialog extends StatelessWidget {
  final String itemName;
  final String? iconUrl;
  final bool isWeapon;
  final int count;
  final GenshinApiService? apiService;

  const CongratulationsDialog({
    super.key,
    required this.itemName,
    this.iconUrl,
    required this.isWeapon,
    this.count = 1,
    this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFB84D), Color(0xFFFF9A3D)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB84D).withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Star
            const Icon(Icons.auto_awesome, color: Colors.white, size: 48)
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 2.seconds)
                .then()
                .shimmer(duration: 1.5.seconds),
            
            const SizedBox(height: 16),
            
            // Congratulations - Two Lines
            const Column(
              children: [
                Text(
                  'CONGRAT',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3,
                    height: 1.1,
                  ),
                ),
                Text(
                  'ULATIONS!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3,
                    height: 1.1,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(),
            
            const SizedBox(height: 20),
            
            // Character/Weapon Icon
            if (iconUrl != null)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: iconUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Icon(
                        isWeapon ? Icons.gavel : Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.08, 1.08),
                    duration: 1.5.seconds,
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .scale(begin: const Offset(0.5, 0.5)),
            
            const SizedBox(height: 20),
            
            // Item Name
            Text(
              itemName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
            
            const SizedBox(height: 12),
            
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                count > 1
                    ? '$count × 5★ ${isWeapon ? 'Weapons' : 'Characters'}!'
                    : '5★ ${isWeapon ? 'Weapon' : 'Character'}!',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 700.ms).scale(),
            
            const SizedBox(height: 24),
            
            // Buttons
            if (!isWeapon)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    final api = apiService ?? GenshinApiService();
                    try {
                      final character = await api.getCharacter(itemName);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailScreen(character: character),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint('Error: $e');
                    }
                  },
                  icon: const Icon(Icons.person, size: 20),
                  label: const Text('View Character'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF9A3D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 800.ms).slideY(begin: 0.2, end: 0),
            
            if (!isWeapon) const SizedBox(height: 10),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue'),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: isWeapon ? 800.ms : 900.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

