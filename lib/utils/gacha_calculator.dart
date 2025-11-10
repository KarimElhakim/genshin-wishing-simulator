import 'dart:math';
import '../data/gacha_pools.dart';

class GachaRates {
  // 5-Star Rates
  static const double fiveStarBaseRate = 0.006; // 0.6%
  static const int fiveStarHardPity = 90;
  static const int fiveStarSoftPity = 74;
  static const double fiveStarSoftPityIncrease = 0.06; // +6% per pull after 74
  
  // 4-Star Rates
  static const double fourStarBaseRate = 0.051; // 5.1%
  static const int fourStarHardPity = 10;
  
  // 50/50 System
  static const double featuredCharacterRate = 0.5; // 50%
  
  // Primogem Costs
  static const int primogemsPerWish = 160;
  static const int wishesPerTenPull = 10;
}

class ConstellationCalculator {
  /// Calculate pulls needed from current to target constellation
  static CalculationResult calculate({
    required int currentConstellation,  // 0-6
    required int targetConstellation,   // 0-6
    required int currentPrimogems,
    required int currentFates,
    required int pityCount,            // Current pity (0-89)
    required bool hasGuarantee,        // Is next 5-star guaranteed?
  }) {
    if (targetConstellation <= currentConstellation) {
      return CalculationResult(
        copiesNeeded: 0,
        totalPullsNeeded: 0,
        primogemsNeeded: 0,
        guaranteedPulls: 0,
        worstCasePulls: 0,
        bestCasePulls: 0,
      );
    }

    // Copies needed (C0 means 1 copy, C1 means 2 copies, etc.)
    int copiesNeeded = targetConstellation - currentConstellation;
    
    // Average pulls per 5-star considering soft pity
    // With guarantee: ~75 pulls average
    // Without guarantee (50/50): ~150 pulls average (could lose 50/50)
    double avgPullsPerCopy = hasGuarantee ? 75.0 : 150.0;
    
    // Calculate total pulls needed
    int totalPullsNeeded = (copiesNeeded * avgPullsPerCopy).ceil() - pityCount;
    if (totalPullsNeeded < 0) totalPullsNeeded = 0;
    
    // Account for existing resources
    int totalFates = currentFates + (currentPrimogems ~/ GachaRates.primogemsPerWish);
    int remainingPulls = totalPullsNeeded - totalFates;
    int primogemsNeeded = remainingPulls > 0 ? remainingPulls * GachaRates.primogemsPerWish : 0;
    
    // Calculate best case (win all 50/50s)
    int bestCasePulls = (copiesNeeded * 75).ceil();
    
    // Calculate worst case (lose all 50/50s + hard pity every time)
    int worstCasePulls = (copiesNeeded * 180).ceil();
    
    // Calculate guaranteed pulls (accounting for 50/50 losses)
    int guaranteedPulls = hasGuarantee ? copiesNeeded : (copiesNeeded * 2);
    
    return CalculationResult(
      copiesNeeded: copiesNeeded,
      totalPullsNeeded: totalPullsNeeded,
      primogemsNeeded: primogemsNeeded,
      guaranteedPulls: guaranteedPulls,
      worstCasePulls: worstCasePulls,
      bestCasePulls: bestCasePulls,
    );
  }
}

class CalculationResult {
  final int copiesNeeded;
  final int totalPullsNeeded;
  final int primogemsNeeded;
  final int guaranteedPulls;
  final int worstCasePulls;
  final int bestCasePulls;

  CalculationResult({
    required this.copiesNeeded,
    required this.totalPullsNeeded,
    required this.primogemsNeeded,
    required this.guaranteedPulls,
    required this.worstCasePulls,
    required this.bestCasePulls,
  });
}

class WishSimulator {
  int pityCount = 0;
  bool hasGuarantee = false;
  final Random _random = Random();
  final GachaPoolManager _poolManager = GachaPoolManager();
  
  /// Simulate a single pull with REAL variety
  WishResult simulatePull() {
    pityCount++;
    
    // Check for 5-star
    double fiveStarRate = _calculateFiveStarRate(pityCount);
    if (_random.nextDouble() < fiveStarRate) {
      bool isFeatured = hasGuarantee || _random.nextDouble() < GachaRates.featuredCharacterRate;
      int currentPity = pityCount;
      pityCount = 0;
      hasGuarantee = !isFeatured;
      
      // Get actual 5-star item from pool
      final item = _poolManager.getFiveStar(isFeatured: isFeatured);
      
      return WishResult(
        rarity: 5,
        isFeatured: isFeatured,
        pityCount: currentPity,
        itemName: item.name,
        itemIcon: item.displayIcon,
        isWeapon: item.isWeapon,
      );
    }
    
    // Check for 4-star
    if (pityCount % GachaRates.fourStarHardPity == 0 || _random.nextDouble() < GachaRates.fourStarBaseRate) {
      // Get actual 4-star item from pool
      final item = _poolManager.getFourStar();
      
      return WishResult(
        rarity: 4,
        isFeatured: _random.nextDouble() < 0.5,
        pityCount: pityCount,
        itemName: item.name,
        itemIcon: item.displayIcon,
        isWeapon: item.isWeapon,
      );
    }
    
    // 3-star weapon
    final item = _poolManager.getThreeStar();
    
    return WishResult(
      rarity: 3,
      isFeatured: false,
      pityCount: pityCount,
      itemName: item.name,
      itemIcon: item.displayIcon,
      isWeapon: true,
    );
  }
  
  /// Simulate 10 pulls
  List<WishResult> simulate10Pulls() {
    List<WishResult> results = [];
    for (int i = 0; i < 10; i++) {
      results.add(simulatePull());
    }
    return results;
  }
  
  /// Calculate 5-star rate with soft pity
  double _calculateFiveStarRate(int pity) {
    if (pity < GachaRates.fiveStarSoftPity) {
      return GachaRates.fiveStarBaseRate;
    }
    if (pity >= GachaRates.fiveStarHardPity) {
      return 1.0; // Hard pity - guaranteed
    }
    // Soft pity - rate increases
    return GachaRates.fiveStarBaseRate + 
           ((pity - GachaRates.fiveStarSoftPity + 1) * GachaRates.fiveStarSoftPityIncrease);
  }
  
  /// Reset simulator
  void reset() {
    pityCount = 0;
    hasGuarantee = false;
  }
}

class WishResult {
  final int rarity;
  final bool isFeatured;
  final int pityCount;
  final String itemName;
  final String? itemIcon;
  final bool isWeapon;

  WishResult({
    required this.rarity,
    required this.isFeatured,
    required this.pityCount,
    required this.itemName,
    this.itemIcon,
    this.isWeapon = false,
  });
}

