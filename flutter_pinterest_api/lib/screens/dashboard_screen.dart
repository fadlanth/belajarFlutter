import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fabAnimationController;
  late AnimationController _searchAnimationController;
  late AnimationController _filterAnimationController;
  late AnimationController _refreshAnimationController;
  late ScrollController _scrollController;

  // State variables
  bool _isSearching = false;
  bool _showFilterOptions = false;
  bool _isDarkMode = true;
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _sortBy = 'Populer';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Categories
  final List<String> _categories = [
    'Semua',
    'Alam',
    'Perjalanan',
    'Arsitektur',
    'Makanan',
    'Seni',
    'Fashion',
    'Teknologi',
    'Olahraga',
    'Hewan',
    'Musik',
    'Film',
  ];

  /// Daftar data Pins
  final List<Map<String, String>> pins = const [
    // 🌄 Alam
    {
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'title': 'Pemandangan Gunung Berkabut',
      'user': 'Eleanor',
      'category': 'Alam',
      'likes': '342',
      'comments': '28',
      'description':
          'Pemandangan gunung yang menakjubkan dengan kabut tebal yang menyelimuti puncaknya.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=800&q=80',
      'title': 'Pemandangan Pegunungan',
      'user': 'Oliver',
      'category': 'Alam',
      'likes': '527',
      'comments': '41',
      'description':
          'Pegunungan yang megah dengan pemandangan alam yang masih asri.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=800&q=80',
      'title': 'Matahari Terbenam',
      'user': 'Sophia',
      'category': 'Alam',
      'likes': '893',
      'comments': '76',
      'description':
          'Matahari terbenam yang memukau dengan warna emas yang membiaskan langit.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1468071174046-657d9d351a40?auto=format&fit=crop&w=800&q=80',
      'title': 'Danau Tenang',
      'user': 'Mia',
      'category': 'Alam',
      'likes': '672',
      'comments': '54',
      'description':
          'Danau yang jernih dengan air yang tenang memantulkan langit biru.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
      'title': 'Bunga Liar',
      'user': 'Ava',
      'category': 'Alam',
      'likes': '756',
      'comments': '62',
      'description': 'Bunga-bunga liar yang mekar di padang rumput hijau.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=800&q=80',
      'title': 'Pegunungan Megah',
      'user': 'William',
      'category': 'Alam',
      'likes': '945',
      'comments': '87',
      'description': 'Pegunungan yang megah dengan puncak yang tertutup salju.',
    },

    // 🧭 Perjalanan
    {
      'image':
          'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
      'title': 'Gurun Pasir',
      'user': 'Liam',
      'category': 'Perjalanan',
      'likes': '415',
      'comments': '33',
      'description':
          'Gurun yang luas dengan bukit pasir yang membentang tak terbatas.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
      'title': 'Jalan Berliku',
      'user': 'Noah',
      'category': 'Perjalanan',
      'likes': '389',
      'comments': '31',
      'description':
          'Jalan pegunungan yang berliku dengan pemandangan yang menakjubkan.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1529655683826-aba9b3e77383?auto=format&fit=crop&w=800&q=80',
      'title': 'Pantai Tropis',
      'user': 'Sophie',
      'category': 'Perjalanan',
      'likes': '1123',
      'comments': '98',
      'description': 'Pantai tropis dengan pasir putih dan air yang jernih.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=800&q=80',
      'title': 'Perjalanan Petualangan',
      'user': 'Dakota',
      'category': 'Perjalanan',
      'likes': '945',
      'comments': '82',
      'description':
          'Petualangan seru di destinasi eksotis dengan pemandangan menakjubkan.',
    },

    // 🏙️ Arsitektur
    {
      'image':
          'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?auto=format&fit=crop&w=800&q=80',
      'title': 'Kota Modern',
      'user': 'Isabella',
      'category': 'Arsitektur',
      'likes': '447',
      'comments': '39',
      'description':
          'Pemandangan kota modern dengan gedung pencakar langit yang menjulang tinggi.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
      'title': 'Pemandangan Kota',
      'user': 'Alexander',
      'category': 'Arsitektur',
      'likes': '723',
      'comments': '65',
      'description':
          'Pemandangan kota dari ketinggian dengan lampu yang berkilauan.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
      'title': 'Desain Interior',
      'user': 'Madison',
      'category': 'Arsitektur',
      'likes': '623',
      'comments': '54',
      'description':
          'Desain interior modern dengan permainan cahaya yang menarik.',
    },

    // 🍽️ Makanan
    {
      'image':
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=800&q=80',
      'title': 'Hidangan Lezat',
      'user': 'Lucas',
      'category': 'Makanan',
      'likes': '891',
      'comments': '103',
      'description': 'Hidangan gourmet yang disajikan dengan indah dan lezat.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
      'title': 'Kopi Pagi',
      'user': 'Henry',
      'category': 'Makanan',
      'likes': '789',
      'comments': '71',
      'description':
          'Kopi segar yang disajikan dengan indah untuk memulai hari.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?auto=format&fit=crop&w=800&q=80',
      'title': 'Pizza Lezat',
      'user': 'Daniel',
      'category': 'Makanan',
      'likes': '956',
      'comments': '84',
      'description': 'Pizza dengan topping melimpah dan keju yang meleleh.',
    },

    // 🖌️ Seni
    {
      'image':
          'https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?auto=format&fit=crop&w=800&q=80',
      'title': 'Seni Abstrak',
      'user': 'Mia',
      'category': 'Seni',
      'likes': '562',
      'comments': '47',
      'description':
          'Karya seni abstrak dengan warna-warna yang cerah dan bentuk yang unik.',
    },

    // 👗 Fashion
    {
      'image':
          'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=800&q=80',
      'title': 'Fashion Trend',
      'user': 'Olivia',
      'category': 'Fashion',
      'likes': '734',
      'comments': '68',
      'description': 'Tren fashion terkini dengan gaya yang modern dan elegan.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80',
      'title': 'Sepatu Fashion',
      'user': 'Riley',
      'category': 'Fashion',
      'likes': '756',
      'comments': '64',
      'description':
          'Koleksi sepatu fashion terkini dengan desain yang elegan.',
    },

    // 💻 Teknologi
    {
      'image':
          'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?auto=format&fit=crop&w=800&q=80',
      'title': 'Coding di Laptop',
      'user': 'Ryan',
      'category': 'Teknologi',
      'likes': '657',
      'comments': '58',
      'description':
          'Developer yang sedang menulis kode di laptop dengan fokus tinggi.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&w=800&q=80',
      'title': 'Kode Program',
      'user': 'Jordan',
      'category': 'Teknologi',
      'likes': '734',
      'comments': '61',
      'description':
          'Tampilan kode program yang rapi dengan syntax highlighting.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?auto=format&fit=crop&w=800&q=80',
      'title': 'Setup Programmer',
      'user': 'Taylor',
      'category': 'Teknologi',
      'likes': '892',
      'comments': '76',
      'description':
          'Workspace programmer dengan multiple monitor dan perangkat lengkap.',
    },

    // 🐾 Hewan
    {
      'image':
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
      'title': 'Anak Kucing Lucu',
      'user': 'Charlotte',
      'category': 'Hewan',
      'likes': '1245',
      'comments': '112',
      'description':
          'Anak kucing yang menggemaskan dengan bulu yang lembut dan mata yang besar.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&w=800&q=80',
      'title': 'Anjing Lucu',
      'user': 'Emma',
      'category': 'Hewan',
      'likes': '1089',
      'comments': '97',
      'description':
          'Anjing yang lucu dengan ekspresi wajah yang menggemaskan.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
      'title': 'Hewan Peliharaan',
      'user': 'Peyton',
      'category': 'Hewan',
      'likes': '1156',
      'comments': '98',
      'description': 'Hewan peliharaan yang lucu dengan ekspresi menggemaskan.',
    },

    // 🎶 Musik
    {
      'image':
          'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?auto=format&fit=crop&w=800&q=80',
      'title': 'Gitar Klasik',
      'user': 'Benjamin',
      'category': 'Musik',
      'likes': '536',
      'comments': '48',
      'description':
          'Gitar klasik dengan kayu berkualitas tinggi dan suara yang merdu.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=800&q=80',
      'title': 'Musik Live',
      'user': 'Mason',
      'category': 'Musik',
      'likes': '845',
      'comments': '73',
      'description': 'Konser musik live dengan energi yang luar biasa.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1495567720989-cebdbdd97913?auto=format&fit=crop&w=800&q=80',
      'title': 'Alat Musik',
      'user': 'Sage',
      'category': 'Musik',
      'likes': '678',
      'comments': '58',
      'description': 'Koleksi alat musik klasik dengan detail yang indah.',
    },

    // 🎬 Film
    {
      'image':
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=80',
      'title': 'Film Klasik',
      'user': 'Amelia',
      'category': 'Film',
      'likes': '678',
      'comments': '59',
      'description': 'Film klasik yang abadi dengan cerita yang menginspirasi.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1574158622682-e40e69881006?auto=format&fit=crop&w=800&q=80',
      'title': 'Film Production',
      'user': 'Skyler',
      'category': 'Film',
      'likes': '712',
      'comments': '63',
      'description': 'Proses produksi film dengan peralatan profesional.',
    },

    // ⚽ Olahraga
    {
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=800&q=80',
      'title': 'Sepak Bola',
      'user': 'James',
      'category': 'Olahraga',
      'likes': '812',
      'comments': '74',
      'description':
          'Aksi menegangkan dalam pertandingan sepak bola profesional.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?auto=format&fit=crop&w=800&q=80',
      'title': 'Latihan Yoga',
      'user': 'River',
      'category': 'Olahraga',
      'likes': '823',
      'comments': '71',
      'description':
          'Pose yoga yang menantang dengan pemandangan alam yang indah.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupScrollListener();
    _startFabAnimation();
  }

  void _initializeControllers() {
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _refreshAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scrollController = ScrollController();
  }

  void _setupScrollListener() {
    _scrollController.addListener(_scrollListener);
  }

  void _startFabAnimation() {
    _fabAnimationController.repeat(reverse: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePins();
    }
  }

  Future<void> _loadMorePins() async {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshPins() async {
    _refreshAnimationController.forward().then((_) {
      _refreshAnimationController.reset();
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _fabAnimationController.dispose();
    _searchAnimationController.dispose();
    _filterAnimationController.dispose();
    _refreshAnimationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
  }

  List<Map<String, String>> get filteredPins {
    List<Map<String, String>> result = pins.where((pin) {
      final matchesCategory =
          _selectedCategory == 'Semua' || pin['category'] == _selectedCategory;
      final matchesSearch =
          pin['title']!.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          pin['user']!.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          pin['description']!.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      return matchesCategory && matchesSearch;
    }).toList();

    // Sort pins based on selected sort option
    if (_sortBy == 'Populer') {
      result.sort(
        (a, b) => int.parse(b['likes']!).compareTo(int.parse(a['likes']!)),
      );
    } else if (_sortBy == 'Terbaru') {
      result = result.reversed.toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDarkMode
                ? [Colors.grey[900]!, Colors.grey[850]!, Colors.black]
                : [Colors.blue.shade50, Colors.white, Colors.grey.shade100],
          ),
        ),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshPins,
          color: Colors.red.shade700,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(),
              _buildCategoriesSection(),
              _buildFilterSection(),
              _buildPinsGrid(),
              if (_isLoadingMore) _buildLoadingIndicator(),
              _buildBottomSpace(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: _isSearching
            ? null
            : const Text(
                'Pinterest',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 1.3,
                  color: Colors.white,
                ),
              ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red.shade700.withValues(alpha: 0.8),
                Colors.red.shade500.withValues(alpha: 0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: MediaQuery.of(context).size.width * 0.7,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Cari pin...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: const Icon(Icons.search, color: Colors.red),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                  _searchAnimationController.reverse();
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search, size: 28),
          tooltip: 'Cari',
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
            _searchAnimationController.forward();
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, size: 28),
          tooltip: 'Notifikasi',
          onPressed: () {
            _showNotifications(context);
          },
        ),
        IconButton(
          icon: Icon(
            _isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: 28,
          ),
          tooltip: 'Tema',
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isDarkMode
                      ? 'Mode gelap diaktifkan'
                      : 'Mode terang diaktifkan',
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.redAccent.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, size: 28),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? 'Pengguna',
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser?.email ??
                      'user@example.com',
                ),
              ),
            ),
            const PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Pengaturan'),
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Keluar'),
                onTap: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/', (route) => false);
                  }
                },
              ),
            ),
          ],
        ),
      ];
    }
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = category == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.grey[800],
                selectedColor: Colors.red.shade700,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? Colors.red.shade700 : Colors.grey[600]!,
                ),
                elevation: isSelected ? 4 : 0,
                shadowColor: Colors.red.withValues(alpha: 0.5),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Sort and filter options
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                            value: 'Populer',
                            child: Text('Populer'),
                          ),
                          DropdownMenuItem(
                            value: 'Terbaru',
                            child: Text('Terbaru'),
                          ),
                          DropdownMenuItem(value: 'Acak', child: Text('Acak')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(
                    _showFilterOptions
                        ? Icons.filter_list_off
                        : Icons.filter_list,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _showFilterOptions = !_showFilterOptions;
                    });
                    _showFilterOptions
                        ? _filterAnimationController.forward()
                        : _filterAnimationController.reverse();
                  },
                ),
              ],
            ),
          ),
          // Filter options (expandable)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _showFilterOptions
                ? Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Opsi Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterOption(
                                'Semua ukuran',
                                'Ukuran',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFilterOption('Semua warna', 'Warna'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterOption('Hanya video', 'Tipe'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFilterOption('Hari ini', 'Waktu'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPinsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childCount: filteredPins.length,
        itemBuilder: (context, index) {
          final pin = filteredPins[index];
          final imageUrl = pin['image']!;
          final title = pin['title']!;
          final user = pin['user']!;
          final likes = pin['likes']!;
          final comments = pin['comments']!;
          final description = pin['description']!;
          final tileHeight = (180 + (index % 4) * 60).toDouble();

          return _PinCard(
            imageUrl: imageUrl,
            title: title,
            user: user,
            height: tileHeight,
            likes: likes,
            comments: comments,
            description: description,
            key: ValueKey(pin['title']),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      ),
    );
  }

  Widget _buildBottomSpace() {
    return const SliverToBoxAdapter(child: SizedBox(height: 100));
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimationController,
      child: FloatingActionButton.extended(
        onPressed: () {
          _showCreateOptions(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Buat'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.red),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.explore, color: Colors.white70),
              onPressed: () {},
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: const Icon(Icons.message, color: Colors.white70),
              onPressed: () {
                _showMessages(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white70),
              onPressed: () {
                _showProfile(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Notifikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) => _buildNotificationItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(int index) {
    final notifications = [
      {
        'user': 'Sarah',
        'action': 'menyukai pin Anda',
        'time': '2 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1494790108755-2616b332c1ca?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Michael',
        'action': 'mengikuti Anda',
        'time': '5 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Emma',
        'action': 'mengomentari pin Anda',
        'time': '1 hari yang lalu',
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'David',
        'action': 'menyimpan pin Anda',
        'time': '2 hari yang lalu',
        'image':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Sophie',
        'action': 'menyukai pin Anda',
        'time': '3 hari yang lalu',
        'image':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80',
      },
    ];

    final notification = notifications[index % notifications.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(notification['image']!),
            backgroundColor: Colors.red.shade400,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: notification['user'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${notification['action']}'),
                    ],
                  ),
                ),
                Text(
                  notification['time']!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Buat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCreateOption(
                    icon: Icons.pin_drop,
                    label: 'Pin',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur buat pin akan segera hadir!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                  _buildCreateOption(
                    icon: Icons.dashboard,
                    label: 'Papan',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur buat papan akan segera hadir!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                  _buildCreateOption(
                    icon: Icons.camera_alt,
                    label: 'Coba Lens',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Lens akan segera hadir!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessages(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Pesan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) => _buildMessageItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(int index) {
    final messages = [
      {
        'user': 'Alex',
        'message': 'Pin ini sangat keren!',
        'time': 'Baru saja',
        'image':
            'https://images.unsplash.com/photo-1494790108755-2616b332c1ca?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Jordan',
        'message': 'Bisakah saya tahu lokasinya?',
        'time': '10 menit yang lalu',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Taylor',
        'message': 'Terima kasih telah berbagi',
        'time': '1 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Morgan',
        'message': 'Saya juga suka ini!',
        'time': '3 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Casey',
        'message': 'Inspirasi yang bagus',
        'time': '5 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80',
      },
    ];

    final message = messages[index % messages.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(message['image']!),
            backgroundColor: Colors.red.shade400,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message['user']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      message['time']!,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message['message']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red.shade400,
                    child: Text(
                      user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Pengguna',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'user@example.com',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Pin', '128'),
                      _buildProfileStat('Pengikut', '3.2K'),
                      _buildProfileStat('Diikuti', '892'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fitur edit profil akan segera hadir!',
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Edit Profil'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
      ],
    );
  }
}

class _PinCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String user;
  final double height;
  final String likes;
  final String comments;
  final String description;

  const _PinCard({
    required this.imageUrl,
    required this.title,
    required this.user,
    required this.height,
    required this.likes,
    required this.comments,
    required this.description,
    super.key,
  });

  @override
  State<_PinCard> createState() => _PinCardState();
}

class _PinCardState extends State<_PinCard>
    with SingleTickerProviderStateMixin {
  bool _isFavorited = false;
  bool _isSaved = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    final snackMsg = _isFavorited
        ? 'Ditambahkan ke favorit'
        : 'Dihapus dari favorit';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMsg),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    final snackMsg = _isSaved
        ? 'Pin disimpan ke papan Anda'
        : 'Pin dihapus dari papan';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMsg),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[850],
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            _PinDetailScreen(
                              imageUrl: widget.imageUrl,
                              title: widget.title,
                              user: widget.user,
                              likes: widget.likes,
                              comments: widget.comments,
                              description: widget.description,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                  onLongPress: () {
                    _showImagePreview(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              widget.imageUrl,
                              height: widget.height,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: widget.height,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.grey[800]!,
                                            Colors.grey[900]!,
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.red.shade400,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: widget.height,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[900]!,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.red.shade400,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Gambar tidak tersedia',
                                            style: TextStyle(
                                              color: Colors.red.shade400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                _buildActionButton(
                                  icon: _isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: _isSaved
                                      ? Colors.white
                                      : Colors.white70,
                                  onTap: _toggleSave,
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  icon: _isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorited
                                      ? Colors.redAccent
                                      : Colors.white70,
                                  onTap: _toggleFavorite,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red.shade400,
                                  child: Text(
                                    widget.user.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.user,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.likes,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.comments,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ),
            Center(
              child: Hero(
                tag: widget.imageUrl,
                child: InteractiveViewer(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red.shade400,
                          strokeWidth: 3,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak tersedia',
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: TextStyle(color: Colors.grey[300], fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red.shade400,
                          child: Text(
                            widget.user.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.user,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: _isSaved ? Colors.white : Colors.white70,
                          ),
                          onPressed: () {
                            _toggleSave();
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorited
                                ? Colors.redAccent
                                : Colors.white70,
                          ),
                          onPressed: () {
                            _toggleFavorite();
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white70),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fitur bagikan akan segera hadir!',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String user;
  final String likes;
  final String comments;
  final String description;

  const _PinDetailScreen({
    required this.imageUrl,
    required this.title,
    required this.user,
    required this.likes,
    required this.comments,
    required this.description,
  });

  @override
  State<_PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends State<_PinDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isFollowing = false;
  bool _isFavorited = false;
  bool _isSaved = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    final snackMsg = _isFollowing
        ? 'Mengikuti ${widget.user}'
        : 'Berhenti mengikuti ${widget.user}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMsg),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    final snackMsg = _isFavorited
        ? 'Ditambahkan ke favorit'
        : 'Dihapus dari favorit';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMsg),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    final snackMsg = _isSaved
        ? 'Pin disimpan ke papan Anda'
        : 'Pin dihapus dari papan';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMsg),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur bagikan akan segera hadir!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.imageUrl,
              child: InteractiveViewer(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red.shade400,
                        strokeWidth: 3,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gambar tidak tersedia',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red.shade400,
                        child: Text(
                          widget.user.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '1.2k pengikut',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return GestureDetector(
                            onTapDown: _onTapDown,
                            onTapUp: _onTapUp,
                            onTapCancel: _onTapCancel,
                            onTap: _toggleFollow,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _isFollowing
                                      ? Colors.grey[700]
                                      : Colors.red.shade700,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _isFollowing ? 'Mengikuti' : 'Ikuti',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildDetailActionButton(
                        icon: _isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: widget.likes,
                        color: _isFavorited ? Colors.redAccent : Colors.white70,
                        onTap: _toggleFavorite,
                      ),
                      const SizedBox(width: 16),
                      _buildDetailActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: widget.comments,
                        color: Colors.white70,
                        onTap: () {
                          _showComments(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Komentar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) => _buildCommentItem(index),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tambahkan komentar...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.comment, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur komentar akan segera hadir!',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCommentItem(int index) {
    final comments = [
      {
        'user': 'Alex',
        'comment': 'Pin ini sangat menginspirasi!',
        'time': '2 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1494790108755-2616b332c1ca?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Jordan',
        'comment': 'Saya suka komposisi warnanya',
        'time': '5 jam yang lalu',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80',
      },
      {
        'user': 'Taylor',
        'comment': 'Tempat yang indah! Terima kasih telah berbagi',
        'time': '1 hari yang lalu',
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80',
      },
    ];

    final comment = comments[index % comments.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment['image']!),
            radius: 16,
            backgroundColor: Colors.red.shade400,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['user']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time']!,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment['comment']!,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.reply, color: Colors.grey[400], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Balas',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Komentar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) => _buildCommentItem(index),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tambahkan komentar...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.comment, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.red),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur komentar akan segera hadir!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
