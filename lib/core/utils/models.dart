// Models for WedStyle

class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String? gender;
  final String? weddingDate;
  final String? city;
  final String? profileImage;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    this.gender,
    this.weddingDate,
    this.city,
    this.profileImage,
    this.role = 'customer',
    this.isActive = true,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'],
      weddingDate: json['weddingDate'],
      city: json['city'],
      profileImage: json['profileImage'],
      role: json['role'] ?? 'customer',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'mobile': mobile,
    'gender': gender,
    'weddingDate': weddingDate,
    'city': city,
    'profileImage': profileImage,
    'role': role,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  String? get profilePhoto => profileImage;

  UserModel copyWith({
    String? name, String? email, String? mobile, String? gender,
    String? weddingDate, String? city, String? profileImage,
  }) => UserModel(
    id: id, name: name ?? this.name, email: email ?? this.email,
    mobile: mobile ?? this.mobile, gender: gender ?? this.gender,
    weddingDate: weddingDate ?? this.weddingDate, city: city ?? this.city,
    profileImage: profileImage ?? this.profileImage, role: role,
    isActive: isActive, createdAt: createdAt,
  );
}

class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final String categoryName;
  final String? subcategoryId;
  final String description;
  final double price;
  final double discountedPrice;
  final int discountPercent;
  final List<String> images;
  final String? video;
  final List<String> sizes;
  final List<String> colors;
  final String material;
  final String fabric;
  final String occasion;
  final String gender;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isActive;
  final bool aiTryOnEnabled;
  final String? sku;
  final List<String> careInstructions;

  final String region;
  final String embroidery;
  final String fabricType;
  final List<String> occasionsList;
  final String deliveryInfo;
  final String returnPolicy;

  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    String? categoryId,
    String? categoryName,
    String? category,
    this.subcategoryId,
    required this.description,
    required this.price,
    double? discountedPrice,
    double? originalPrice,
    int? discountPercent,
    required this.images,
    this.video,
    required this.sizes,
    required this.colors,
    String? material,
    required this.fabric,
    String? occasion,
    List<String>? occasions,
    required this.gender,
    this.region = 'All India',
    this.embroidery = 'Zari & Zardozi Handwork',
    String? fabricType,
    String? deliveryInfo,
    String? returnPolicy,
    this.rating = 4.8,
    this.reviewCount = 0,
    this.stock = 100,
    bool? inStock,
    this.isActive = true,
    bool? hasAiTryOn,
    this.aiTryOnEnabled = true,
    this.sku,
    this.careInstructions = const ['Dry Clean Only', 'Store in cotton garment bag', 'Avoid direct perfume contact'],
  })  : categoryId = categoryId ?? 'cat_general',
        categoryName = categoryName ?? (category ?? 'Bridal'),
        discountedPrice = discountedPrice ?? price,
        discountPercent = discountPercent ?? 0,
        material = material ?? fabric,
        fabricType = fabricType ?? fabric,
        occasionsList = occasions ?? (occasion != null ? [occasion, 'Wedding'] : ['Wedding', 'Reception']),
        deliveryInfo = deliveryInfo ?? 'Delivered in 3-5 business days • Free Express Air for VIP Brides',
        returnPolicy = returnPolicy ?? '7-day hassle-free replacement or full refund',
        occasion = occasion ?? (occasions != null && occasions.isNotEmpty ? occasions.first : 'Wedding');

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      subcategoryId: json['subcategoryId'],
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      discountPercent: json['discountPercent'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      video: json['video'],
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      material: json['material'] ?? '',
      fabric: json['fabric'] ?? '',
      occasion: json['occasion'] ?? '',
      gender: json['gender'] ?? 'unisex',
      region: json['region'] ?? 'All India',
      embroidery: json['embroidery'] ?? 'Handcrafted Zari',
      fabricType: json['fabricType'] ?? (json['fabric'] ?? 'Silk'),
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      stock: json['stock'] ?? 100,
      isActive: json['isActive'] ?? true,
      aiTryOnEnabled: json['aiTryOnEnabled'] ?? true,
      sku: json['sku'],
      careInstructions: List<String>.from(json['careInstructions'] ?? []),
    );
  }

  // Helper getters & aliases
  String get category => categoryName;
  List<String> get occasions => [occasion, 'Wedding', 'Reception'];
  double get originalPrice => price;
  bool get inStock => stock > 0 && isActive;
  bool get hasAiTryOn => aiTryOnEnabled;

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? categoryId,
    String? categoryName,
    String? subcategoryId,
    String? description,
    double? price,
    double? discountedPrice,
    int? discountPercent,
    List<String>? images,
    String? video,
    List<String>? sizes,
    List<String>? colors,
    String? material,
    String? fabric,
    String? occasion,
    List<String>? occasions,
    String? gender,
    double? rating,
    int? reviewCount,
    int? stock,
    bool? inStock,
    bool? isActive,
    bool? hasAiTryOn,
    bool? aiTryOnEnabled,
    String? sku,
    List<String>? careInstructions,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      images: images ?? this.images,
      video: video ?? this.video,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      material: material ?? this.material,
      fabric: fabric ?? this.fabric,
      occasion: occasion ?? (occasions != null && occasions.isNotEmpty ? occasions.first : this.occasion),
      gender: gender ?? this.gender,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: inStock != null ? (inStock ? 100 : 0) : (stock ?? this.stock),
      isActive: isActive ?? (inStock ?? this.isActive),
      aiTryOnEnabled: hasAiTryOn ?? (aiTryOnEnabled ?? this.aiTryOnEnabled),
      sku: sku ?? this.sku,
      careInstructions: careInstructions ?? this.careInstructions,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? icon;
  final String gender; // women, men, accessories, all
  final int productCount;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.icon,
    required this.gender,
    this.productCount = 0,
    this.isActive = true,
  });
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final AddressModel address;
  final double subtotal;
  final double discount;
  final double deliveryCharge;
  final double couponDiscount;
  final double tax;
  final double total;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final String? trackingId;
  final String deliveryType;
  final String? couponCode;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.subtotal,
    this.discount = 0,
    this.deliveryCharge = 0,
    this.couponDiscount = 0,
    this.tax = 0,
    required this.total,
    required this.status,
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    required this.createdAt,
    this.trackingId,
    this.deliveryType = 'standard',
    this.couponCode,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItemModel>? items,
    AddressModel? address,
    double? subtotal,
    double? discount,
    double? deliveryCharge,
    double? couponDiscount,
    double? tax,
    double? total,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? createdAt,
    String? trackingId,
    String? deliveryType,
    String? couponCode,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      address: address ?? this.address,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      trackingId: trackingId ?? this.trackingId,
      deliveryType: deliveryType ?? this.deliveryType,
      couponCode: couponCode ?? this.couponCode,
    );
  }
}

