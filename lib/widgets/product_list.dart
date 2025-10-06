import 'package:flutter/material.dart';
import 'package:shop_app_flutter/global_variable.dart';
import 'package:shop_app_flutter/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    'All',
    'Adidas',
    'Nike',
    'Bata',
    'Puma',
    'Lotto',
  ];
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters.first;
  }

  List<Map<String, Object>> get trendingProducts {
    return products
        .where((product) {
          final price = product['price'] as double;
          return price > 60.0;
        })
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredProducts = selectedFilter == 'All'
        ? products
        : products
              .where(
                (product) =>
                    (product['company'] as String).toLowerCase() ==
                    selectedFilter.toLowerCase(),
              )
              .toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Arrivals',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Icon(
                        Icons.local_fire_department,
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 330,
                  child: CarouselView(
                    itemExtent: 280,
                    shrinkExtent: 230,
                    itemSnapping: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: Colors.transparent,
                    elevation: 0,

                    onTap: (index) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ProductDetailsPage(
                                    product: trendingProducts[index],
                                  ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                // Slide transition
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 50),
                        ),
                      );
                    },

                    children: trendingProducts.map((product) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // Premium gradient background
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withAlpha(200),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withAlpha(100),
                              blurRadius: 23,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              product['imageUrl'] as String,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                product['title'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '\$${product['price']}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: filters.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        backgroundColor: selectedFilter == filter
                            ? theme.colorScheme.primary
                            : null,
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: selectedFilter == filter
                                ? Colors.black
                                : null,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Products',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
                childAspectRatio: 0.70,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(50),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image Section
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(20),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                product['imageUrl'] as String,
                                fit: BoxFit.contain,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Product Title
                                Text(
                                  product['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product['price']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      product['company'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
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
              }, childCount: filteredProducts.length),
            ),
          ),
        ],
      ),
    );
  }
}
