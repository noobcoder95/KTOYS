import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  String title;

  SearchHistory({required this.title});

  factory SearchHistory.fromJson(DocumentSnapshot json) {
    String title = '';

    try
    {
      title = json.get('title');
    }
    catch(e)
    {}

    return SearchHistory(title: title);
  }
}

class PopularSearch {
  String name, imageUrl, productId;

  PopularSearch({required this.name, required this.imageUrl, required this.productId});

  factory PopularSearch.fromJson(DocumentSnapshot json) {
    String name = '', imageUrl = '', productId = '';

    try
    {
      name = json.get('name');
    }
    catch(e)
    {}
    try
    {
      imageUrl = json.get('imageUrl');
    }
    catch(e)
    {}
    try
    {
      productId = json.get('productId');
    }
    catch(e)
    {}

    return PopularSearch(
        name: name,
        imageUrl: imageUrl,
        productId: productId);
  }
}
