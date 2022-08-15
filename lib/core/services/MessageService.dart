import 'package:marketky/core/model/Message.dart';

class MessageService {
  static List<Message> messageData = messageListRawData.map((data) => Message.fromJson(data)).toList();
}

var messageListRawData = [
  {
    'is_readed': true,
    'shop_logo_url': 'assets/images/ktoys_logo.jpg',
    'message': 'Menu Pesan Coming Soon',
    'shop_name': 'KTOYS Official Store',
  },
];
