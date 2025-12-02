class NewProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String subCategory;
  final String slug;
  final String? videoLink;
  final String address;
  final double latitude;
  final double longitude;
  final bool isPremium;
  final String contact;
  final String country;
  final String state;
  final String city;

  // Constructor
  NewProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.subCategory,
    required this.slug,
    this.videoLink,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isPremium,
    required this.contact,
    required this.country,
    required this.state,
    required this.city,
  });

  // Factory method to parse JSON data
  factory NewProductModel.fromJson(Map<String, dynamic> json) {
    return NewProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      slug: json['slug'] ?? '',
      videoLink: json['video_link'],
      address: json['address'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      isPremium: json['show_only_to_premium'] == 1,
      contact: json['contact'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
    );
  }

  // Convert to JSON (useful for posting data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toString(),
      'image': imageUrl,
      'category': category,
      'sub_category': subCategory,
      'slug': slug,
      'video_link': videoLink,
      'address': address,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'show_only_to_premium': isPremium ? 1 : 0,
      'contact': contact,
      'country': country,
      'state': state,
      'city': city,
    };
  }
}
