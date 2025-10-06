import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/favorite_provider.dart';
import 'package:shop_app_flutter/pages/product_details_page.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favouriteProducts = context.watch<FavoriteProvider>().favorites;
    final favoriteProvider = context.read<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: favouriteProducts.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favouriteProducts.length,
              itemBuilder: (context, index) {
                final item = favouriteProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(item['imageUrl'] as String),
                    ),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item['company']} • \$${item['price']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        favoriteProvider.removeFavorite(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites!'),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: item.cast<String, Object>()),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
