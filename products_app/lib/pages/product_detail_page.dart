import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import 'add_edit_product_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahsulot ma\'lumotlari'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => AddEditProductPage(product: product));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, controller),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            if (product.imagePath != null)
              Image.file(
                File(product.imagePath!),
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
            else
              _buildPlaceholder(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Favorite
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(() {
                        final isFav = controller.products
                            .firstWhere((p) => p.id == product.id)
                            .isFavorite;
                        
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            controller.toggleFavorite(product.id);
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Colors.green,
                        ),
                        Text(
                          '${product.price.toStringAsFixed(0)} so\'m',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Tavsifi:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Created At
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Qo\'shilgan: ${_formatDate(product.createdAt)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 300,
      color: Colors.grey[300],
      child: Icon(
        Icons.shopping_bag,
        size: 100,
        color: Colors.grey[600],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showDeleteDialog(BuildContext context, ProductController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('O\'chirish'),
        content: const Text('Mahsulotni o\'chirishni xohlaysizmi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Yo\'q'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.deleteProduct(product.id);
              Get.back(); // Go back to home
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Ha, o\'chirish'),
          ),
        ],
      ),
    );
  }
}
