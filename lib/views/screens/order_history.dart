import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketky/constant/factory.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/screens/product_detail.dart';

import '../../constant/app_color.dart';
import '../../constant/idr_currency.dart';
import '../../main.dart';

class OrderPage extends StatefulWidget
{
  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Daftar Pesanan', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pesanan').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DataPesanan> products = [];
            if(snapshot.data != null)
            {
              int length = snapshot.data!.docs.length;

              for(int i = 0; i < length; i++)
              {
                DataPesanan product = DataPesanan.fromDocument(snapshot.data!.docs[i]);
                if(product.idPemesan == auth.currentUser!.uid)
                {
                  products.add(DataPesanan.fromDocument(snapshot.data!.docs[i]));
                }
              }
            }

            if(products.length > 0)
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
                      return GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: products[index].tanggalPengiriman != null && products[index].resiPengiriman != null && products[index].resiPengiriman!.isNotEmpty ?
                          230 : 170,
                          padding: EdgeInsets.only(top: 5, left: 5, right: 12),
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
                                  image: DecorationImage(image: NetworkImage(products[index].imageUrl), fit: BoxFit.cover),
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
                                      '${products[index].namaProduk}',
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
                                              '${CurrencyFormat.convertToIdr(products[index].totalHarga, 2)}',
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
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '${products[index].jumlahItem} Item',
                                                style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 2, bottom: 8),
                                      child: Text(
                                        'Tanggal Pemesanan:\n${products[index].tanggalPemesanan.toString().split('.')[0]}',
                                        style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                      ),
                                    ),
                                    products[index].tanggalPengiriman != null && products[index].resiPengiriman != null && products[index].resiPengiriman!.isNotEmpty ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 2, bottom: 8),
                                          child: Text(
                                            'Tanggal Pengiriman:\n${products[index].tanggalPengiriman.toString().split('.')[0]}',
                                            style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 2, bottom: 8),
                                          child: Text(
                                            'Resi Pengiriman:\n${products[index].resiPengiriman}',
                                            style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ) :
                                    products[index].statusPesanan != 'cancel' ?
                                    Container(
                                      margin: EdgeInsets.only(top: 2, bottom: 8),
                                      child: Text(
                                        'Status Pesanan:\nPesanan sementara disiapkan.',
                                        style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                      ),
                                    ) :
                                    Container(
                                      margin: EdgeInsets.only(top: 2, bottom: 8),
                                      child: Text(
                                        'Status Pesanan:\nPesanan telah dibatalkan.',
                                        style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: ()
                        {
                          FirebaseFirestore.instance.collection('products').doc(products[index].idProduk).get().then((snapshot) {
                            if(snapshot.exists)
                            {
                              Product product = Product.fromDocument(snapshot);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: product)));
                            }
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: products.length,
                  ),
                ],
              );
            }
            else
            {
              return Center(
                child: Text('Belum ada produk yang dipesan.', style: TextStyle(color: Colors.grey)),
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
}