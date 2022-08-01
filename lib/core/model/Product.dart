import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketky/core/model/ColorWay.dart';
import 'package:marketky/core/model/ProductSize.dart';
import 'package:marketky/core/model/Review.dart';

class Product {
  List<String> image;
  String name;
  int price, stocks;
  double rating;
  String description;
  List<ColorWay> colors;
  List<ProductSize> sizes;
  List<Review> reviews;
  String storeName, storeId, productId;

  Product({
    required this.productId,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.reviews,
    required this.storeName,
    required this.stocks,
    required this.storeId
  });

  factory Product.fromDocument(DocumentSnapshot json) {

    List<String> image = [];
    String name = '';
    int price = 0, stocks = 0;
    double rating = 0;
    String description = '';
    List<ColorWay> colors = [];
    List<ProductSize> sizes = [];
    List<Review> reviews = [];
    String storeName = '', storeId = '';

    try
    {
      image = (json.get('image') as List).map((data) => data.toString()).toList();
    }
    catch(e)
    {}
    try
    {
      name = json.get('name');
    }
    catch(e)
    {}
    try
    {
      stocks = json.get('stocks');
    }
    catch(e)
    {}
    try
    {
      price = json.get('price');
    }
    catch(e)
    {}
    try
    {
      rating = json.get('rating');
    }
    catch(e)
    {}
    try
    {
      description = json.get('description');
    }
    catch(e)
    {}
    try
    {
      colors = (json.get('colors') as List).map((data) => ColorWay.fromJson(data)).toList();
    }
    catch(e)
    {}
    try
    {
      sizes = (json.get('sizes') as List).map((data) => ProductSize.fromJson(data)).toList();
    }
    catch(e)
    {}
    try
    {
      reviews = (json.get('reviews') as List).map((data) => Review.fromJson(data)).toList();
    }
    catch(e)
    {}
    try
    {
      storeName = json.get('store_name');
    }
    catch(e)
    {}
    try
    {
      storeId = json.get('store_id');
    }
    catch(e)
    {}

    return Product(
      productId: json.id,
      image: image,
      name: name,
      stocks: stocks,
      price: price,
      rating: rating,
      description: description,
      colors: colors,
      sizes: sizes,
      reviews: reviews,
      storeName: storeName,
      storeId: storeId
    );
  }
}
