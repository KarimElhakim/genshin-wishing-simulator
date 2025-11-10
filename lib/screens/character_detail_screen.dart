import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/character_model.dart';

class GachaProbabilityInfo {
  final int rarity;
  GachaProbabilityInfo({required this.rarity});
  String get baseRate => rarity == 5 ? '0.6' : '5.1';
  int get softPity => rarity == 5 ? 74 : 9;
  int get hardPity => rarity == 5 ? 90 : 10;
  String getExpectedPulls(bool guaranteed) => rarity == 5 
      ? (guaranteed ? '~180 pulls' : '~90 pulls') 
      : (guaranteed ? '~20 pulls' : '~10 pulls');
}

class CharacterDetailScreen extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Character Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                character.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 10),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: character.getCardUrl(),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: character.getElementColor().withOpacity(0.3),
                      child: const Icon(Icons.person, size: 100),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Character Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info Card
                  _buildInfoCard(context),
                  const SizedBox(height: 16),
                  
                  // Gacha Probability Card
                  _buildGachaProbabilityCard(context),
                  const SizedBox(height: 16),
                  
                  // Description
                  if (character.description != null) ...[
                    _buildSectionTitle(context, 'Description'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          character.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Constellations
                  if (character.constellations != null &&
                      character.constellations!.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Constellations'),
                    ...character.constellations!.map((constellation) =>
                        _buildConstellationCard(context, constellation)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: -0.2, end: 0)),
                    const SizedBox(height: 16),
                  ],
                  
                  // Skills/Talents
                  if (character.skillTalents != null &&
                      character.skillTalents!.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Skills & Talents'),
                    ...character.skillTalents!.map((skill) =>
                        _buildSkillCard(context, skill)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.2, end: 0)),
                    const SizedBox(height: 16),
                  ],
                  
                  // Passive Talents
                  if (character.passiveTalents != null &&
                      character.passiveTalents!.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Passive Talents'),
                    ...character.passiveTalents!.map((passive) =>
                        _buildPassiveCard(context, passive)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: -0.2, end: 0)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.wb_sunny,
                  label: 'Element',
                  value: character.vision,
                  color: character.getElementColor(),
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.star,
                  label: 'Rarity',
                  value: '${'★' * character.rarity}',
                  color: const Color(0xFFFFB84D),
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.shield,
                  label: 'Weapon',
                  value: character.weapon,
                  color: Colors.blue,
                ),
              ],
            ),
            if (character.nation != null) ...[
              const Divider(height: 32),
              _buildInfoItem(
                context,
                icon: Icons.location_on,
                label: 'Nation',
                value: character.nation!,
                color: Colors.purple,
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale();
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white60,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: character.getElementColor(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildConstellationCard(
      BuildContext context, Constellation constellation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Constellation Icon
            if (constellation.icon != null)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      character.getElementColor().withOpacity(0.3),
                      character.getElementColor().withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: character.getElementColor(), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: constellation.icon!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: character.getElementColor(),
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.stars,
                      color: character.getElementColor(),
                      size: 30,
                    ),
                  ),
                ),
              ),
            if (constellation.icon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    constellation.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    constellation.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(BuildContext context, SkillTalent skill) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skill Icon
            if (skill.icon != null)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      character.getElementColor().withOpacity(0.3),
                      character.getElementColor().withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: character.getElementColor(), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: skill.icon!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: character.getElementColor(),
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.flash_on,
                      color: character.getElementColor(),
                      size: 30,
                    ),
                  ),
                ),
              ),
            if (skill.icon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    skill.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassiveCard(BuildContext context, PassiveTalent passive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              passive.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (passive.unlock != null) ...[
              const SizedBox(height: 4),
              Text(
                passive.unlock!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: character.getElementColor(),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              passive.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGachaProbabilityCard(BuildContext context) {
    final gachaInfo = GachaProbabilityInfo(rarity: character.rarity);
    
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              character.getElementColor().withOpacity(0.2),
              Theme.of(context).cardColor,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.casino, color: character.getElementColor()),
                const SizedBox(width: 12),
                Text(
                  'Gacha Probability',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            _buildProbRow('Base Rate', '${gachaInfo.baseRate}% per wish'),
            _buildProbRow('Soft Pity', 'Starts at pull ${gachaInfo.softPity}'),
            _buildProbRow('Hard Pity', 'Guaranteed at pull ${gachaInfo.hardPity}'),
            _buildProbRow('Expected Pulls', gachaInfo.getExpectedPulls(false)),
            _buildProbRow('With Guarantee', gachaInfo.getExpectedPulls(true)),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: character.getElementColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: character.getElementColor().withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: character.getElementColor(), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      character.rarity == 5
                          ? 'Featured 5★ has 50% chance. Guaranteed after losing 50/50.'
                          : 'Featured 4★ has 50% chance on 4-star pulls.',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0);
  }
  
  Widget _buildProbRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

