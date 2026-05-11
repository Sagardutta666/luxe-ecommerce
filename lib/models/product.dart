class Product {
  final String id;
  final String name;
  final String price;
  final double priceValue;
  final String image;
  final String category;
  final double rating;
  final String dealerName;
  final String description;
  final List<String> specifications;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.priceValue,
    required this.image,
    required this.category,
    required this.rating,
    required this.dealerName,
    required this.description,
    required this.specifications,
  });
}

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Premium Wireless Headphones',
    price: '₹24,900',
    priceValue: 24900.0,
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
    category: 'Headphones',
    rating: 4.8,
    dealerName: 'Audio Hub',
    description: 'Experience studio-quality sound with our latest noise-canceling technology.',
    specifications: ['40h Battery', 'Bluetooth 5.2', 'Active Noise Canceling'],
  ),
  Product(
    id: '2',
    name: 'Modern Smart Watch',
    price: '₹16,500',
    priceValue: 16500.0,
    image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80',
    category: 'Wearables',
    rating: 4.5,
    dealerName: 'Tech Time',
    description: 'Stay connected and track your health with this sleek, modern smartwatch.',
    specifications: ['Heart Rate Monitor', 'GPS', 'Water Resistant'],
  ),
  Product(
    id: '3',
    name: 'Leather Weekend Bag',
    price: '₹12,500',
    priceValue: 12500.0,
    image: 'https://images.unsplash.com/photo-1547949003-9792a18a2601?w=500&q=80',
    category: 'Accessories',
    rating: 4.7,
    dealerName: 'Heritage Leather',
    description: 'Handcrafted from genuine leather, perfect for your weekend getaways.',
    specifications: ['Genuine Leather', '30L Capacity', 'Adjustable Strap'],
  ),
  Product(
    id: '4',
    name: 'Minimalist Desk Lamp',
    price: '₹7,400',
    priceValue: 7400.0,
    image: 'https://images.unsplash.com/photo-1534073828943-f801091bb18c?w=500&q=80',
    category: 'Home Decor',
    rating: 4.3,
    dealerName: 'Bright Living',
    description: 'Illuminate your workspace with style using our energy-efficient LED desk lamp.',
    specifications: ['LED', 'Touch Control', 'Adjustable Brightness'],
  ),
  Product(
    id: '5',
    name: 'Mechanical Keyboard',
    price: '₹10,700',
    priceValue: 10700.0,
    image: 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?w=500&q=80',
    category: 'Accessories',
    rating: 4.9,
    dealerName: 'Key Enthusiasts',
    description: 'Tactile feedback and RGB lighting for the ultimate typing experience.',
    specifications: ['Cherry MX Blue', 'RGB Lighting', 'Braided Cable'],
  ),
  Product(
    id: '6',
    name: 'Ultra Slim Laptop',
    price: '₹99,600',
    priceValue: 99600.0,
    image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&q=80',
    category: 'Laptops',
    rating: 4.6,
    dealerName: 'Compute Direct',
    description: 'Powerful performance meet elegant design in our thinnest laptop yet.',
    specifications: ['16GB RAM', '512GB SSD', 'Intel i7'],
  ),
];