// Convenient Model Aliases
typedef User = UserModel;
typedef Product = ProductModel;
typedef Category = CategoryModel;
typedef Order = OrderModel;
typedef OrderItem = OrderItemModel;
typedef CartItem = CartItemModel;
typedef Address = AddressModel;
typedef Coupon = CouponModel;
typedef AiTryOnItem = AiTryOnModel;
typedef Review = ReviewModel;
typedef NotificationItemModel = NotificationModel;
typedef PromoBanner = BannerModel;

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String brand;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final double total;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.brand,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    required this.total,
  });
}

class CartItemModel {
  final String id;
  final ProductModel product;
  int quantity;
  String selectedSize;
  String selectedColor;

  CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get total => product.discountedPrice * quantity;
}

class AddressModel {
  final String id;
  final String name;
  final String mobile;
  final String house;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.house,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });
}

class CouponModel {
  final String id;
  final String code;
  final String discountType; // percentage / fixed
  final double discountValue;
  final double minOrder;
  final double maxDiscount;
  final DateTime startDate;
  final DateTime expiryDate;
  final int usageLimit;
  final int usedCount;
  final bool isActive;
  final String description;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.minOrder,
    required this.maxDiscount,
    required this.startDate,
    required this.expiryDate,
    required this.usageLimit,
    this.usedCount = 0,
    this.isActive = true,
    required this.description,
  });

  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(expiryDate) &&
        usedCount < usageLimit;
  }

  double calculateDiscount(double orderAmount) {
    if (!isValid || orderAmount < minOrder) return 0;
    if (discountType == 'percentage') {
      final disc = orderAmount * discountValue / 100;
      return disc > maxDiscount ? maxDiscount : disc;
    }
    return discountValue > maxDiscount ? maxDiscount : discountValue;
  }
}

class AiTryOnModel {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final String userPhotoUrl;
  final String? resultImageUrl;
  final String status; // processing, completed, failed
  final DateTime createdAt;
  final bool isSaved;

  AiTryOnModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.userPhotoUrl,
    this.resultImageUrl,
    required this.status,
    required this.createdAt,
    this.isSaved = false,
  });
}

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final String productId;
  final double rating;
  final String comment;
  final List<String> images;
  final String? aiTryOnImageUrl;
  final DateTime createdAt;
  final bool isVerified;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.productId,
    required this.rating,
    required this.comment,
    this.images = const [],
    this.aiTryOnImageUrl,
    required this.createdAt,
    this.isVerified = false,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });
}

class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? actionUrl;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.actionUrl,
    this.isActive = true,
  });
}

class AiServiceConfigModel {
  String apiKey;
  String provider; // 'FASHN.ai', 'Replicate-Kolors', 'Stable Diffusion Inpainting', 'WedStyle Cloud Engine'
  String endpointUrl;
  bool isEnabled;
  String modelName;
  double faceFidelityWeight;
  double garmentDrapePhysics;

  AiServiceConfigModel({
    this.apiKey = '',
    this.provider = 'WedStyle Neural TryOn v2.4 (High Precision)',
    this.endpointUrl = 'https://api.wedstyle.luxury/v2/tryon',
    this.isEnabled = true,
    this.modelName = 'kolors-virtual-tryon-pro',
    this.faceFidelityWeight = 0.98,
    this.garmentDrapePhysics = 0.95,
  });

  bool get isConfigured => apiKey.isNotEmpty || isEnabled;
}

class LookRecommendationModel {
  final String title;
  final String occasion;
  final String gender;
  final String colorTheme;
  final double estimatedBudget;
  final ProductModel outfit;
  final ProductModel? jewellery;
  final ProductModel? footwear;
  final ProductModel? accessory;

  LookRecommendationModel({
    required this.title,
    required this.occasion,
    required this.gender,
    required this.colorTheme,
    required this.estimatedBudget,
    required this.outfit,
    this.jewellery,
    this.footwear,
    this.accessory,
  });

  double get grandTotal {
    double sum = outfit.discountedPrice;
    if (jewellery != null) sum += jewellery!.discountedPrice;
    if (footwear != null) sum += footwear!.discountedPrice;
    if (accessory != null) sum += accessory!.discountedPrice;
    return sum;
  }
}

