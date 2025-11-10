import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/character_model.dart';
import '../services/genshin_api_service.dart';
import 'character_detail_screen.dart';

class CharactersListScreen extends StatefulWidget {
  final GenshinApiService apiService;
  
  const CharactersListScreen({super.key, required this.apiService});

  @override
  State<CharactersListScreen> createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  late Future<List<CharacterModel>> _charactersFuture;
  List<CharacterModel> _allCharacters = [];
  List<CharacterModel> _filteredCharacters = [];
  String _searchQuery = '';
  String? _selectedElement;
  int? _selectedRarity;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  void _loadCharacters() {
    _charactersFuture = widget.apiService.getAllCharacters().then((characters) {
      setState(() {
        _allCharacters = characters;
        _filteredCharacters = characters;
      });
      return characters;
    });
  }

  void _filterCharacters() {
    setState(() {
      _filteredCharacters = _allCharacters.where((character) {
        // Search query filter
        if (_searchQuery.isNotEmpty &&
            !character.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
        
        // Element filter
        if (_selectedElement != null &&
            character.vision.toLowerCase() != _selectedElement!.toLowerCase()) {
          return false;
        }
        
        // Rarity filter
        if (_selectedRarity != null && character.rarity != _selectedRarity) {
          return false;
        }
        
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCharacters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _filterCharacters();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search characters...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Filters Row
                Row(
                  children: [
                    Expanded(
                      child: _buildElementFilter(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRarityFilter(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Characters Grid
          Expanded(
            child: FutureBuilder<List<CharacterModel>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingGrid();
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading characters',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your internet connection',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadCharacters,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (_filteredCharacters.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No characters found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredCharacters.length,
                  itemBuilder: (context, index) {
                    return _buildCharacterCard(_filteredCharacters[index])
                        .animate()
                        .fadeIn(duration: 400.ms, delay: (50 * index).ms)
                        .slideY(begin: 0.2, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementFilter() {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_alt, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedElement ?? 'Element',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('All Elements')),
        ...['Pyro', 'Hydro', 'Electro', 'Cryo', 'Anemo', 'Geo', 'Dendro']
            .map((element) => PopupMenuItem(
                  value: element,
                  child: Text(element),
                ))
            .toList(),
      ],
      onSelected: (value) {
        setState(() {
          _selectedElement = value;
        });
        _filterCharacters();
      },
    );
  }

  Widget _buildRarityFilter() {
    return PopupMenuButton<int>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedRarity != null ? '$_selectedRarity★' : 'Rarity',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('All Rarities')),
        const PopupMenuItem(value: 5, child: Text('5★')),
        const PopupMenuItem(value: 4, child: Text('4★')),
      ],
      onSelected: (value) {
        setState(() {
          _selectedRarity = value;
        });
        _filterCharacters();
      },
    );
  }

  Widget _buildCharacterCard(CharacterModel character) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(character: character),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              character.getElementColor().withOpacity(0.3),
              Theme.of(context).cardColor,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: character.getElementColor().withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Character Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: CachedNetworkImage(
                  imageUrl: character.getCardUrl(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: character.getElementColor().withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: character.getElementColor().withOpacity(0.2),
                    child: const Icon(Icons.person, size: 64),
                  ),
                ),
              ),
            ),
            
            // Character Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Element and Rarity
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: character.getElementColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          character.vision,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(
                        character.rarity,
                        (index) => const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFFFB84D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

