import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/models.dart';
import '../constants/app_constants.dart';
import 'mock_data.dart';
import 'ai_tryon_service.dart';

// ====================
// AUTH PROVIDER
// ====================
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  bool _isGuest = false;

  UserModel? get currentUser => _currentUser;
  UserModel? get user => _currentUser ?? MockData.sampleUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isGuest => _isGuest;
  bool get isAdmin => _currentUser?.role == AppConstants.roleAdmin;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    _isGuest = prefs.getBool(AppConstants.keyGuestMode) ?? false;
    if (_isLoggedIn) {
      _currentUser = MockData.sampleUser;
    }
    notifyListeners();
  }

  Future<bool> login(String emailOrPhone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    if (emailOrPhone.isNotEmpty && password.length >= 6) {
      _currentUser = MockData.sampleUser;
      _isLoggedIn = true;
      _isGuest = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await prefs.setBool(AppConstants.keyGuestMode, false);
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _error = 'Invalid credentials. Please try again.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    String? gender,
    String? weddingDate,
    String? city,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      mobile: mobile,
      gender: gender,
      weddingDate: weddingDate,
      city: city,
      createdAt: DateTime.now(),
    );
    _isLoggedIn = true;
    _isGuest = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> continueAsGuest() async {
    _isGuest = true;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyGuestMode, true);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    _isGuest = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}

