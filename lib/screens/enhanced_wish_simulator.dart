import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/gacha_calculator.dart';
import '../services/genshin_api_service.dart';
import '../widgets/star_animation.dart';
import '../widgets/congratulations_dialog.dart';
import '../models/character_model.dart';
import 'character_detail_screen.dart';

class EnhancedWishSimulator extends StatefulWidget {
  final GenshinApiService? apiService;
  
  const EnhancedWishSimulator({super.key, this.apiService});

  @override
  State<EnhancedWishSimulator> createState() => _EnhancedWishSimulatorState();
}

class _EnhancedWishSimulatorState extends State<EnhancedWishSimulator> {
  final WishSimulator _simulator = WishSimulator();
  final List<DetailedWishResult> _history = [];
  bool _isAnimating = false;
  bool _showStarAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish Simulator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistory,
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetSimulator,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Pity Display with Gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      Theme.of(context).cardColor,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPityIndicator(
                      'Pity',
                      '${_simulator.pityCount}',
                      '/ 90',
                      Icons.trending_up,
                      _simulator.pityCount >= 74 ? Colors.orange : Colors.white,
                    ),
                    _buildPityIndicator(
                      'Guarantee',
                      _simulator.hasGuarantee ? 'YES' : 'NO',
                      '',
                      Icons.verified,
                      _simulator.hasGuarantee ? Colors.green : Colors.grey,
                    ),
                    _buildPityIndicator(
                      'Total',
                      '${_history.length}',
                      'pulls',
                      Icons.auto_awesome,
                      const Color(0xFFFFB84D),
                    ),
                  ],
                ),
              ),
              
              // Wish Results
              Expanded(
                child: _history.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        reverse: true,
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final result = _history[_history.length - 1 - index];
                          return _buildEnhancedWishCard(result, index);
                        },
                      ),
              ),
              
              // Action Buttons
              _buildActionButtons(),
            ],
          ),
          
          // Star Animation Overlay for 10-pulls
          if (_showStarAnimation)
            Center(
              child: StarAnimation(
                show: _showStarAnimation,
                onComplete: () {
                  setState(() => _showStarAnimation = false);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPityIndicator(String label, String value, String suffix, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (suffix.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 2),
                child: Text(
                  suffix,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 80, color: Color(0xFFFFB84D))
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds),
          const SizedBox(height: 24),
          Text(
            'Ready to Wish!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Make your first wish below',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white60,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedWishCard(DetailedWishResult result, int index) {
    final Color rarityColor = _getRarityColor(result.rarity);
    final bool isFiveStar = result.rarity == 5;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isFiveStar ? 8 : 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isFiveStar
              ? LinearGradient(
                  colors: [
                    rarityColor.withOpacity(0.3),
                    Theme.of(context).cardColor,
                  ],
                )
              : null,
          border: isFiveStar
              ? Border.all(color: rarityColor, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Character/Weapon Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: rarityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: rarityColor, width: 2),
              ),
              child: result.iconUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: result.iconUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          result.isWeapon ? Icons.gavel : Icons.person,
                          color: rarityColor,
                          size: 32,
                        ),
                      ),
                    )
                  : Icon(
                      result.isWeapon ? Icons.gavel : Icons.person,
                      color: rarityColor,
                      size: 32,
                    ),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.itemName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: rarityColor,
                          ),
                        ),
                      ),
                      Text(
                        result.rarityStars,
                        style: TextStyle(
                          color: rarityColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Pity: ${result.pityCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                      if (isFiveStar && result.isFeatured) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'GUARANTEED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAnimating ? null : _performSingleWish,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Wish x1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAnimating ? null : _perform10Wishes,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Wish x10', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFFFB84D),
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Accurate Genshin Impact gacha simulation',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 5: return const Color(0xFFFFB84D);
      case 4: return const Color(0xFFB085F5);
      default: return Colors.grey;
    }
  }

  void _performSingleWish() async {
    setState(() => _isAnimating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    final result = _simulator.simulatePull();
    final detailed = _createDetailedResult(result);
    
    setState(() {
      _history.add(detailed);
      _isAnimating = false;
    });
    
    if (result.rarity == 5) {
      _showFiveStarDialog(detailed);
    }
  }

  void _perform10Wishes() async {
    setState(() {
      _isAnimating = true;
      _showStarAnimation = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final results = _simulator.simulate10Pulls();
    final detailedResults = results.map(_createDetailedResult).toList();
    
    setState(() {
      _history.addAll(detailedResults);
      _isAnimating = false;
    });
    
    final fiveStars = detailedResults.where((r) => r.rarity == 5).toList();
    if (fiveStars.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      _showFiveStarDialog(fiveStars.first, count: fiveStars.length);
    }
  }

  DetailedWishResult _createDetailedResult(WishResult result) {
    // Use data directly from WishResult - now has real variety!
    return DetailedWishResult(
      rarity: result.rarity,
      isFeatured: result.isFeatured,
      pityCount: result.pityCount,
      itemName: result.itemName,
      iconUrl: result.itemIcon,
      isWeapon: result.isWeapon,
    );
  }

  void _showFiveStarDialog(DetailedWishResult result, {int count = 1}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CongratulationsDialog(
        itemName: result.itemName,
        iconUrl: result.iconUrl,
        isWeapon: result.isWeapon,
        count: count,
        apiService: widget.apiService,
      ),
    );
  }

  void _showHistory() {
    // Show detailed history dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wish History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildHistoryStats(),
              const Divider(),
              ..._history.reversed.map((result) => ListTile(
                    leading: Icon(
                      Icons.auto_awesome,
                      color: _getRarityColor(result.rarity),
                    ),
                    title: Text(result.itemName),
                    subtitle: Text('Pity: ${result.pityCount}'),
                    trailing: Text(
                      result.rarityStars,
                      style: TextStyle(color: _getRarityColor(result.rarity)),
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryStats() {
    final fiveStars = _history.where((r) => r.rarity == 5).length;
    final fourStars = _history.where((r) => r.rarity == 4).length;
    final threeStars = _history.where((r) => r.rarity == 3).length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Pulls: ${_history.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('5★: $fiveStars (${_history.isEmpty ? 0 : (fiveStars / _history.length * 100).toStringAsFixed(1)}%)'),
        Text('4★: $fourStars (${_history.isEmpty ? 0 : (fourStars / _history.length * 100).toStringAsFixed(1)}%)'),
        Text('3★: $threeStars (${_history.isEmpty ? 0 : (threeStars / _history.length * 100).toStringAsFixed(1)}%)'),
      ],
    );
  }

  void _resetSimulator() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Simulator'),
        content: const Text('Reset all progress including pity, guarantee, and history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _simulator.reset();
                _history.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class DetailedWishResult {
  final int rarity;
  final bool isFeatured;
  final int pityCount;
  final String itemName;
  final String? iconUrl;
  final bool isWeapon;

  DetailedWishResult({
    required this.rarity,
    required this.isFeatured,
    required this.pityCount,
    required this.itemName,
    this.iconUrl,
    this.isWeapon = false,
  });

  String get rarityStars => '★' * rarity;
}

