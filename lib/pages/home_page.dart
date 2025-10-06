import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/pages/favourite_page.dart';
import 'package:shop_app_flutter/pages/profile.dart';
import 'package:shop_app_flutter/providers/search_provider.dart';
import 'package:shop_app_flutter/providers/theme_provider.dart';
import 'package:shop_app_flutter/pages/cart_page.dart';
import 'package:shop_app_flutter/pages/product_details_page.dart';
import 'package:shop_app_flutter/widgets/product_list.dart';
import 'package:shop_app_flutter/global_variable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final query = searchProvider.searchQuery.toLowerCase();

    final suggestions = products.where((product) {
      final title = (product['title'] as String).toLowerCase();
      final company = (product['company'] as String).toLowerCase();
      return title.contains(query) || company.contains(query);
    }).toList();

    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          setState(() {
            isSearching = false;
            searchController.clear();
            searchProvider.clearSearch();
          });
          return false; // Stay in app
        } else if (currentPage != 0) {
          setState(() {
            currentPage = 0;
          });
          return false; // Go to Home
        }
        return true; // Exit app
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: isSearching
                ? TextField(
                    key: const ValueKey('search'),
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      searchProvider.updateSearchQuery(value);
                    },
                  )
                : Image.asset(
                    'assets/images/logo/Appbarlogo.png',
                    height: 80,
                    width: 90,
                    key: const ValueKey('logo'),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search, size: 28),
              tooltip: isSearching ? 'Close Search' : 'Search',
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    isSearching = false;
                    searchController.clear();
                    searchProvider.clearSearch();
                  } else {
                    isSearching = true;
                  }
                });
              },
            ),
            const SizedBox(width: 8),
          ],
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.account_circle,
                            size: 90, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome User',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Address'),
                onTap: () {
                  setState(() {
                    currentPage = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payment Methods'),
                onTap: () {
                  setState(() {
                    currentPage = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return ListTile(
                    leading: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        themeProvider.themeMode == ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        key: ValueKey(themeProvider.themeMode),
                      ),
                    ),
                    title: Text(
                      themeProvider.themeMode == ThemeMode.light
                          ? 'Dark Mode'
                          : 'Light Mode',
                    ),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Order History'),
                onTap: () {
                  setState(() {
                    currentPage = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 350),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        body: isSearching
            ? _buildSearchSuggestions(suggestions, query)
            : IndexedStack(
                index: currentPage,
                children: const [
                  ProductList(),
                  FavouritePage(),
                  CartPage(),
                ],
              ),

        bottomNavigationBar: BottomNavigationBar(
          iconSize: 35,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: currentPage,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions(
      List<Map<String, Object>> suggestions, String query) {
    if (query.isEmpty) {
      return const Center(child: Text('Start typing to search...'));
    }

    if (suggestions.isEmpty) {
      return const Center(child: Text('No matching products found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(product['imageUrl'] as String),
              radius: 25,
            ),
            title: Text(
              product['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${product['company']} • \$${product['price']}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
