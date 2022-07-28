import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  List image;
  String name, id;
  int timestamp, price, stocks;

  Cart({
    required this.id,
    required this.timestamp,
    required this.image,
    required this.name,
    required this.price,
    required this.stocks,
  });

  factory Cart.fromJson(DocumentSnapshot doc) {
    List image = [];
    String name = '';
    int price = 0, timestamp = 0, stocks = 0;
    try
    {
      image = doc.get('image');
    }
    catch(e)
    {}
    try
    {
      timestamp = doc.get('timestamp');
    }
    catch(e)
    {}
    try
    {
      name = doc.get('name');
    }
    catch(e)
    {}
    try
    {
      price = doc.get('price');
    }
    catch(e)
    {}
    try
    {
      stocks = doc.get('stocks');
    }
    catch(e)
    {}
    return Cart(
      timestamp: timestamp,
      id: doc.id,
      image: image,
      name: name,
      price: price,
      stocks: stocks,
    );
  }
}
