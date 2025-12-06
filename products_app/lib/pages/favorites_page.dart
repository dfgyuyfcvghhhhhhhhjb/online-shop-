import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sevimlilar'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final favorites = controller.favoriteProducts;

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sevimli mahsulotlar yo\'q',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mahsulotga ♥ bosing',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final product = favorites[index];
            return ProductCard(
              product: product,
              onTap: () {
                Get.to(() => ProductDetailPage(product: product));
              },
            );
          },
        );
      }),
    );
  }
}
