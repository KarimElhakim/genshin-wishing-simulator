import 'dart:convert';
import 'package:http/http.dart' as http;

/// Enka.Network API Service
/// Official API Documentation: https://api.enka.network/#/api
/// GitHub Store: https://github.com/EnkaNetwork/API-docs/tree/master/store/gi
/// Provides: Characters, Weapons, Artifacts with official assets
class EnkaNetworkService {
  static const String storeBase = 'https://raw.githubusercontent.com/EnkaNetwork/API-docs/master/store';
  static const String uiBase = 'https://enka.network/ui';
  
  final http.Client _client;
  
  // Cached data
  Map<String, dynamic>? _charactersCache;
  Map<String, dynamic>? _localizationCache;
  Map<String, dynamic>? _weaponsCache;

  EnkaNetworkService({http.Client? client}) : _client = client ?? http.Client();

  /// Get all characters from Enka.Network store
  Future<List<EnkaCharacter>> getAllCharacters() async {
    try {
      // Load characters data from GitHub
      if (_charactersCache == null) {
        final response = await _client.get(
          Uri.parse('$storeBase/gi/avatars.json'),
        ).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          _charactersCache = json.decode(response.body);
        } else {
          throw Exception('Failed to load characters: ${response.statusCode}');
        }
      }

      // Load localization
      if (_localizationCache == null) {
        final locResponse = await _client.get(
          Uri.parse('$storeBase/loc.json'),
        ).timeout(const Duration(seconds: 20));

        if (locResponse.statusCode == 200) {
          _localizationCache = json.decode(locResponse.body);
        } else {
          throw Exception('Failed to load localization');
        }
      }

      // Parse characters
      final List<EnkaCharacter> characters = [];
      final englishLoc = _localizationCache!['en'] as Map<String, dynamic>;

      _charactersCache!.forEach((characterId, data) {
        try {
          // Skip trial characters (IDs with dashes like 10000117-11702)
          if (characterId.toString().contains('-')) {
            return;
          }
          
          // Skip Traveler variants (handled separately)
          if (characterId.startsWith('10000005') || characterId.startsWith('10000007')) {
            return;
          }
          
          // Only include playable characters (ID range 10000002-10000116)
          final id = int.tryParse(characterId);
          if (id == null || id < 10000002 || id > 10000116) {
            return;
          }

          final nameHash = data['NameTextMapHash']?.toString();
          String characterName = 'Unknown';
          
          if (nameHash != null && englishLoc.containsKey(nameHash)) {
            characterName = englishLoc[nameHash];
          }

          // Parse rarity (QUALITY_PURPLE = 4*, QUALITY_ORANGE = 5*)
          int rarity = 4;
          if (data['QualityType'] == 'QUALITY_ORANGE' || data['QualityType'] == 'QUALITY_ORANGE_SP') {
            rarity = 5;
          }

          // Parse element
          String element = _parseElement(data['Element']);

          // Parse weapon type
          String weaponType = _parseWeaponType(data['WeaponType']);

          // Get icon names
          String sideIcon = data['SideIconName'] ?? '';
          String iconName = data['IconName'] ?? '';

          // Parse constellations
          List<String> constellationIcons = [];
          if (data['Consts'] != null) {
            constellationIcons = List<String>.from(data['Consts']);
          }

          // Parse skills
          Map<String, String> skills = {};
          if (data['Skills'] != null) {
            skills = Map<String, String>.from(data['Skills']);
          }

          // Parse costs (ascension materials)
          Map<String, dynamic> costs = {};
          if (data['Costs'] != null) {
            costs = Map<String, dynamic>.from(data['Costs']);
          }

          characters.add(EnkaCharacter(
            id: characterId,
            name: characterName,
            element: element,
            weaponType: weaponType,
            rarity: rarity,
            sideIconName: sideIcon,
            iconName: iconName,
            constellationIcons: constellationIcons,
            skillsMap: skills,
            costsMap: costs,
          ));
        } catch (e) {
          print('Error parsing character $characterId: $e');
        }
      });

      // Add Travelers
      characters.addAll(_getTravelers(englishLoc));

      // Sort by rarity (5* first) then name
      characters.sort((a, b) {
        if (a.rarity != b.rarity) return b.rarity.compareTo(a.rarity);
        return a.name.compareTo(b.name);
      });

      return characters;
    } catch (e) {
      throw Exception('Error fetching characters from Enka.Network: $e');
    }
  }

  /// Get weapons data
  Future<List<EnkaWeapon>> getAllWeapons() async {
    // Weapons endpoint might not be available, return empty for now
    // Can be implemented if needed
    return [];
  }

  String _parseElement(dynamic element) {
    if (element == null) return 'Unknown';
    switch (element.toString()) {
      case 'Fire': return 'Pyro';
      case 'Water': return 'Hydro';
      case 'Electric': return 'Electro';
      case 'Ice': return 'Cryo';
      case 'Wind': return 'Anemo';
      case 'Rock': return 'Geo';
      case 'Grass': return 'Dendro';
      default: return element.toString();
    }
  }

  String _parseWeaponType(dynamic weaponType) {
    if (weaponType == null) return 'Unknown';
    switch (weaponType.toString()) {
      case 'WEAPON_SWORD_ONE_HAND': return 'Sword';
      case 'WEAPON_CLAYMORE': return 'Claymore';
      case 'WEAPON_POLE': return 'Polearm';
      case 'WEAPON_BOW': return 'Bow';
      case 'WEAPON_CATALYST': return 'Catalyst';
      default: return weaponType.toString();
    }
  }

  List<EnkaCharacter> _getTravelers(Map<String, dynamic> englishLoc) {
    return [
      EnkaCharacter(
        id: '10000005',
        name: 'Traveler (Aether)',
        element: 'Anemo',
        weaponType: 'Sword',
        rarity: 5,
        sideIconName: 'UI_AvatarIcon_Side_PlayerBoy',
        iconName: 'UI_AvatarIcon_PlayerBoy',
      ),
      EnkaCharacter(
        id: '10000007',
        name: 'Traveler (Lumine)',
        element: 'Anemo',
        weaponType: 'Sword',
        rarity: 5,
        sideIconName: 'UI_AvatarIcon_Side_PlayerGirl',
        iconName: 'UI_AvatarIcon_PlayerGirl',
      ),
    ];
  }

  void dispose() {
    _client.close();
  }
}

