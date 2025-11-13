import 'package:flutter/material.dart';

// Data Models
class ServiceCategory {
  final String name;
  final String icon;
  final Color color;
  final List<Subcategory> subcategories;

  ServiceCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.subcategories,
  });
}

class Subcategory {
  final String name;
  final String emoji;
  final bool isPopular;

  Subcategory({
    required this.name,
    required this.emoji,
    this.isPopular = false,
  });
}

// Sample Data
class ServiceData {
  static final crafts = ServiceCategory(
    name: 'Crafts',
    icon: 'assets/crafts.png',
    color: const Color(0xFFFF6B35),
    subcategories: [
      Subcategory(name: 'General Electricity', emoji: '⚡', isPopular: true),
      Subcategory(name: 'Painting & Decorating', emoji: '🎨', isPopular: true),
      Subcategory(name: 'Carpentry', emoji: '🪵'),
      Subcategory(name: 'Aluminum & Glass', emoji: '🪟'),
      Subcategory(name: 'Blacksmithing & Welding', emoji: '🔨'),
      Subcategory(name: 'Construction & Renovation', emoji: '🏗️'),
      Subcategory(name: 'Water & Sanitation', emoji: '🚰', isPopular: true),
      Subcategory(name: 'Plastering & Ceilings', emoji: '🧱'),
      Subcategory(name: 'Ceramic & Tile', emoji: '🟫'),
      Subcategory(name: 'Marble & Stone', emoji: '⬜'),
      Subcategory(name: 'Upholstery & Furniture', emoji: '🛋️'),
    ],
  );

  static final technical = ServiceCategory(
    name: 'Technical Services',
    icon: 'assets/technical.png',
    color: const Color(0xFF4A90E2),
    subcategories: [
      Subcategory(
        name: 'Air Conditioning & Refrigeration',
        emoji: '❄️',
        isPopular: true,
      ),
      Subcategory(name: 'Solar Energy', emoji: '☀️'),
      Subcategory(name: 'Electronics', emoji: '🔌'),
      Subcategory(name: 'Internet & Networks', emoji: '📡', isPopular: true),
      Subcategory(name: 'Electrical Appliance Maintenance', emoji: '🔧'),
      Subcategory(name: 'Elevator Maintenance', emoji: '🛗'),
    ],
  );

  static final cleaning = ServiceCategory(
    name: 'Cleaning & Household',
    icon: 'assets/cleaning_and_home.png',
    color: const Color(0xFF50C878),
    subcategories: [
      Subcategory(name: 'House Cleaning', emoji: '🏠', isPopular: true),
      Subcategory(name: 'Carpet Cleaning', emoji: '🧺'),
      Subcategory(name: 'Water Tank Cleaning', emoji: '💧'),
      Subcategory(name: 'Roof Cleaning', emoji: '🏚️'),
      Subcategory(
        name: 'Moving & Furniture Services',
        emoji: '📦',
        isPopular: true,
      ),
      Subcategory(name: 'Landscaping', emoji: '🌳'),
      Subcategory(name: 'Agricultural Services', emoji: '🌾'),
    ],
  );
}

// Subcategory Screen
class SubcategoryScreen extends StatefulWidget {
  final ServiceCategory category;

  const SubcategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  String searchQuery = '';
  List<Subcategory> get filteredSubcategories {
    if (searchQuery.isEmpty) {
      return widget.category.subcategories;
    }
    return widget.category.subcategories
        .where(
          (sub) => sub.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.category.subcategories.length} Services Available',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.category.color,
                widget.category.color.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search in ${widget.category.name}...',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF999999),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info Banner
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Not sure which service?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Our experts can help you choose',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              Text(
                searchQuery.isEmpty ? 'All Services' : 'Search Results',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),

              // Subcategory Grid
              filteredSubcategories.isEmpty
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Color(0xFF999999),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No services found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 3 : 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: filteredSubcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = filteredSubcategories[index];
                      return _buildSubcategoryCard(context, subcategory);
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(BuildContext context, Subcategory subcategory) {
    return InkWell(
      onTap: () => _onSubcategoryTap(context, subcategory),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji Icon
                  Text(subcategory.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 12),
                  // Service Name
                  Text(
                    subcategory.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Popular Badge
            if (subcategory.isPopular)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onSubcategoryTap(BuildContext context, Subcategory subcategory) {
    // Navigate to service details or technician list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${subcategory.name}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
