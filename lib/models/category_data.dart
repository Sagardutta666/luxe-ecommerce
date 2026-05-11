import 'dart:math';
import 'product.dart';

String _inr(double amount) {
  final n = amount.toInt();
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '₹${buf.toString()}';
}

class CategoryData {
  static const List<String> categories = [
    'Mobiles',
    'Electronics',
    'Beauty',
    'Makeup',
    'Fashion',
    'Home',
    'Appliances',
    'Grocery',
    'Vegetables',
    'Sports',
  ];

  static const _mobileImgs = [
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
    'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
    'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400',
    'https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=400',
    'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=400',
    'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=400',
  ];

  static const _electronicsImgs = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400',
    'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
    'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=400',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
  ];

  static const _beautyImgs = [
    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400',
    'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
    'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400',
    'https://images.unsplash.com/photo-1583209814683-c81b7a7c5e60?w=400',
    'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',
    'https://images.unsplash.com/photo-1512207736890-6ffed8a84e8d?w=400',
  ];

  static const _makeupImgs = [
    'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
    'https://images.unsplash.com/photo-1512207736890-6ffed8a84e8d?w=400',
    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400',
    'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400',
    'https://images.unsplash.com/photo-1583209814683-c81b7a7c5e60?w=400',
    'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',
  ];

  static const _fashionImgs = [
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=400',
    'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400',
    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
  ];

  static const _homeImgs = [
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=400',
    'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
    'https://images.unsplash.com/photo-1565183997392-2f6f122e5912?w=400',
    'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=400',
  ];

  static const _appliancesImgs = [
    'https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?w=400',
    'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=400',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    'https://images.unsplash.com/photo-1556909172-54557c7e4fb7?w=400',
    'https://images.unsplash.com/photo-1601598851547-4302969d0614?w=400',
    'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=400',
  ];

  static const _groceryImgs = [
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    'https://images.unsplash.com/photo-1506617564039-2f3b650b7010?w=400',
    'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=400',
    'https://images.unsplash.com/photo-1519996529931-28324d5a630e?w=400',
    'https://images.unsplash.com/photo-1553546895-531931aa1aa8?w=400',
    'https://images.unsplash.com/photo-1564894809611-1742fc40ed80?w=400',
  ];

  static const _vegetablesImgs = [
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
    'https://images.unsplash.com/photo-1447175008436-054170c2e979?w=400',
    'https://images.unsplash.com/photo-1574316071802-0d684efa7bf5?w=400',
    'https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=400',
    'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400',
  ];

  static const _sportsImgs = [
    'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=400',
    'https://images.unsplash.com/photo-1556906781-9a412961a28c?w=400',
    'https://images.unsplash.com/photo-1521614107793-b9e019e66ca6?w=400',
    'https://images.unsplash.com/photo-1524901548305-08eeddc35080?w=400',
    'https://images.unsplash.com/photo-1591258370814-01609b341790?w=400',
    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=400',
  ];

  static List<Product> generateProducts() {
    final products = <Product>[];
    final rng = Random(42);

    for (final cat in categories) {
      final imgs = _imgsFor(cat);
      for (int i = 1; i <= 50; i++) {
        final price =
            ((rng.nextDouble() * 79500 + 500) / 100).round() * 100.0;
        products.add(Product(
          id: '${cat.toLowerCase()}_$i',
          name: _nameFor(cat, i),
          price: _inr(price),
          priceValue: price,
          image: imgs[(i - 1) % imgs.length],
          category: cat,
          dealerName: 'Luxe Official Store',
          description: 'Premium $cat product, crafted for performance and style.',
          specifications: const [
            'Premium Material',
            'High Performance',
            '1 Year Warranty',
            'Sleek Design',
          ],
          rating: 4.2 + rng.nextDouble() * 0.8,
        ));
      }
    }
    return products;
  }

  static List<String> _imgsFor(String cat) {
    switch (cat) {
      case 'Mobiles':     return _mobileImgs;
      case 'Electronics': return _electronicsImgs;
      case 'Beauty':      return _beautyImgs;
      case 'Makeup':      return _makeupImgs;
      case 'Fashion':     return _fashionImgs;
      case 'Home':        return _homeImgs;
      case 'Appliances':  return _appliancesImgs;
      case 'Grocery':     return _groceryImgs;
      case 'Vegetables':  return _vegetablesImgs;
      case 'Sports':      return _sportsImgs;
      default:            return _appliancesImgs;
    }
  }

  static String _nameFor(String cat, int i) {
    const mobileNames = [
      'Galaxy Ultra', 'ProMax 15', 'Pixel 9 Pro', 'Edge 50', 'Find X7',
      'Reno 12', 'Nord 4', 'GT Neo 6', 'V30 Pro', 'Zenfone 11',
    ];
    const electronicsNames = [
      'ANC Headphones', 'Smart Watch', 'Slim Laptop', 'Wireless Earbuds',
      'Gaming Mouse', '4K Monitor', 'Mechanical Keyboard', 'Webcam HD',
      'Smart Speaker', 'USB-C Hub',
    ];
    const beautyNames = [
      'Vitamin C Serum', 'Hydra Moisturiser', 'Matte Lipstick',
      'Eye Palette', 'Glow Foundation', 'Retinol Cream', 'Hair Mask',
      'Body Lotion', 'Perfume Eau', 'Nail Polish Set',
    ];
    const makeupNames = [
      'HD Foundation', 'Contour Kit', 'Liquid Lipstick', 'Setting Spray',
      'Brow Pencil', 'Highlighter Palette', 'Mascara Pro', 'Blush Duo',
      'Eye Liner Gel', 'Primer Base',
    ];
    const fashionNames = [
      'Slim Chinos', 'Linen Shirt', 'Leather Sneakers', 'Wool Blazer',
      'Denim Jacket', 'Maxi Dress', 'Ankle Boots', 'Silk Scarf',
      'Canvas Tote', 'Bucket Hat',
    ];
    const homeNames = [
      'Candle Set', 'Throw Pillow', 'Wall Clock', 'Vase Collection',
      'Table Lamp', 'Picture Frame', 'Mirror Accent', 'Rug Runner',
      'Planter Set', 'Storage Basket',
    ];
    const appliancesNames = [
      'Air Fryer', 'Coffee Maker', 'Blender Pro', 'Rice Cooker',
      'Toaster Oven', 'Dishwasher', 'Vacuum Robot', 'Air Purifier',
      'Water Purifier', 'Microwave',
    ];
    const groceryNames = [
      'Organic Oats', 'Cold Brew Coffee', 'Artisan Bread', 'Almond Milk',
      'Greek Yogurt', 'Pasta Pack', 'Olive Oil', 'Dark Chocolate',
      'Mixed Nuts', 'Honey Jar',
    ];
    const vegetablesNames = [
      'Broccoli Crown', 'Baby Spinach', 'Cherry Tomatoes', 'Bell Peppers',
      'Sweet Corn', 'Zucchini', 'Baby Carrots', 'Kale Bunch',
      'Cucumber Pack', 'Mushroom Mix',
    ];
    const sportsNames = [
      'Running Shoes', 'Yoga Mat', 'Resistance Bands', 'Gym Gloves',
      'Water Bottle', 'Jump Rope', 'Dumbbell Set', 'Fitness Tracker',
      'Sports Jersey', 'Foam Roller',
    ];

    List<String> pool;
    switch (cat) {
      case 'Mobiles':     pool = mobileNames; break;
      case 'Electronics': pool = electronicsNames; break;
      case 'Beauty':      pool = beautyNames; break;
      case 'Makeup':      pool = makeupNames; break;
      case 'Fashion':     pool = fashionNames; break;
      case 'Home':        pool = homeNames; break;
      case 'Appliances':  pool = appliancesNames; break;
      case 'Grocery':     pool = groceryNames; break;
      case 'Vegetables':  pool = vegetablesNames; break;
      case 'Sports':      pool = sportsNames; break;
      default:            pool = appliancesNames;
    }
    return '${pool[(i - 1) % pool.length]} ${((i - 1) ~/ pool.length) + 1}';
  }
}

final List<Product> bulkProducts = CategoryData.generateProducts();
