import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/ColorWay.dart';
import 'package:marketky/core/model/ProductSize.dart';
import 'package:marketky/views/screens/penjual/product_image_viewer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:path/path.dart' as path;
import '../../../main.dart';

class AddProduct extends StatefulWidget {

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  PageController productImageSlider = PageController();
  final ImagePicker _imgpicker = ImagePicker();
  List<XFile>? _imagefiles;
  List<ColorWay> warnaProduk = [];
  List<ProductSize> sizeProduk = [];
  List<Uint8List> _imageData = [];
  TextEditingController
  namaProduk = TextEditingController(),
  hargaProduk = TextEditingController(),
  deskripsiProduk = TextEditingController();
  int? _indexWarna, _indexSize;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColor.border, width: 1),
          ),
        ),
        child: SizedBox(
          height: 64,
          child: isLoading == false ?
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColor.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            onPressed: () async{
              if(warnaProduk.length > 0 && sizeProduk.length > 0 && _imageData.length == 2 && namaProduk.value.text.isNotEmpty && int.parse(hargaProduk.value.text) > 0 && deskripsiProduk.value.text.isNotEmpty)
              {
                setState(() {
                  isLoading = true;
                });
                List colors = [], sizes = [];
                for(int i = 0; i < warnaProduk.length; i++)
                {
                  colors.add({
                    'name': warnaProduk[i].name,
                    'color': warnaProduk[i].color.toString(),
                  });
                }
                for(int i = 0; i < sizeProduk.length; i++)
                {
                  sizes.add({
                    'name': sizeProduk[i].name,
                    'size': sizeProduk[i].size,
                  });
                }
                List<String>? _imgUrls;
                String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
                _imgUrls = await Future.wait(_imagefiles!.map((img) => uploadImage(File(img.path), timestamp)));
                if(_imgUrls != null && _imgUrls.length > 0)
                {
                  FirebaseFirestore.instance.collection('products').doc(timestamp).set({
                    'image': _imgUrls,
                    'name': namaProduk.value.text,
                    'price': int.parse(hargaProduk.value.text),
                    'rating': 5.0,
                    'stocks': 0,
                    'description': deskripsiProduk.value.text,
                    'store_name': namaLengkap,
                    'store_id': auth.currentUser!.uid,
                    'colors': colors,
                    'sizes': sizes,
                    'reviews': [
                      {
                        'photo_url': 'assets/images/avatar1.jpg',
                        'name': 'Uchiha Sasuke',
                        'review': 'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
                        'rating': 4.0,
                      },
                      {
                        'photo_url': 'assets/images/avatar2.jpg',
                        'name': 'Uzumaki Naruto',
                        'review': 'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
                        'rating': 4.0,
                      },
                      {
                        'photo_url': 'assets/images/avatar3.jpg',
                        'name': 'Kurokooo Tetsuya',
                        'review': 'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
                        'rating': 4.0,
                      },
                    ]
                  }).then((value) => Navigator.of(context).pop());
                }
              }
            },
            child: Text(
              'Simpan',
              style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
            ),
          ) :
          Center(child: CircularProgressIndicator()),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - appbar & product image
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // product image
              GestureDetector(
                onTap: () {
                  if(_imageData.length > 0)
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageDataViewer(imageData: _imageData),
                      ),
                    );
                  }
                  else
                  {
                    getImage();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  color: Colors.white,
                  child: _imageData.length > 0 ?
                  PageView(
                    physics: BouncingScrollPhysics(),
                    controller: productImageSlider,
                    children: List.generate(
                      _imageData.length,
                          (index) => Image.memory(
                        _imageData[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) :
                  Center(
                    child: Text('Tambahkan Gambar Produk'),
                  ),
                ),
              ),
              // appbar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 54,
                  margin: EdgeInsets.only(top: 14),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: ()=> Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            primary: AppColor.primarySoft,
                            elevation: 0,
                            onPrimary: AppColor.primary,
                            padding: EdgeInsets.all(8),
                          ),
                          child: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 5.5 / 10,
                        height: 40,
                        decoration: BoxDecoration(color: AppColor.primarySoft, borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        child: Text(
                          'Tambah Produk',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // indicator
              Positioned(
                bottom: 16,
                child: SmoothPageIndicator(
                  controller: productImageSlider,
                  count: _imageData.length,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColor.primary.withOpacity(0.2),
                    activeDotColor: AppColor.primary.withOpacity(0.2),
                    dotHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - product info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 14),
                    child: TextField(
                      controller: namaProduk,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Nama Produk',
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: AppColor.primarySoft,
                        filled: true,
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 14),
                  child: TextField(
                    controller: hargaProduk,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: hargaProduk.value.text.isNotEmpty ? 'Rp. ' : null,
                      hintText: 'Harga Produk',
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.border, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.primary, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: AppColor.primarySoft,
                      filled: true,
                    ),
                  )
                ),
                TextField(
                  controller: deskripsiProduk,
                  maxLines: null,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi Produk',
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.border, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColor.primarySoft,
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
          // Section 3 - Color Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warna',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: listWarnaProduk(),
                  ),
                ),
              ],
            ),
          ),

          // Section 4 - Size Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ukuran',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: listSizeProduk(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getImage() async
  {
    try {
      List<XFile>? _pickedfiles = await _imgpicker.pickMultiImage();
      if(_pickedfiles != null)
      {
        if(_pickedfiles.length < 3 && _pickedfiles.length > 1)
        {
          setState(()
          {
            _imageData.clear();
            _imagefiles = _pickedfiles;
            for(int i = 0; i < _pickedfiles.length; i++)
            {
              _imageData.add(File(_pickedfiles[i].path).readAsBytesSync());
            }
          });
        }
        else
        {
          snackBar('Pilih 2 Gambar Produk!');
        }
      }
      else
      {
        snackBar('Belum ada foto yang dipilih!');
      }
    }
    catch (e)
    {
      snackBar('Terjadi kesalahan: ' + e.toString());
    }
  }

  List<Widget> listWarnaProduk()
  {
    List<Widget> widget = List.generate(
      warnaProduk.length,
          (index) {
        return InkWell(
          onTap: () {
            setState(() {
              _indexWarna = index;
            });
          },
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 2, color: AppColor.primarySoft), borderRadius: BorderRadius.circular(100)),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: warnaProduk[index].color,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 4,
                  color: (index == _indexWarna) ? AppColor.primarySoft.withOpacity(0.9) : Colors.transparent,
                ),
              ),
            ),
          ),
        );
      },
    );
    widget.add(InkWell(
      onTap: () {
        Color color = Colors.white;
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: Text('Pilih Warna!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: color,
                      onColorChanged: (c){
                        color = c;
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('Tambahkan'),
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        ColorWay colorProduk = ColorWay.fromJson({
                        'name': color.toString(),
                        'color': color,
                        });
                        setState(() => warnaProduk.add(colorProduk));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 2, color: AppColor.primarySoft), borderRadius: BorderRadius.circular(100)),
        child: Container(
          alignment: Alignment.topCenter,
          width: 42,
          height: 42,
          child: Text('+', style: TextStyle(fontSize: 28, color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    ));

    return widget;
  }

  List<Widget> listSizeProduk()
  {
    List<Widget> widget = List.generate(
      sizeProduk.length,
          (index) {
        return InkWell(
          onTap: () {
            setState(() {
              _indexSize = index;
            });
          },
          child: Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: (index == _indexSize) ? AppColor.secondary : AppColor.primarySoft,
            ),
            child: Text(
              '${sizeProduk[index].name}',
              style: (index == _indexSize) ? TextStyle(color: Colors.white, fontWeight: FontWeight.w600) : TextStyle(color: AppColor.primary, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
    widget.add(InkWell(
      onTap: () {
        TextEditingController size = TextEditingController();
        showDialog(
          context: context,
          builder: (context) =>
            AlertDialog(
              title: Text('Ukuran Produk'),
              content: TextField(
                controller: size,
                decoration: InputDecoration(hintText: "Masukkan ukuran"),
                keyboardType: TextInputType.number,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Tambahkan'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if(size.value.text.isNotEmpty)
                    {
                      ProductSize ukuran = ProductSize(size: double.parse(size.value.text).toString(), name: size.value.text);
                      sizeProduk.add(ukuran);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ));
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 2, color: AppColor.primarySoft), borderRadius: BorderRadius.circular(100)),
        child: Container(
          alignment: Alignment.topCenter,
          width: 42,
          height: 42,
          child: Text('+', style: TextStyle(fontSize: 28, color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    ));
    return widget;
  }

  void snackBar(String text)
  {
    final snackBar = SnackBar(
      backgroundColor: Color(0xff029bd7),
      content: Text('$text'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<String> uploadImage(File img, String destUID) async
  {
    String _uid = auth.currentUser!.uid;
    Reference reference = FirebaseStorage.instance.ref().child('products/images/$_uid/$destUID/' + path.basename(img.path));
    UploadTask uploadTask = reference.putData(img.readAsBytesSync());
    await uploadTask.whenComplete(() => null);
    return await reference.getDownloadURL();
  }
}
