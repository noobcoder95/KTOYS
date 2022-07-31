import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  String imageUrl;
  String title;
  String description;
  DateTime dateTime;

  UserNotification({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory UserNotification.fromJson(DocumentSnapshot json) {
    String imageUrl = '';
    String title = '';
    String description = '';
    DateTime dateTime = DateTime.now();

    try
    {
      imageUrl = json.get('image_url');
    }
    catch(e)
    {}
    try
    {
      title = json.get('title');
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
      dateTime = DateTime.parse(json.get('date_time'));
    }
    catch(e)
    {}

    return UserNotification(
      imageUrl: imageUrl,
      title: title,
      description: description,
      dateTime: dateTime,
    );
  }
}
