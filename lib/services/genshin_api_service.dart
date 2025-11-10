import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import 'enka_network_service.dart';

class GenshinApiService {
  final EnkaNetworkService _enkaService;
  
  final http.Client _client;
  List<EnkaCharacter>? _cachedCharacters;

  GenshinApiService({http.Client? client}) 
    : _client = client ?? http.Client(),
      _enkaService = EnkaNetworkService(client: client);

  /// Get all character names
  Future<List<String>> getAllCharacterNames() async {
    final characters = await _getEnkaCharacters();
    return characters.map((char) => char.name).toList();
  }

  /// Get specific character details
  Future<CharacterModel> getCharacter(String characterName) async {
    final characters = await _getEnkaCharacters();
    final enkaChar = characters.firstWhere(
      (char) => char.name.toLowerCase() == characterName.toLowerCase(),
      orElse: () => characters.first,
    );
    
    return _convertToCharacterModel(enkaChar);
  }

  /// Get all characters with full details
  Future<List<CharacterModel>> getAllCharacters() async {
    final enkaCharacters = await _getEnkaCharacters();
    return enkaCharacters.map(_convertToCharacterModel).toList();
  }

  /// Get cached Enka characters
  Future<List<EnkaCharacter>> _getEnkaCharacters() async {
    if (_cachedCharacters == null) {
      _cachedCharacters = await _enkaService.getAllCharacters();
    }
    return _cachedCharacters!;
  }

  /// Convert Enka character to app model
  CharacterModel _convertToCharacterModel(EnkaCharacter enkaChar) {
    // Convert constellation icons to Constellation models
    final constellations = enkaChar.constellationUrls.asMap().entries.map((entry) {
      return Constellation(
        name: 'Constellation ${entry.key + 1}',
        description: 'Unlocked at C${entry.key + 1}',
        icon: entry.value,
      );
    }).toList();

    // Convert skills to SkillTalent models
    final skills = enkaChar.skillIconUrls.asMap().entries.map((entry) {
      final skillNames = ['Normal Attack', 'Elemental Skill', 'Elemental Burst'];
      final skillName = entry.key < skillNames.length ? skillNames[entry.key] : 'Talent ${entry.key + 1}';
      return SkillTalent(
        name: skillName,
        description: '${skillName} for ${enkaChar.name}',
        icon: entry.value,
      );
    }).toList();

    return CharacterModel(
      name: enkaChar.name,
      vision: enkaChar.element,
      weapon: enkaChar.weaponType,
      rarity: enkaChar.rarity,
      nation: _getNationFromElement(enkaChar.element),
      description: 'A ${enkaChar.rarity}★ ${enkaChar.element} ${enkaChar.weaponType} user. Playable character in Genshin Impact.',
      constellations: constellations,
      skillTalents: skills,
      passiveTalents: [
        PassiveTalent(
          name: 'Ascension 1 Passive',
          description: 'Unlocked at Ascension 1',
        ),
        PassiveTalent(
          name: 'Ascension 4 Passive',
          description: 'Unlocked at Ascension 4',
        ),
      ],
    );
  }

  String? _getNationFromElement(String element) {
    // This is a simplified mapping - Enka doesn't provide nation directly
    switch (element) {
      case 'Anemo':
        return 'Mondstadt';
      case 'Geo':
        return 'Liyue';
      case 'Electro':
        return 'Inazuma';
      case 'Dendro':
        return 'Sumeru';
      case 'Hydro':
        return 'Fontaine';
      default:
        return null;
    }
  }

  /// Get nations list
  Future<List<String>> getNations() async {
    return ['Mondstadt', 'Liyue', 'Inazuma', 'Sumeru', 'Fontaine', 'Natlan'];
  }

  /// Get elements list
  List<String> getElements() {
    return ['Pyro', 'Hydro', 'Electro', 'Cryo', 'Anemo', 'Geo', 'Dendro'];
  }

  /// Get weapon types
  List<String> getWeaponTypes() {
    return ['Sword', 'Claymore', 'Polearm', 'Bow', 'Catalyst'];
  }

  void dispose() {
    _client.close();
  }
}

