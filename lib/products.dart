import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Product {
  final int id;
  final String name;
  final int price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }
}

Future<List<Product>> loadProducts() async {
  final String response = await rootBundle.loadString('assets/data/products.json');
  final List<dynamic> data = jsonDecode(response);
  return data.map((json) => Product.fromJson(json)).toList();
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada produk'));
        }

        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return ListTile(
              title: Text(p.name),
              subtitle: Text('Rp ${p.price}'),
              leading: CircleAvatar(child: Text(p.id.toString())),
            );
          },
        );
      },
    );
  }
}
