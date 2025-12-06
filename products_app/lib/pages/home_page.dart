import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import 'add_edit_product_page.dart';
import 'product_detail_page.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahsulotlar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => const FavoritesPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: TextField(
              onChanged: (value) => controller.searchProducts(value),
              decoration: InputDecoration(
                hintText: 'Mahsulot qidirish...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() {
                  return controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.clearSearch(),
                        )
                      : const SizedBox.shrink();
                }),
              ),
            ),
          ),

          // Products List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'Hech narsa topilmadi'
                            : 'Mahsulotlar yo\'q',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (controller.searchQuery.value.isEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Yangi mahsulot qo\'shish uchun + tugmasini bosing',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadProducts(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Get.to(() => ProductDetailPage(product: product));
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddEditProductPage());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
