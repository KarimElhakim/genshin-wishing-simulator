/// Complete Gacha Pools - Realistic Genshin Impact Simulation
/// All 3-star weapons, 4-star characters/weapons, 5-star characters/weapons
/// From Enka.Network avatars.json and weapons.json

import 'dart:math';

const String enkaUI = 'https://enka.network/ui';

/// Complete 3-Star Weapon Pool (25 weapons)
final List<GachaItem> threeStarPool = [
  // Swords (5 weapons)
  GachaItem(id: '11101', name: 'Dull Blade', icon: '/ui/UI_EquipIcon_Sword_Blunt.png', rarity: 3, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11201', name: 'Silver Sword', icon: '/ui/UI_EquipIcon_Sword_Silver.png', rarity: 3, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11301', name: 'Cool Steel', icon: '/ui/UI_EquipIcon_Sword_Steel.png', rarity: 3, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11401', name: 'Harbinger of Dawn', icon: '/ui/UI_EquipIcon_Sword_Dawn.png', rarity: 3, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11501', name: 'Traveler\'s Handy Sword', icon: '/ui/UI_EquipIcon_Sword_Traveler.png', rarity: 3, isWeapon: true, type: 'Sword'),
  
  // Claymores (5 weapons)
  GachaItem(id: '12101', name: 'Waster Greatsword', icon: '/ui/UI_EquipIcon_Claymore_Aniki.png', rarity: 3, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12201', name: 'Old Merc\'s Pal', icon: '/ui/UI_EquipIcon_Claymore_Oyaji.png', rarity: 3, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12301', name: 'Ferrous Shadow', icon: '/ui/UI_EquipIcon_Claymore_Glaive.png', rarity: 3, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12401', name: 'Bloodtainted Greatsword', icon: '/ui/UI_EquipIcon_Claymore_Siegfry.png', rarity: 3, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12501', name: 'White Iron Greatsword', icon: '/ui/UI_EquipIcon_Claymore_Tin.png', rarity: 3, isWeapon: true, type: 'Claymore'),
  
  // Polearms (5 weapons)
  GachaItem(id: '13101', name: 'Beginner\'s Protector', icon: '/ui/UI_EquipIcon_Pole_Gewalt.png', rarity: 3, isWeapon: true, type: 'Polearm'),
  GachaItem(id: '13201', name: 'Iron Point', icon: '/ui/UI_EquipIcon_Pole_Rod.png', rarity: 3, isWeapon: true, type: 'Polearm'),
  GachaItem(id: '13301', name: 'Halberd', icon: '/ui/UI_EquipIcon_Pole_Halberd.png', rarity: 3, isWeapon: true, type: 'Polearm'),
  GachaItem(id: '13401', name: 'Black Tassel', icon: '/ui/UI_EquipIcon_Pole_Divide.png', rarity: 3, isWeapon: true, type: 'Polearm'),
  GachaItem(id: '13401', name: 'White Tassel', icon: '/ui/UI_EquipIcon_Pole_Jade.png', rarity: 3, isWeapon: true, type: 'Polearm'),
  
  // Catalysts (5 weapons)
  GachaItem(id: '14101', name: 'Apprentice\'s Notes', icon: '/ui/UI_EquipIcon_Catalyst_Apprentice.png', rarity: 3, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14201', name: 'Pocket Grimoire', icon: '/ui/UI_EquipIcon_Catalyst_Pocket.png', rarity: 3, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14301', name: 'Magic Guide', icon: '/ui/UI_EquipIcon_Catalyst_Intro.png', rarity: 3, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14401', name: 'Thrilling Tales of Dragon Slayers', icon: '/ui/UI_EquipIcon_Catalyst_Pulpfic.png', rarity: 3, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14501', name: 'Twin Nephrite', icon: '/ui/UI_EquipIcon_Catalyst_Jade.png', rarity: 3, isWeapon: true, type: 'Catalyst'),
  
  // Bows (5 weapons)
  GachaItem(id: '15101', name: 'Hunter\'s Bow', icon: '/ui/UI_EquipIcon_Bow_Hunters.png', rarity: 3, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15201', name: 'Seasoned Hunter\'s Bow', icon: '/ui/UI_EquipIcon_Bow_Old.png', rarity: 3, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15301', name: 'Raven Bow', icon: '/ui/UI_EquipIcon_Bow_Crowfeather.png', rarity: 3, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15401', name: 'Sharpshooter\'s Oath', icon: '/ui/UI_EquipIcon_Bow_Arjuna.png', rarity: 3, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15501', name: 'Recurve Bow', icon: '/ui/UI_EquipIcon_Bow_Curve.png', rarity: 3, isWeapon: true, type: 'Bow'),
];

/// 4-Star Character Pool (Standard Banner) - ALL ICONS FIXED
final List<GachaItem> fourStarCharacters = [
  GachaItem(id: '10000032', name: 'Bennett', icon: 'UI_AvatarIcon_Bennett', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000023', name: 'Xiangling', icon: 'UI_AvatarIcon_Xiangling', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000014', name: 'Barbara', icon: 'UI_AvatarIcon_Barbara', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000025', name: 'Xingqiu', icon: 'UI_AvatarIcon_Xingqiu', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000031', name: 'Fischl', icon: 'UI_AvatarIcon_Fischl', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000043', name: 'Sucrose', icon: 'UI_AvatarIcon_Sucrose', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000024', name: 'Beidou', icon: 'UI_AvatarIcon_Beidou', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000027', name: 'Ningguang', icon: 'UI_AvatarIcon_Ningguang', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000020', name: 'Razor', icon: 'UI_AvatarIcon_Razor', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000034', name: 'Noelle', icon: 'UI_AvatarIcon_Noel', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000036', name: 'Chongyun', icon: 'UI_AvatarIcon_Chongyun', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000039', name: 'Diona', icon: 'UI_AvatarIcon_Diona', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000044', name: 'Xinyan', icon: 'UI_AvatarIcon_Xinyan', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000045', name: 'Rosaria', icon: 'UI_AvatarIcon_Rosaria', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000048', name: 'Yanfei', icon: 'UI_AvatarIcon_Feiyan', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000053', name: 'Sayu', icon: 'UI_AvatarIcon_Sayu', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000056', name: 'Kujou Sara', icon: 'UI_AvatarIcon_Sara', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000065', name: 'Kuki Shinobu', icon: 'UI_AvatarIcon_Shinobu', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000055', name: 'Gorou', icon: 'UI_AvatarIcon_Gorou', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000050', name: 'Thoma', icon: 'UI_AvatarIcon_Tohma', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000064', name: 'Yun Jin', icon: 'UI_AvatarIcon_Yunjin', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000059', name: 'Shikanoin Heizou', icon: 'UI_AvatarIcon_Heizo', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000067', name: 'Collei', icon: 'UI_AvatarIcon_Collei', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000068', name: 'Dori', icon: 'UI_AvatarIcon_Dori', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000072', name: 'Candace', icon: 'UI_AvatarIcon_Candace', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000074', name: 'Layla', icon: 'UI_AvatarIcon_Layla', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000076', name: 'Faruzan', icon: 'UI_AvatarIcon_Faruzan', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000077', name: 'Yaoyao', icon: 'UI_AvatarIcon_Yaoyao', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000081', name: 'Kaveh', icon: 'UI_AvatarIcon_Kaveh', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000061', name: 'Kirara', icon: 'UI_AvatarIcon_Momoka', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000083', name: 'Lynette', icon: 'UI_AvatarIcon_Linette', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000085', name: 'Freminet', icon: 'UI_AvatarIcon_Freminet', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000088', name: 'Charlotte', icon: 'UI_AvatarIcon_Charlotte', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000090', name: 'Chevreuse', icon: 'UI_AvatarIcon_Chevreuse', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000092', name: 'Gaming', icon: 'UI_AvatarIcon_Gaming', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000097', name: 'Sethos', icon: 'UI_AvatarIcon_Sethos', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000100', name: 'Kachina', icon: 'UI_AvatarIcon_Kachina', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000105', name: 'Ororon', icon: 'UI_AvatarIcon_Olorun', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000021', name: 'Amber', icon: 'UI_AvatarIcon_Ambor', rarity: 4, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000108', name: 'Lan Yan', icon: 'UI_AvatarIcon_Lanyan', rarity: 4, isWeapon: false, type: 'Character'),
];

/// 4-Star Weapon Pool (Common gacha weapons)
final List<GachaItem> fourStarWeapons = [
  // Swords
  GachaItem(id: '11302', name: 'The Flute', icon: '/ui/UI_EquipIcon_Sword_Troupe.png', rarity: 4, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11402', name: 'Favonius Sword', icon: '/ui/UI_EquipIcon_Sword_Zephyrus.png', rarity: 4, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11403', name: 'Sacrificial Sword', icon: '/ui/UI_EquipIcon_Sword_Fossil.png', rarity: 4, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11405', name: 'The Lion\'s Roar', icon: '/ui/UI_EquipIcon_Sword_Rockkiller.png', rarity: 4, isWeapon: true, type: 'Sword'),
  
  // Claymores
  GachaItem(id: '12402', name: 'Favonius Greatsword', icon: '/ui/UI_EquipIcon_Claymore_Zephyrus.png', rarity: 4, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12403', name: 'Sacrificial Greatsword', icon: '/ui/UI_EquipIcon_Claymore_Fossil.png', rarity: 4, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12405', name: 'The Bell', icon: '/ui/UI_EquipIcon_Claymore_Troupe.png', rarity: 4, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12406', name: 'Rainslasher', icon: '/ui/UI_EquipIcon_Claymore_Perdue.png', rarity: 4, isWeapon: true, type: 'Claymore'),
  
  // Polearms
  GachaItem(id: '13401', name: 'Favonius Lance', icon: '/ui/UI_EquipIcon_Pole_Zephyrus.png', rarity: 4, isWeapon: true, type: 'Polearm'),
  GachaItem(id: '13407', name: 'Dragon\'s Bane', icon: '/ui/UI_EquipIcon_Pole_Stardust.png', rarity: 4, isWeapon: true, type: 'Polearm'),
  
  // Catalysts
  GachaItem(id: '14402', name: 'Favonius Codex', icon: '/ui/UI_EquipIcon_Catalyst_Zephyrus.png', rarity: 4, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14403', name: 'Sacrificial Fragments', icon: '/ui/UI_EquipIcon_Catalyst_Fossil.png', rarity: 4, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14409', name: 'The Widsith', icon: '/ui/UI_EquipIcon_Catalyst_Troupe.png', rarity: 4, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14404', name: 'Eye of Perception', icon: '/ui/UI_EquipIcon_Catalyst_Truelens.png', rarity: 4, isWeapon: true, type: 'Catalyst'),
  
  // Bows
  GachaItem(id: '15401', name: 'Favonius Warbow', icon: '/ui/UI_EquipIcon_Bow_Zephyrus.png', rarity: 4, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15402', name: 'Rust', icon: '/ui/UI_EquipIcon_Bow_Recluse.png', rarity: 4, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15403', name: 'Sacrificial Bow', icon: '/ui/UI_EquipIcon_Bow_Fossil.png', rarity: 4, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15405', name: 'The Stringless', icon: '/ui/UI_EquipIcon_Bow_Troupe.png', rarity: 4, isWeapon: true, type: 'Bow'),
];

/// 5-Star Character Pool (Standard Banner) - FIXED ICONS
final List<GachaItem> fiveStarStandardCharacters = [
  GachaItem(id: '10000003', name: 'Jean', icon: 'UI_AvatarIcon_Qin', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000016', name: 'Diluc', icon: 'UI_AvatarIcon_Diluc', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000041', name: 'Mona', icon: 'UI_AvatarIcon_Mona', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000035', name: 'Qiqi', icon: 'UI_AvatarIcon_Qiqi', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000042', name: 'Keqing', icon: 'UI_AvatarIcon_Keqing', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000069', name: 'Tighnari', icon: 'UI_AvatarIcon_Tighnari', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000079', name: 'Dehya', icon: 'UI_AvatarIcon_Dehya', rarity: 5, isWeapon: false, type: 'Character'),
];

/// 5-Star Featured Characters (Current/Recent Banners) - FIXED ICONS
final List<GachaItem> fiveStarFeaturedCharacters = [
  GachaItem(id: '10000104', name: 'Chasca', icon: 'UI_AvatarIcon_Chasca', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000089', name: 'Furina', icon: 'UI_AvatarIcon_Furina', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000103', name: 'Xilonen', icon: 'UI_AvatarIcon_Xilonen', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000096', name: 'Arlecchino', icon: 'UI_AvatarIcon_Arlecchino', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000046', name: 'Hu Tao', icon: 'UI_AvatarIcon_Hutao', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000052', name: 'Raiden Shogun', icon: 'UI_AvatarIcon_Shougun', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000087', name: 'Neuvillette', icon: 'UI_AvatarIcon_Neuvillette', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000047', name: 'Kaedehara Kazuha', icon: 'UI_AvatarIcon_Kazuha', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000078', name: 'Alhaitham', icon: 'UI_AvatarIcon_Alhatham', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000082', name: 'Baizhu', icon: 'UI_AvatarIcon_Baizhuer', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000084', name: 'Lyney', icon: 'UI_AvatarIcon_Liney', rarity: 5, isWeapon: false, type: 'Character'),
  GachaItem(id: '10000093', name: 'Xianyun', icon: 'UI_AvatarIcon_Liuyun', rarity: 5, isWeapon: false, type: 'Character'),
];

/// 5-Star Weapons (Standard)
final List<GachaItem> fiveStarWeapons = [
  // Swords
  GachaItem(id: '11501', name: 'Skyward Blade', icon: '/ui/UI_EquipIcon_Sword_Dvalin.png', rarity: 5, isWeapon: true, type: 'Sword'),
  GachaItem(id: '11502', name: 'Aquila Favonia', icon: '/ui/UI_EquipIcon_Sword_Falcon.png', rarity: 5, isWeapon: true, type: 'Sword'),
  
  // Claymores
  GachaItem(id: '12501', name: 'Skyward Pride', icon: '/ui/UI_EquipIcon_Claymore_Dvalin.png', rarity: 5, isWeapon: true, type: 'Claymore'),
  GachaItem(id: '12502', name: 'Wolf\'s Gravestone', icon: '/ui/UI_EquipIcon_Claymore_Wolfmound.png', rarity: 5, isWeapon: true, type: 'Claymore'),
  
  // Polearms
  GachaItem(id: '13501', name: 'Skyward Spine', icon: '/ui/UI_EquipIcon_Pole_Dvalin.png', rarity: 5, isWeapon: true, type: 'Polearm'),
  GachaItem(id: '13505', name: 'Primordial Jade Winged-Spear', icon: '/ui/UI_EquipIcon_Pole_Morax.png', rarity: 5, isWeapon: true, type: 'Polearm'),
  
  // Catalysts
  GachaItem(id: '14501', name: 'Skyward Atlas', icon: '/ui/UI_EquipIcon_Catalyst_Dvalin.png', rarity: 5, isWeapon: true, type: 'Catalyst'),
  GachaItem(id: '14502', name: 'Lost Prayer to the Sacred Winds', icon: '/ui/UI_EquipIcon_Catalyst_Kaleido.png', rarity: 5, isWeapon: true, type: 'Catalyst'),
  
  // Bows
  GachaItem(id: '15501', name: 'Skyward Harp', icon: '/ui/UI_EquipIcon_Bow_Dvalin.png', rarity: 5, isWeapon: true, type: 'Bow'),
  GachaItem(id: '15502', name: 'Amos\' Bow', icon: '/ui/UI_EquipIcon_Bow_Amos.png', rarity: 5, isWeapon: true, type: 'Bow'),
];

class GachaItem {
  final String id;
  final String name;
  final String icon;
  final int rarity;
  final bool isWeapon;
  final String type;

  const GachaItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.rarity,
    required this.isWeapon,
    required this.type,
  });

  String get iconUrl {
    if (isWeapon) {
      return icon.startsWith('/ui/') ? 'https://enka.network$icon' : 'https://enka.network/ui/$icon';
    } else {
      // Character - use gacha card
      return icon.startsWith('UI_') ? 'https://enka.network/ui/$icon.png' : 'https://enka.network/ui/UI_Gacha_AvatarImg_$icon.png';
    }
  }
  
  String get displayIcon {
    if (isWeapon) {
      return iconUrl;
    } else {
      // For character icon (face), convert gacha card name to icon name
      final iconName = icon.replaceAll('UI_Gacha_AvatarImg_', 'UI_AvatarIcon_');
      return 'https://enka.network/ui/$iconName.png';
    }
  }
}

/// Gacha Pool Manager
class GachaPoolManager {
  final Random _random = Random();
  
  /// Get random 3-star weapon
  GachaItem getThreeStar() {
    return threeStarPool[_random.nextInt(threeStarPool.length)];
  }
  
  /// Get random 4-star (50% character, 50% weapon)
  GachaItem getFourStar() {
    if (_random.nextBool()) {
      // 50% chance character
      return fourStarCharacters[_random.nextInt(fourStarCharacters.length)];
    } else {
      // 50% chance weapon
      return fourStarWeapons[_random.nextInt(fourStarWeapons.length)];
    }
  }
  
  /// Get random 5-star (50/50 system)
  GachaItem getFiveStar({required bool isFeatured}) {
    if (isFeatured) {
      // Featured character
      return fiveStarFeaturedCharacters[_random.nextInt(fiveStarFeaturedCharacters.length)];
    } else {
      // Lost 50/50 - standard pool (mix of characters and weapons)
      final pool = [...fiveStarStandardCharacters, ...fiveStarWeapons];
      return pool[_random.nextInt(pool.length)];
    }
  }
}

