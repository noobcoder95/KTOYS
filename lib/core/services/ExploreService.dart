import 'package:marketky/core/model/ExploreItem.dart';
import 'package:marketky/core/model/ExploreUpdate.dart';

class ExploreService {
  static List<ExploreItem> listExploreItem = listExploreItemRawData.map((data) => ExploreItem.fromJson(data)).toList();
  static List<ExploreUpdate> listExploreUpdateItem = listExploreUpdateItemRawData.map((data) => ExploreUpdate.fromJson(data)).toList();
}

var listExploreItemRawData = [
  {'image_url': 'assets/images/explore1.jpg'},
  {'image_url': 'assets/images/explore2.jpg'},
  {'image_url': 'assets/images/explore3.jpg'},
  {'image_url': 'assets/images/explore4.jpg'},
  {'image_url': 'assets/images/explore5.jpg'},
  {'image_url': 'assets/images/explore6.jpg'},
  {'image_url': 'assets/images/explore7.jpg'},
  {'image_url': 'assets/images/explore8.jpg'},
  {'image_url': 'assets/images/explore9.jpg'},
  {'image_url': 'assets/images/explore10.jpg'},
  {'image_url': 'assets/images/explore11.jpg'},
  {'image_url': 'assets/images/explore12.jpg'},
  {'image_url': 'assets/images/explore13.jpg'},
  {'image_url': 'assets/images/explore14.jpg'},
  {'image_url': 'assets/images/explore15.jpg'},
  {'image_url': 'assets/images/explore16.jpg'},
];

var listExploreUpdateItemRawData = [
  {
    'logo_url': 'assets/images/ktoys_info.jpg',
    'image': 'assets/images/ktoys_info.jpg',
    'store_name': 'KTOYS STORE',
    'caption': 'Toko mainan KToys menyediakan mainan berbagai macan ukuran dan berbagai macam fariasi dengan harga yang sangat terjangkau untuk kalangan menengah kebawah.Toko mainan KToys menyediakan mainan berbagai macan ukuran dan berbagai macam fariasi dengan harga yang sangat terjangkau untuk kalangan menengah kebawah.',
  },
  {
    'logo_url': 'assets/images/ktoys_info.jpg',
    'image': 'assets/images/toko_fisik.jpeg',
    'store_name': 'KTOYS STORE',
    'caption':
        'Usaha toko mainan Ktoys Bekasi berdiri pada tahun Januari 2019, yang di dirikan oleh pak Rio Nugroho. Berlokasi di Bakti Jaya Raya No.1, RT.005/RW.024, Harapan Jaya, Kec. Bekasi Utara, Kota Bekasi, Jawa Barat.',
  },
];
