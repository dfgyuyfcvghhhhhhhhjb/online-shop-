import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _imagePath = widget.product!.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool fromCamera) async {
    final controller = Get.find<ProductController>();
    final path = await controller.pickImage(fromCamera: fromCamera);
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  void _showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rasm tanlash',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                _pickImage(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Galereya'),
              onTap: () {
                Get.back();
                _pickImage(false);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Rasmni o\'chirish'),
                onTap: () {
                  Get.back();
                  setState(() {
                    _imagePath = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final controller = Get.find<ProductController>();
    final price = double.tryParse(_priceController.text) ?? 0;

    if (widget.product == null) {
      // Add new product
      await controller.addProduct(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        imagePath: _imagePath,
      );
    } else {
      // Update existing product
      await controller.updateProduct(
        id: widget.product!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        imagePath: _imagePath,
      );
    }

    setState(() => _isLoading = false);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Mahsulotni tahrirlash' : 'Yangi mahsulot'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          ),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rasmni tanlash uchun bosing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nomi *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomini kiriting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Tavsifi *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tavsifini kiriting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Narxi *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: 'so\'m',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Narxini kiriting';
                  }
                  if (double.tryParse(value) == null) {
                    return 'To\'g\'ri raqam kiriting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        isEdit ? 'Yangilash' : 'Qo\'shish',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 60,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          'Rasm qo\'shish',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
