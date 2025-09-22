import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, String>> pins = const [
    {
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'title': 'Misty Mountains',
      'user': 'Eleanor',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=800&q=80',
      'title': 'Dreamy Forest',
      'user': 'Oliver',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=800&q=80',
      'title': 'Golden Hour',
      'user': 'Sophia',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
      'title': 'Desert Dunes',
      'user': 'Liam',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1468071174046-657d9d351a40?auto=format&fit=crop&w=800&q=80',
      'title': 'Serene Lake',
      'user': 'Mia',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
      'title': 'Winding Path',
      'user': 'Noah',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
      'title': 'Wild Flowers',
      'user': 'Ava',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?auto=format&fit=crop&w=800&q=80',
      'title': 'Sunset Bliss',
      'user': 'Ethan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Pinterest Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 28),
            tooltip: 'Logout',
            onPressed: () => Navigator.pop(context),
          )
        ],
        elevation: 12,
        shadowColor: Colors.redAccent.withOpacity(0.8),
      ),
      body: Scrollbar(
        thickness: 7,
        radius: const Radius.circular(16),
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            itemCount: pins.length,
            itemBuilder: (context, index) {
              final pin = pins[index];
              final imageUrl = pin['image']!;
              final title = pin['title']!;
              final user = pin['user']!;
              final tileHeight = (180 + (index % 4) * 60).toDouble();

              return _PinCard(
                imageUrl: imageUrl,
                title: title,
                user: user,
                height: tileHeight,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PinCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String user;
  final double height;

  const _PinCard({
    required this.imageUrl,
    required this.title,
    required this.user,
    required this.height,
    super.key,
  });

  @override
  State<_PinCard> createState() => _PinCardState();
}

class _PinCardState extends State<_PinCard> with SingleTickerProviderStateMixin {
  bool _isFavorited = false;
  late AnimationController _scaleController;

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _scaleController.reverse();
  }

  void _onTapUp(_) {
    _scaleController.forward();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    final snackMsg = _isFavorited ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(snackMsg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.redAccent.shade700,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleController,
      child: Material(
        borderRadius: BorderRadius.circular(26),
        elevation: 12,
        shadowColor: Colors.redAccent.withOpacity(0.6),
        color: Colors.grey[900],
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: () => _scaleController.forward(),
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                    child: Image.network(
                      widget.imageUrl,
                      height: widget.height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: widget.height,
                          color: Colors.grey.shade800,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.redAccent),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: widget.height,
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: _toggleFavorite,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(9),
                        child: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.redAccent : Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  'oleh ${widget.user}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
