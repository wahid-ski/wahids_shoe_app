import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';
import 'package:shop_app_flutter/providers/favorite_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, Object> product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSizeIndex = 0;

  bool _isInFavorites(FavoriteProvider favoriteProvider) {
    return favoriteProvider.favorites.any(
      (item) => item['id'] == widget.product['id'],
    );
  }

  void onTap() {
    if (selectedSizeIndex == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a size')),
      );
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addProduct({
      'id': widget.product['id']!,
      'title': widget.product['title']!,
      'price': widget.product['price']!,
      'imageUrl': widget.product['imageUrl']!,
      'color': widget.product['color']!,
      'company': widget.product['company']!,
      'sizes': selectedSizeIndex,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFavorite = _isInFavorites(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: Stack(
        children: [
          // =========================
          // SCROLLABLE IMAGE SECTION
          // =========================
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  widget.product['imageUrl'] as String,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 203, 205, 216),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75),
                  topRight: Radius.circular(75),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product['title'] as String,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black54
                                  : const Color.fromARGB(179, 22, 1, 1),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 40,
                            color: isFavorite ? Colors.red : Colors.black,
                            weight: isFavorite ? 900 : 1000,
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              favoriteProvider.removeFavorite(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Removed from favorites!'),
                                ),
                              );
                            } else {
                              favoriteProvider.addFavorite(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to favorites!'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Text(
                      '\$${widget.product['price']}',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : const Color.fromARGB(179, 22, 1, 1),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (widget.product['sizes'] as List<int>).length,
                        itemBuilder: (context, index) {
                          final size = (widget.product['sizes'] as List<int>)[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSizeIndex = size;
                                });
                              },
                              child: Chip(
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: primaryColor,
                                    width: 3,
                                  ),
                                ),
                                backgroundColor: selectedSizeIndex == size
                                    ? primaryColor
                                    : const Color.fromARGB(255, 124, 130, 147),
                                label: Text(
                                  size.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_cart, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Add to Cart',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
