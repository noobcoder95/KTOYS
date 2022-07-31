import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Cart.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/screens/order_success_page.dart';
import '../../constant/idr_currency.dart';
import '../../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> carts = [];
  int totalHarga = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text('Keranjang', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
            Text('${carts.length} Produk', style: TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.7))),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // Checkout Button
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColor.border, width: 1))),
        child: ElevatedButton(
          onPressed: () {
            if(totalHarga > 0)
            {
              for(int i = 0; i < carts.length; i++)
              {
                String timestamp = '${DateTime.now()}';
                FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Notifikasi').doc(timestamp).set({
                  'image_url': carts[i].image[0].toString(),
                  'title': '#${carts[i].id} - ${carts[i].name}',
                  'description': 'Produk berhasil dipesan! Terimakasih telah menggunakan layanan kami.',
                  'date_time': timestamp,
                }).then((value) => null);
              }
            }
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderSuccessPage()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'poppins'),
                ),
              ),
              Container(
                width: 2,
                height: 26,
                color: Colors.white.withOpacity(0.5),
              ),
              Flexible(
                flex: 6,
                child: Text(
                  CurrencyFormat.convertToIdr(totalHarga, 2),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, fontFamily: 'poppins'),
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            primary: AppColor.primary,
            elevation: 0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Keranjang').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {

            if(snapshot.data != null)
            {
              int length = snapshot.data!.docs.length;

              if(carts.length < 1)
              {
                for(int i = 0; i < length; i++)
                {
                  carts.add(Cart.fromJson(snapshot.data!.docs[i]));
                }
                hargaTotal();
              }
            }

            if(carts.length > 0)
            {
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.border, width: 1),
                        ),
                        child: Row(
                          children: [
                            // Image
                            Container(
                              width: 70,
                              height: 70,
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColor.border,
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(image: NetworkImage(carts[index].image[0]), fit: BoxFit.cover),
                              ),
                            ),
                            // Info
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Name
                                  Text(
                                    '${carts[index].name}',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'poppins', color: AppColor.secondary),
                                  ),
                                  // Product Price - Increment Decrement Button
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Product Price
                                        Expanded(
                                          child: Text(
                                            '${CurrencyFormat.convertToIdr(carts[index].price, 2)}',
                                            style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.primary),
                                          ),
                                        ),
                                        // Increment Decrement Button
                                        Container(
                                          height: 26,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: AppColor.primarySoft,
                                          ),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if(carts[index].stocks > 1)
                                                  {
                                                    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Keranjang').doc(carts[index].id).update({'stocks': carts[index].stocks - 1}).then((value) => setState(() {
                                                      carts = [];
                                                    }));
                                                  }
                                                },
                                                child: Container(
                                                  width: 26,
                                                  height: 26,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColor.primarySoft,
                                                  ),
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 8),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${carts[index].stocks}',
                                                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  FirebaseFirestore.instance.collection('products').doc(carts[index].id).get().then((snapshot) {
                                                    if(snapshot.exists)
                                                    {
                                                      Product data = Product.fromJson(snapshot);
                                                      if(carts[index].stocks < data.stocks)
                                                      {
                                                        FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Keranjang').doc(carts[index].id).update({'stocks': carts[index].stocks + 1}).then((value) => setState(() {
                                                          carts = [];
                                                        }));
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: 26,
                                                  height: 26,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColor.primarySoft,
                                                  ),
                                                  child: Text(
                                                    '+',
                                                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: carts.length,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColor.primarySoft,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        // header
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Informasi Pengiriman',
                                style: TextStyle(fontSize: 14, fontFamily: 'poppins', fontWeight: FontWeight.w600, color: AppColor.secondary),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: SvgPicture.asset(
                                  'assets/icons/Pencil.svg',
                                  width: 16,
                                  color: AppColor.secondary,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: AppColor.border,
                                  onPrimary: AppColor.primary,
                                  elevation: 0,
                                  padding: EdgeInsets.all(0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Name
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 12),
                                child: SvgPicture.asset('assets/icons/Profile.svg', width: 18),
                              ),
                              Expanded(
                                child: Text(
                                  namaLengkap!,
                                  style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Address
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 12),
                                child: SvgPicture.asset('assets/icons/Location.svg', width: 18),
                              ),
                              Expanded(
                                child: Text(
                                  alamatLengkap!,
                                  style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Phone Number
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 12),
                                child: SvgPicture.asset('assets/icons/Call.svg', width: 18),
                              ),
                              Expanded(
                                child: Text(
                                  auth.currentUser!.phoneNumber ?? '0851-5855-1280 ',
                                  style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColor.primarySoft,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                          // Content
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Detail Pemesanan', style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 10)),
                                  Text('Pengiriman', style: TextStyle(color: AppColor.secondary, fontWeight: FontWeight.w600, fontFamily: 'poppins')),
                                ],
                              ),
                              Text('Gratis', style: TextStyle(color: AppColor.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Pengiriman',
                                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.secondary),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        '3-5 Hari',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: AppColor.secondary.withOpacity(0.7)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Rp 0',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Subtotal',
                                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.secondary),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        '${carts.length} Produk',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: AppColor.secondary.withOpacity(0.7)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        CurrencyFormat.convertToIdr(totalHarga, 2),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
            else
            {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 164,
                      height: 164,
                      margin: EdgeInsets.only(bottom: 32),
                      child: SvgPicture.asset('assets/icons/Paper Bag.svg'),
                    ),
                    Text(
                      'Keranjang Kosong ☹️',
                      style: TextStyle(
                        color: AppColor.secondary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'poppins',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 48, top: 12),
                      child: Text(
                        'Kembali dan jelajahi hal-hal menarik produk kami \n dan tambahkan ke keranjang',
                        style: TextStyle(color: AppColor.secondary.withOpacity(0.8)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Mulai Belanja',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.secondary),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        primary: AppColor.border,
                        elevation: 0,
                        onPrimary: AppColor.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
              ),
            );
          }
        },
      ),
    );
  }

  void hargaTotal(){
    if(carts.length > 0)
    {
      int harga = 0;
      for(int i = 0; i < carts.length; i++)
      {
        harga = harga + (carts[i].price * carts[i].stocks);
      }
      totalHarga = harga;
      Future.delayed(Duration(seconds: 1), (){
        setState(() {});
      });
    }
  }
}