/// Enka Character Model
class EnkaCharacter {
  final String id;
  final String name;
  final String element;
  final String weaponType;
  final int rarity;
  final String sideIconName;
  final String iconName;
  final List<String> constellationIcons;
  final Map<String, String> skillsMap;
  final Map<String, dynamic> costsMap;

  EnkaCharacter({
    required this.id,
    required this.name,
    required this.element,
    required this.weaponType,
    required this.rarity,
    required this.sideIconName,
    required this.iconName,
    this.constellationIcons = const [],
    this.skillsMap = const {},
    this.costsMap = const {},
  });

  // Asset URLs using Enka.Network CDN
  String get iconUrl => 'https://enka.network/ui/$iconName.png';
  String get sideIconUrl => 'https://enka.network/ui/$sideIconName.png';
  String get portraitUrl => iconUrl;
  
  // For gacha cards, use side icon (better quality)
  String get gachaCardUrl => sideIconUrl;
  
  // Get constellation icon URLs
  List<String> get constellationUrls => constellationIcons
      .map((icon) => 'https://enka.network$icon')
      .toList();
  
  // Get skill icon URLs
  List<String> get skillIconUrls => skillsMap.values
      .map((icon) => 'https://enka.network$icon')
      .toList();
}

/// Enka Weapon Model
class EnkaWeapon {
  final String id;
  final String name;
  final String iconName;
  final int rarity;

  EnkaWeapon({
    required this.id,
    required this.name,
    required this.iconName,
    required this.rarity,
  });

  String get iconUrl => 'https://enka.network/ui/$iconName.png';
}

