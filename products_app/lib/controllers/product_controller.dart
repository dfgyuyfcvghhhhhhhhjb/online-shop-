import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  // Get favorites
  List<Product> get favoriteProducts {
    return products.where((p) => p.isFavorite).toList();
  }

  // Load products from local storage
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final String? productsJson = prefs.getString('products');
      
      if (productsJson != null) {
        final List<dynamic> decoded = jsonDecode(productsJson);
        products.value = decoded.map((json) => Product.fromJson(json)).toList();
        filteredProducts.value = products;
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Mahsulotlarni yuklashda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Save products to local storage
  Future<void> saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(
        products.map((p) => p.toJson()).toList(),
      );
      await prefs.setString('products', encoded);
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Mahsulotlarni saqlashda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Pick image from gallery or camera
  Future<String?> pickImage({required bool fromCamera}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // Save image to app directory
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = '${_uuid.v4()}.jpg';
        final String savedPath = '${appDir.path}/$fileName';
        
        await File(image.path).copy(savedPath);
        return savedPath;
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Rasm tanlashda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  // Add product (CREATE)
  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    String? imagePath,
  }) async {
    try {
      final product = Product(
        id: _uuid.v4(),
        name: name,
        description: description,
        price: price,
        imagePath: imagePath,
      );

      products.add(product);
      await saveProducts();
      searchProducts(searchQuery.value);
      
      Get.snackbar(
        'Muvaffaqiyatli',
        'Mahsulot qo\'shildi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Mahsulot qo\'shishda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update product (UPDATE)
  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    String? imagePath,
  }) async {
    try {
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        final oldProduct = products[index];
        
        // Delete old image if new one is provided
        if (imagePath != null && 
            oldProduct.imagePath != null && 
            oldProduct.imagePath != imagePath) {
          try {
            await File(oldProduct.imagePath!).delete();
          } catch (e) {
            // Ignore if file doesn't exist
          }
        }

        products[index] = oldProduct.copyWith(
          name: name,
          description: description,
          price: price,
          imagePath: imagePath ?? oldProduct.imagePath,
        );

        await saveProducts();
        searchProducts(searchQuery.value);
        
        Get.snackbar(
          'Muvaffaqiyatli',
          'Mahsulot yangilandi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Mahsulotni yangilashda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Delete product (DELETE)
  Future<void> deleteProduct(String id) async {
    try {
      final product = products.firstWhere((p) => p.id == id);
      
      // Delete image file
      if (product.imagePath != null) {
        try {
          await File(product.imagePath!).delete();
        } catch (e) {
          // Ignore if file doesn't exist
        }
      }

      products.removeWhere((p) => p.id == id);
      await saveProducts();
      searchProducts(searchQuery.value);
      
      Get.snackbar(
        'Muvaffaqiyatli',
        'Mahsulot o\'chirildi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Mahsulotni o\'chirishda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String id) async {
    try {
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index].isFavorite = !products[index].isFavorite;
        products.refresh();
        await saveProducts();
        searchProducts(searchQuery.value);
      }
    } catch (e) {
      Get.snackbar(
        'Xatolik',
        'Sevimlilarni yangilashda xatolik: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    filteredProducts.value = products;
  }
}
