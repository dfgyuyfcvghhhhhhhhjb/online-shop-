# Mahsulotlar App (Products App)

Flutter ilovasi - mahsulotlarni boshqarish uchun CRUD operatsiyalari, qidiruv va sevimlilar bilan.

## Funksiyalar

### ✅ CRUD Operatsiyalari
- **Create (Qo'shish)** - Yangi mahsulot qo'shish
- **Read (O'qish)** - Mahsulotlar ro'yxatini ko'rish
- **Update (Yangilash)** - Mavjud mahsulotni tahrirlash
- **Delete (O'chirish)** - Mahsulotni o'chirish

### 📸 Rasm bilan ishlash
- Galereyadan rasm tanlash
- Kameradan rasm olish
- Rasmni o'chirish
- Rasmlarni lokal saqlash

### 🔍 Qidiruv
- Mahsulot nomi bo'yicha qidiruv
- Tavsif bo'yicha qidiruv
- Real-time qidiruv
- Qidiruvni tozalash

### ❤️ Sevimlilar
- Mahsulotni sevimliga qo'shish/olib tashlash
- Sevimlilar sahifasi
- Like tugmasi har bir mahsulot kartasida

## O'rnatish

1. Dependencies o'rnatish:
```bash
flutter pub get
```

2. Ilovani ishga tushirish:
```bash
flutter run
```

## Ishlatilgan texnologiyalar

- **Flutter** - UI framework
- **GetX** - State management
- **SharedPreferences** - Local storage
- **Image Picker** - Rasm tanlash
- **Path Provider** - File path management
- **UUID** - Unique ID generation

## Arxitektura

```
lib/
├── models/
│   └── product.dart          # Product model
├── controllers/
│   └── product_controller.dart  # GetX controller
├── pages/
│   ├── home_page.dart        # Asosiy sahifa
│   ├── add_edit_product_page.dart  # Qo'shish/Tahrirlash
│   ├── product_detail_page.dart    # Mahsulot tafsilotlari
│   └── favorites_page.dart   # Sevimlilar sahifasi
├── widgets/
│   └── product_card.dart     # Mahsulot kartasi
└── main.dart                 # Entry point
```

## Ekran rasmlari

### Asosiy sahifa
- Barcha mahsulotlar ro'yxati
- Qidiruv paneli
- Sevimlilar tugmasi
- Yangi mahsulot qo'shish (+)

### Mahsulot qo'shish/tahrirlash
- Rasm tanlash (Galereya/Kamera)
- Nom kiritish
- Tavsif kiritish
- Narx kiritish
- Validatsiya

### Mahsulot tafsilotlari
- To'liq rasm
- Nom va narx
- Tavsif
- Like tugmasi
- Tahrirlash va o'chirish

### Sevimlilar
- Yoqtirilgan mahsulotlar ro'yxati
- Like tugmasi bilan boshqarish

## Ma'lumotlar saqlash

Mahsulotlar `SharedPreferences` da JSON formatida saqlanadi:
- Mahsulot ma'lumotlari (nom, tavsif, narx)
- Rasm yo'li
- Yaratilgan sana
- Sevimli holati

Rasmlar esa `ApplicationDocumentsDirectory` da saqlanadi.