// ====================
// PRODUCTS PROVIDER
// ====================
class ProductsProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _trendingProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';
  String _sortBy = 'popular';

  List<ProductModel> get products => _products;
  List<ProductModel> get trendingProducts => _trendingProducts;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts({String? categoryId}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _products = MockData.products;
    _filteredProducts = categoryId != null
        ? _products.where((p) => p.categoryId == categoryId).toList()
        : _products;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTrendingProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _trendingProducts = MockData.products.take(8).toList();
    notifyListeners();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return [];
    return _products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.brand.toLowerCase().contains(query.toLowerCase()) ||
              p.categoryName.toLowerCase().contains(query.toLowerCase()) ||
              p.occasion.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void sortProducts(String sortBy) {
    _sortBy = sortBy;
    switch (sortBy) {
      case 'price_low':
        _filteredProducts.sort(
          (a, b) => a.discountedPrice.compareTo(b.discountedPrice),
        );
        break;
      case 'price_high':
        _filteredProducts.sort(
          (a, b) => b.discountedPrice.compareTo(a.discountedPrice),
        );
        break;
      case 'rating':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        _filteredProducts = _filteredProducts.reversed.toList();
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void applyFilters({
    double? minPrice,
    double? maxPrice,
    String? gender,
    String? occasion,
    double? minRating,
  }) {
    _filteredProducts = _products.where((p) {
      bool match = true;
      if (minPrice != null) match = match && p.discountedPrice >= minPrice;
      if (maxPrice != null) match = match && p.discountedPrice <= maxPrice;
      if (gender != null && gender.isNotEmpty)
        match = match && p.gender.toLowerCase() == gender.toLowerCase();
      if (occasion != null && occasion.isNotEmpty)
        match = match && p.occasion.toLowerCase() == occasion.toLowerCase();
      if (minRating != null) match = match && p.rating >= minRating;
      return match;
    }).toList();
    notifyListeners();
  }
}

// ====================
// CART PROVIDER
// ====================
class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  final List<ProductModel> _wishlist = [];

  List<CartItemModel> get items => _items;
  List<ProductModel> get wishlist => _wishlist;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  Future<void> loadCart() async {
    // Initial load simulation
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get deliveryCharge => subtotal >= 2000 ? 0 : 99;
  double _couponDiscount = 0;
  String? _appliedCoupon;

  double get couponDiscount => _couponDiscount;
  String? get appliedCoupon => _appliedCoupon;
  double get tax => subtotal * 0.05;
  double get total => subtotal - _couponDiscount + deliveryCharge + tax;

  bool hasProduct(String productId) =>
      _items.any((i) => i.product.id == productId);

  void addItem(
    ProductModel product, {
    required String size,
    required String color,
    int qty = 1,
  }) {
    final existing = _items.where(
      (i) =>
          i.product.id == product.id &&
          i.selectedSize == size &&
          i.selectedColor == color,
    );
    if (existing.isNotEmpty) {
      existing.first.quantity += qty;
    } else {
      _items.add(
        CartItemModel(
          id: '${product.id}_${size}_${color}',
          product: product,
          quantity: qty,
          selectedSize: size,
          selectedColor: color,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int qty) {
    final item = _items.firstWhere((i) => i.id == itemId);
    if (qty <= 0) {
      _items.remove(item);
    } else {
      item.quantity = qty;
    }
    notifyListeners();
  }

  bool applyCoupon(CouponModel coupon) {
    if (coupon.isValid && subtotal >= coupon.minOrder) {
      _couponDiscount = coupon.calculateDiscount(subtotal);
      _appliedCoupon = coupon.code;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _couponDiscount = 0;
    _appliedCoupon = null;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _couponDiscount = 0;
    _appliedCoupon = null;
    notifyListeners();
  }
}

// ====================
// WISHLIST PROVIDER
// ====================
class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;
  int get count => _items.length;

  bool isInWishlist(String productId) => _items.any((p) => p.id == productId);

  void toggle(ProductModel product) {
    if (isInWishlist(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}

// ====================
// ORDERS PROVIDER
// ====================
class OrdersProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  List<OrderModel> getByStatus(String status) {
    if (status == 'all') return _orders;
    return _orders.where((o) => o.status == status).toList();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _orders = MockData.sampleOrders;
    _isLoading = false;
    notifyListeners();
  }

  Future<String> placeOrder({
    required CartProvider cart,
    required AddressModel address,
    required String paymentMethod,
    required String deliveryType,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    final orderId = 'WS${DateTime.now().millisecondsSinceEpoch}';
    final order = OrderModel(
      id: orderId,
      userId: 'usr_1',
      items: cart.items
          .map(
            (i) => OrderItemModel(
              productId: i.product.id,
              productName: i.product.name,
              productImage: i.product.images.first,
              brand: i.product.brand,
              size: i.selectedSize,
              color: i.selectedColor,
              quantity: i.quantity,
              price: i.product.discountedPrice,
              total: i.total,
            ),
          )
          .toList(),
      address: address,
      subtotal: cart.subtotal,
      discount: 0,
      deliveryCharge: cart.deliveryCharge,
      couponDiscount: cart.couponDiscount,
      tax: cart.tax,
      total: cart.total,
      status: 'confirmed',
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      deliveryType: deliveryType,
      couponCode: cart.appliedCoupon,
    );
    _orders.insert(0, order);
    cart.clear();
    notifyListeners();
    return orderId;
  }
}

// ====================
// AI TRY-ON PROVIDER
// ====================
class AiTryOnProvider extends ChangeNotifier {
  List<AiTryOnModel> _history = [];
  AiTryOnModel? _currentSession;
  bool _isGenerating = false;
  double _generationProgress = 0;
  String? _currentUserPhotoPath;
  ProductModel? _selectedProduct;
  String? _generationError;

  List<AiTryOnModel> get history => _history;
  AiTryOnModel? get currentSession => _currentSession;
  bool get isGenerating => _isGenerating;
  double get generationProgress => _generationProgress;
  String? get currentUserPhotoPath => _currentUserPhotoPath;
  ProductModel? get selectedProduct => _selectedProduct;
  String? get generationError => _generationError;

  void setUserPhoto(String path) {
    _currentUserPhotoPath = path;
    _generationError = null;
    notifyListeners();
  }

  void setSelectedProduct(ProductModel product) {
    _selectedProduct = product;
    notifyListeners();
  }

  Future<AiTryOnModel?> generateTryOn() async {
    _currentUserPhotoPath ??= 'assets/images/user_face.jpg';
    if (_selectedProduct == null && MockData.products.isNotEmpty) {
      _selectedProduct = MockData.products.first;
    }
    if (_currentUserPhotoPath == null || _selectedProduct == null) return null;
    _isGenerating = true;
    _generationProgress = 0;
    notifyListeners();

    _generationError = null;
    try {
      _generationProgress = .2;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400));
      _generationProgress = .6;
      notifyListeners();
      final resultImageUrl = await AiTryOnService().processVirtualTryOn(
        userPhotoPath: _currentUserPhotoPath!,
        garment: _selectedProduct!,
      );
      _generationProgress = 1;

      final model = AiTryOnModel(
        id: 'tryon_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'usr_1',
        productId: _selectedProduct!.id,
        productName: _selectedProduct!.name,
        productImage: _selectedProduct!.images.first,
        userPhotoUrl: _currentUserPhotoPath!,
        resultImageUrl: resultImageUrl,
        status: 'completed',
        createdAt: DateTime.now(),
      );

      _currentSession = model;
      _history.insert(0, model);
      return model;
    } on AiTryOnException catch (error) {
      _generationError = error.message;
      return null;
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _history = MockData.sampleTryOnHistory;
    notifyListeners();
  }

  void deleteHistory(String id) {
    _history.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void reset({bool keepPhoto = true}) {
    if (!keepPhoto) {
      _currentUserPhotoPath = null;
    }
    _selectedProduct = null;
    _currentSession = null;
    _generationError = null;
    notifyListeners();
  }
}

// ====================
// NOTIFICATIONS PROVIDER
// ====================
class NotificationsProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  List<NotificationModel> get notifications => _notifications;

  Future<void> loadNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notifications = MockData.sampleNotifications;
    notifyListeners();
  }

  void markAsRead(String id) {
    final n = _notifications.firstWhere((n) => n.id == id);
    _notifications[_notifications.indexOf(n)] = NotificationModel(
      id: n.id,
      title: n.title,
      body: n.body,
      type: n.type,
      isRead: true,
      createdAt: n.createdAt,
      data: n.data,
    );
    notifyListeners();
  }

  void markAllRead() {
    _notifications = _notifications
        .map(
          (n) => NotificationModel(
            id: n.id,
            title: n.title,
            body: n.body,
            type: n.type,
            isRead: true,
            createdAt: n.createdAt,
            data: n.data,
          ),
        )
        .toList();
    notifyListeners();
  }
}
