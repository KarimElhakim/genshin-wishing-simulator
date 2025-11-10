import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../utils/character_icon_mapper.dart';

class CharacterModel extends Equatable {
  final String name;
  final String vision;
  final String weapon;
  final int rarity;
  final String? nation;
  final String? description;
  final List<Constellation>? constellations;
  final List<SkillTalent>? skillTalents;
  final List<PassiveTalent>? passiveTalents;

  const CharacterModel({
    required this.name,
    required this.vision,
    required this.weapon,
    required this.rarity,
    this.nation,
    this.description,
    this.constellations,
    this.skillTalents,
    this.passiveTalents,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'] ?? '',
      vision: json['vision'] ?? json['vision_key'] ?? '',
      weapon: json['weapon'] ?? json['weapon_type'] ?? '',
      rarity: json['rarity'] ?? 4,
      nation: json['nation'] ?? json['region'] ?? '',
      description: json['description'] ?? '',
      constellations: (json['constellations'] as List?)
          ?.map((c) => Constellation.fromJson(c))
          .toList(),
      skillTalents: (json['skillTalents'] as List?)
          ?.map((s) => SkillTalent.fromJson(s))
          .toList(),
      passiveTalents: (json['passiveTalents'] as List?)
          ?.map((p) => PassiveTalent.fromJson(p))
          .toList(),
    );
  }

  String getPortraitUrl() {
    // Using Enka.Network CDN - reliable official assets
    final iconName = _getEnkaIconName();
    return 'https://enka.network/ui/$iconName.png';
  }

  String getIconUrl() {
    final iconName = _getEnkaIconName();
    return 'https://enka.network/ui/$iconName.png';
  }

  String getCardUrl() {
    // Use GACHA CARDS for beautiful full character art
    final id = _getCharacterId();
    return 'https://enka.network/ui/UI_Gacha_AvatarImg_$id.png';
  }
  
  String getGachaArtUrl() {
    // Use GACHA CARDS for wish pulls
    final id = _getCharacterId();
    return 'https://enka.network/ui/UI_Gacha_AvatarImg_$id.png';
  }
  
  String _getEnkaIconName() {
    // Use the same mapping as _getCharacterId but with UI_AvatarIcon_ prefix
    final id = _getCharacterId();
    return 'UI_AvatarIcon_$id';
  }
  
  String _getEnkaSideIconName() {
    final iconName = _getEnkaIconName();
    return iconName.replaceFirst('UI_AvatarIcon_', 'UI_AvatarIcon_Side_');
  }
  
  String _getCharacterId() {
    return CharacterIconMapper.getIconId(name);
  }

  Color getElementColor() {
    switch (vision.toLowerCase()) {
      case 'pyro':
        return const Color(0xFFFF6B3D);
      case 'hydro':
        return const Color(0xFF4CC2F1);
      case 'electro':
        return const Color(0xFFB085F5);
      case 'cryo':
        return const Color(0xFF9FD7E6);
      case 'anemo':
        return const Color(0xFF74C2A8);
      case 'geo':
        return const Color(0xFFFAB632);
      case 'dendro':
        return const Color(0xFF9FE72D);
      default:
        return const Color(0xFF888888);
    }
  }

  @override
  List<Object?> get props => [
        name,
        vision,
        weapon,
        rarity,
        nation,
        description,
        constellations,
        skillTalents,
        passiveTalents,
      ];
}

class Constellation extends Equatable {
  final String name;
  final String description;
  final String? icon;
  final String? unlock;
  final int? level;

  const Constellation({
    required this.name,
    required this.description,
    this.icon,
    this.unlock,
    this.level,
  });

  factory Constellation.fromJson(Map<String, dynamic> json) {
    // Extract level from unlock string like "Constellation Lv. 1"
    final unlockStr = json['unlock'] ?? '';
    final levelMatch = RegExp(r'(\d+)').firstMatch(unlockStr);
    final level = levelMatch != null ? int.parse(levelMatch.group(1)!) : 0;

    return Constellation(
      name: json['name'] ?? '',
      unlock: json['unlock'] ?? '',
      description: json['description'] ?? '',
      level: level,
      icon: json['icon'],
    );
  }

  @override
  List<Object?> get props => [name, unlock, description, level, icon];
}

class SkillTalent extends Equatable {
  final String name;
  final String description;
  final String? icon;
  final String? unlock;
  final String? type;

  const SkillTalent({
    required this.name,
    required this.description,
    this.icon,
    this.unlock,
    this.type,
  });

  factory SkillTalent.fromJson(Map<String, dynamic> json) {
    return SkillTalent(
      name: json['name'] ?? '',
      unlock: json['unlock'] ?? '',
      description: json['description'] ?? '',
      type: json['type'],
      icon: json['icon'],
    );
  }

  @override
  List<Object?> get props => [name, unlock, description, type, icon];
}

class PassiveTalent extends Equatable {
  final String name;
  final String description;
  final String? unlock;

  const PassiveTalent({
    required this.name,
    required this.description,
    this.unlock,
  });

  factory PassiveTalent.fromJson(Map<String, dynamic> json) {
    return PassiveTalent(
      name: json['name'] ?? '',
      unlock: json['unlock'] ?? '',
      description: json['description'] ?? '',
    );
  }

  @override
  List<Object?> get props => [name, unlock, description];
}

