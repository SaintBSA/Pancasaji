import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'resep_detail_page.dart';

class ResepPage extends StatefulWidget {
  const ResepPage({super.key});

  @override
  State<ResepPage> createState() => _ResepPageState();
}

class _ResepPageState extends State<ResepPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allRecipes = [
    {
      'title': 'Grilled Beef & Broccoli Rice',
      'duration': '15 Minutes',
      'bahan': [
        '150g white rice',
        '150g beef tenderloin (sliced wide and thin)',
        '100g broccoli (cut into florets)',
        '3g salt',
        '2g black pepper',
        '10ml cooking oil',
      ],
      'langkah': [
        'Boil water in a small pot.',
        'Put broccoli in boiling water for 3 minutes.',
        'Drain the broccoli and sprinkle with 1g of salt.',
        'Coat the beef with 2g of salt and 2g of black pepper.',
        'Heat the pan with 10ml of cooking oil.',
        'Grill the beef for 2 minutes on each side until cooked.',
        'Place the rice, beef, and broccoli separately on a plate.',
      ],
    },
    {
      'title': 'Ginger Chicken & Stir-fried Cabbage Rice',
      'duration': '15 Minutes',
      'bahan': [
        '150g white rice',
        '150g chicken breast (cut lengthwise)',
        '120g cabbage (cut into large cubes)',
        '5g ginger (finely chopped)',
        '3g salt',
        '5ml coconut oil',
      ],
      'langkah': [
        'Heat 2ml of coconut oil in a pan.',
        'Add cabbage and 1g of salt to the pan.',
        'Stir-fry cabbage until wilted, then set aside on a plate.',
        'Clean the pan, heat the remaining 3ml of coconut oil.',
        'Stir-fry chopped ginger until fragrant.',
        'Add chicken pieces and 2g of salt.',
        'Cook chicken until it changes color and is fully cooked.',
        'Serve chicken and rice alongside the set-aside cabbage.',
      ],
    },
    {
      'title': 'Fried Egg Rice & Fresh Salad',
      'duration': '10 Minutes',
      'bahan': [
        '150g white rice',
        '110g chicken eggs (2 pcs)',
        '60g tomatoes (sliced round)',
        '60g cucumber (sliced round)',
        '2g salt',
        '1g white pepper',
      ],
      'langkah': [
        'Heat a little oil in a flat pan.',
        'Crack the eggs one by one to make sunny-side up eggs.',
        'Sprinkle salt on the eggs while cooking.',
        'Remove the eggs once the desired doneness is reached.',
        'Slice tomatoes and cucumbers circularly.',
        'Sprinkle the sliced vegetables with a little white pepper.',
        'Arrange the rice, eggs, and sliced vegetables in different areas of the plate.',
      ],
    },
    {
      'title': 'Pepper Beef & Lettuce Rice',
      'duration': '12 Minutes',
      'bahan': [
        '150g white rice',
        '130g beef (cut into 2cm cubes)',
        '80g lettuce (whole leaves)',
        '3g salt',
        '3g white pepper',
        '5ml cooking oil',
      ],
      'langkah': [
        'Wash the lettuce leaves thoroughly and drain the water.',
        'Heat 5ml of oil in a pan over medium heat.',
        'Add the diced beef.',
        'Add salt and white pepper to the pan.',
        'Cook the meat while stirring until evenly cooked on all sides.',
        'Place the lettuce on a third of the plate.',
        'Place the rice and beef in the remaining empty areas of the plate.',
      ],
    },
    {
      'title': 'Steamed Chicken & Garlic Broccoli Rice',
      'duration': '25 Minutes',
      'bahan': [
        '150g white rice',
        '150g chicken breast (whole)',
        '100g broccoli (cut into small pieces)',
        '5g garlic (finely chopped)',
        '4g salt',
      ],
      'langkah': [
        'Coat the chicken breast with 2g of salt evenly.',
        'Prepare a steamer and wait until the water boils.',
        'Steam the chicken breast for 15-20 minutes until cooked.',
        'Stir-fry chopped garlic with a little oil until yellow.',
        'Add broccoli and a little water to the garlic stir-fry.',
        'Add 2g of salt and cook until the broccoli is tender.',
        'Slice the cooked steamed chicken.',
        'Serve the rice, chicken slices, and broccoli side by side.',
      ],
    },
    {
      'title': 'Boiled Egg & Stir-fried Tomato Rice',
      'duration': '15 Minutes',
      'bahan': [
        '150g white rice',
        '110g chicken eggs (2 pcs)',
        '150g red tomatoes (cut into 4)',
        '3g salt',
        '2g sugar',
      ],
      'langkah': [
        'Boil eggs in boiling water for 9-10 minutes.',
        'While waiting for the eggs, heat a little oil in a pan.',
        'Add the tomato pieces to the pan.',
        'Add salt and sugar to the tomato stir-fry.',
        'Cook until the tomatoes soften and release their juices, then remove.',
        'Peel the cooked boiled eggs under running water.',
        'Cut the eggs into two parts.',
        'Arrange the rice, stir-fried tomatoes, and boiled eggs on a plate.',
      ],
    },
    {
      'title': 'Boiled Beef & Cabbage Rice',
      'duration': '10 Minutes',
      'bahan': [
        '150g white rice',
        '120g sliced beef',
        '100g cabbage (sliced wide)',
        '3g salt',
        '2g pepper',
      ],
      'langkah': [
        'Boil 500ml of water in a pot.',
        'Put the sliced cabbage into the boiling water.',
        'Cook the cabbage for 2 minutes until wilted, then drain onto a plate.',
        'Put the sliced beef into the same boiling water.',
        'Boil the beef for 1 minute until it changes color, then drain.',
        'Sprinkle salt and pepper on the boiled beef and cabbage.',
        'Place the white rice next to the beef and cabbage.',
      ],
    },
    {
      'title': 'Grilled Chicken & Cucumber Rice',
      'duration': '15 Minutes',
      'bahan': [
        '150g white rice',
        '150g chicken thigh fillet',
        '100g cucumber (cut into sticks)',
        '3g salt',
        '2g pepper',
        '5ml cooking oil',
      ],
      'langkah': [
        'Dry the surface of the chicken with a paper towel.',
        'Coat the chicken with salt and pepper.',
        'Heat oil in a non-stick pan.',
        'Grill the chicken with the skin side down first.',
        'Flip the chicken and cook until both sides are browned and cooked.',
        'Cut the cucumber into long stick shapes.',
        'Slice the grilled chicken into several parts.',
        'Arrange the rice in the middle, chicken on the right, and cucumber on the left.',
      ],
    },
    {
      'title': 'Omelet & Steamed Broccoli Rice',
      'duration': '12 Minutes',
      'bahan': [
        '150g white rice',
        '110g chicken eggs (2 pcs)',
        '120g broccoli (cut into florets)',
        '3g salt',
        '5ml cooking oil',
      ],
      'langkah': [
        'Steam the broccoli for 5 minutes until cooked, then set aside.',
        'Crack the eggs into a bowl and add salt.',
        'Beat the eggs until well mixed.',
        'Heat oil in a wide flat pan.',
        'Pour in the eggs and cook until done on both sides.',
        'Fold the omelet into a square or roll shape.',
        'Place the rice on one side of the plate.',
        'Place the omelet and broccoli in the empty areas of the plate.',
      ],
    },
    {
      'title': 'Stir-fried Beef & Tomato Salad Rice',
      'duration': '12 Minutes',
      'bahan': [
        '150g white rice',
        '130g beef (thinly sliced)',
        '50g lettuce (roughly torn)',
        '50g tomatoes (sliced round)',
        '3g salt',
        '2g black pepper',
      ],
      'langkah': [
        'Prepare a plate, arrange the lettuce and tomatoes on one part of the plate.',
        'Heat a little oil in a pan over high heat.',
        'Add the sliced beef.',
        'Add salt and black pepper.',
        'Stir-fry the beef quickly until it changes color and is cooked.',
        'Remove the meat and place it on a different part of the plate from the vegetables.',
        'Add white rice to complete the plate.',
      ],
    },
  ];

  List<Map<String, dynamic>> _foundRecipes = [];

  Set<String> _favoriteRecipeTitles = {};
  bool _showFavoritesOnly = false;

  final Color bgColor = const Color(0xFF2B2A33);
  final Color cardColor = const Color(0xFF1F1E26);
  final Color searchBoxColor = const Color(0xFF3B3A44);
  final Color textMuted = const Color(0xFF8E8D96);
  final Color iconYellow = const Color(0xFFFFD15C);

  @override
  void initState() {
    super.initState();
    _foundRecipes = _allRecipes;
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedFavorites = prefs.getStringList('my_favorites');

    if (savedFavorites != null) {
      setState(() {
        _favoriteRecipeTitles = savedFavorites.toSet();
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('my_favorites', _favoriteRecipeTitles.toList());
  }

  void _runFilter() {
    List<Map<String, dynamic>> results = [];
    String enteredKeyword = _searchController.text.toLowerCase();

    results = _allRecipes.where((recipe) {
      bool matchesKeyword = true;
      if (enteredKeyword.isNotEmpty) {
        List<String> keywords = enteredKeyword.split(' ');
        String title = recipe['title'].toString().toLowerCase();
        matchesKeyword = keywords.every((kw) => title.contains(kw));
      }

      bool matchesFavorite = true;
      if (_showFavoritesOnly) {
        matchesFavorite = _favoriteRecipeTitles.contains(recipe['title']);
      }

      return matchesKeyword && matchesFavorite;
    }).toList();

    setState(() {
      _foundRecipes = results;
    });
  }

  void _toggleFavorite(String title) {
    setState(() {
      if (_favoriteRecipeTitles.contains(title)) {
        _favoriteRecipeTitles.remove(title);
      } else {
        _favoriteRecipeTitles.add(title);
      }

      if (_showFavoritesOnly) {
        _runFilter();
      }
    });

    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    Material(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: _showFavoritesOnly
                            ? BorderSide(color: iconYellow, width: 1.5)
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showFavoritesOnly = !_showFavoritesOnly;
                            _runFilter();
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _showFavoritesOnly
                                    ? Icons.bookmark
                                    : Icons.bookmark_border_rounded,
                                color: iconYellow,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Favorite',
                                style: TextStyle(
                                  fontFamily: 'nunito',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: searchBoxColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(),
                    style: const TextStyle(
                      fontFamily: 'nunito',
                      color: Colors.white,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                        child: Icon(
                          Icons.search_rounded,
                          color: textMuted,
                          size: 24,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 40),
                      hintText: 'Type recipe keyword',
                      hintStyle: TextStyle(
                        fontFamily: 'nunito',
                        color: textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        top: 14,
                        bottom: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: _foundRecipes.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: _foundRecipes.length,
                        itemBuilder: (context, index) {
                          return _buildRecipeCard(
                            context,
                            _foundRecipes[index],
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          _showFavoritesOnly
                              ? 'No favorite recipes yet'
                              : 'Recipe not found',
                          style: TextStyle(
                            fontFamily: 'nunito',
                            fontSize: 14,
                            color: textMuted,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    bool isFavorited = _favoriteRecipeTitles.contains(recipe['title']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResepDetailPage(
                  title: recipe['title'],
                  duration: recipe['duration'],
                  bahan: List<String>.from(recipe['bahan'] ?? []),
                  langkah: List<String>.from(recipe['langkah'] ?? []),
                  initialFavorite: isFavorited,
                  onFavoriteToggle: () {
                    _toggleFavorite(recipe['title']);
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _toggleFavorite(recipe['title']),
                  child: Icon(
                    isFavorited
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    color: iconYellow,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['title'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'nunito',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recipe['duration'],
                        style: TextStyle(
                          fontFamily: 'nunito',
                          color: textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: textMuted, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}