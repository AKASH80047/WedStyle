import 'package:flutter_test/flutter_test.dart';
import 'package:wedstyle/core/utils/mock_data.dart';
import 'package:wedstyle/core/utils/providers.dart';
import 'package:wedstyle/core/utils/ai_tryon_service.dart';

void main() {
  group('WedStyle Catalog & Data Integrity Tests', () {
    test(
      'Contains rich Indian wedding fashion catalog across all required categories',
      () {
      expect(mockProducts.length, greaterThanOrEqualTo(60));

        final bridal = mockProducts
            .where(
              (p) =>
                  p.gender == 'Women' &&
                  (p.categoryName.contains('Lehenga') ||
                      p.categoryName.contains('Saree') ||
                      p.categoryName.contains('Anarkali')),
            )
            .toList();
        expect(
          bridal.length,
          greaterThanOrEqualTo(20),
          reason: 'Must have at least 20 bridal items',
        );

        final mensProducts = mockProducts
            .where((p) => p.gender == 'Men')
            .toList();
        expect(
          mensProducts,
          isEmpty,
          reason: 'WedStyle is a women-only Gujarati bridal catalogue',
        );

        final jewellery = mockProducts
            .where((p) => p.categoryId == 'cat_jewellery')
            .toList();
        expect(
          jewellery.length,
          greaterThanOrEqualTo(10),
          reason: 'Must have jewellery items',
        );

        final accessories = mockProducts
            .where((p) => p.categoryId == 'cat_accessories')
            .toList();
        expect(
          accessories.length,
          greaterThanOrEqualTo(5),
          reason: 'Must have accessory items',
        );

        final footwear = mockProducts
            .where((p) => p.categoryId == 'cat_footwear')
            .toList();
        expect(
          footwear.length,
          greaterThanOrEqualTo(5),
          reason: 'Must have footwear items',
        );
      },
    );

    test(
      'Products have valid prices, images, occasions, fabrics, and sizes',
      () {
        for (final p in mockProducts) {
          expect(p.id, isNotEmpty);
          expect(p.name, isNotEmpty);
          expect(p.price, greaterThan(0));
          expect(p.images, isNotEmpty);
          expect(p.sizes, isNotEmpty);
          expect(p.colors, isNotEmpty);
          expect(p.fabric, isNotEmpty);
          expect(p.occasionsList, isNotEmpty);
        }
      },
    );
  });

  group('Cart & Checkout Calculations Tests', () {
    late CartProvider cart;

    setUp(() {
      cart = CartProvider();
    });

    test('Add item, update quantity, and compute subtotal correctly', () {
      final product = mockProducts.first;
      cart.addItem(product, size: 'M', color: product.colors.first, qty: 1);

      expect(cart.items.length, 1);
      expect(cart.itemCount, 1);
      expect(cart.subtotal, product.discountedPrice);

      // Increase quantity
      cart.updateQuantity(cart.items.first.id, 2);
      expect(cart.itemCount, 2);
      expect(cart.subtotal, product.discountedPrice * 2);

      // Remove item
      cart.removeItem(cart.items.first.id);
      expect(cart.items.isEmpty, isTrue);
      expect(cart.itemCount, 0);
    });

    test('Apply coupon code correctly', () {
      final product = mockProducts.first;
      cart.addItem(product, size: 'L', color: product.colors.first, qty: 1);

      // Apply coupon model
      final coupon = MockData.sampleCoupons.first;
      final success = cart.applyCoupon(coupon);
      expect(success, isTrue);
      expect(cart.appliedCoupon, isNotNull);
      expect(cart.couponDiscount, greaterThan(0));
    });
  });

  group('Wishlist State Tests', () {
    late WishlistProvider wishlist;

    setUp(() {
      wishlist = WishlistProvider();
    });

    test('Toggle items in wishlist', () {
      final product = mockProducts[1];
      expect(wishlist.isInWishlist(product.id), isFalse);

      wishlist.toggle(product);
      expect(wishlist.isInWishlist(product.id), isTrue);

      wishlist.toggle(product);
      expect(wishlist.isInWishlist(product.id), isFalse);
    });
  });

  group('AI Try-On Service & Configuration Tests', () {
    test('Default configuration does not fabricate a try-on result', () async {
      final service = AiTryOnService();
      final product = mockProducts.first;

      await expectLater(
        service.processVirtualTryOn(
          userPhotoPath: '/missing-photo.jpg',
          garment: product,
        ),
        throwsA(isA<AiTryOnException>()),
      );
    });
  });
}
