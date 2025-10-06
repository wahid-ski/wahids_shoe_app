import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    //    final cartProvider = Provider.of<CartProvider>(context).cart;
    //   final cart = cartProvider.cart;
    final cart = context.watch<CartProvider>().cart;
    final cartProvider = context.read<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return ListTile(
            title: Text(
              item['title'] as String,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Size: ${item['sizes']}',
              style: TextStyle(fontSize: 20),
            ),
            leading: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(item['imageUrl'] as String),
            ),
            //  leading: Image.asset(item['imageUrl'] as String, width: 50
            //  subtitle: Text('\$${item['price']}'),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                size: 30,
                color: Color.fromARGB(255, 209, 38, 26),
              ),
              onPressed: () {
                // Handle item removal from cart
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Remove Item'),
                      content: Text(
                        'Are you sure you want to remove this item from the cart?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.removeProduct(item);
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Remove'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
