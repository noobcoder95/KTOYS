import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/constant/idr_currency.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/main.dart';
import 'package:marketky/views/screens/cart_page.dart';

class AddToCartModal extends StatefulWidget {
  final Product product;
  AddToCartModal({required this.product});
  @override
  _AddToCartModalState createState() => _AddToCartModalState();
}

class _AddToCartModalState extends State<AddToCartModal> {
  int jumlahBarang = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ----------
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 6,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColor.primarySoft,
            ),
          ),
          // Section 1 - increment button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 6),
                child: Text(
                  'Jumlah Produk',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF0A0E2F).withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(jumlahBarang > 0)
                      {
                        setState(() {
                          jumlahBarang = jumlahBarang - 1;
                        });
                      }
                    },
                    child: Icon(Icons.remove, size: 20, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                      primary: AppColor.border,
                      onPrimary: AppColor.primary,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      jumlahBarang.toString(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'poppins'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(jumlahBarang < widget.product.stocks)
                      {
                        setState(() {
                          jumlahBarang = jumlahBarang + 1;
                        });
                      }
                    },
                    child: Icon(Icons.add, size: 20, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                      primary: AppColor.border,
                      onPrimary: AppColor.primary,
                    ),
                  ),
                ],
              )
            ],
          ),
          // Section 2 - Total and add to cart button
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 18),
            padding: EdgeInsets.all(4),
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColor.primarySoft,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('TOTAL', style: TextStyle(fontSize: 10, fontFamily: 'poppins')),
                        Text(CurrencyFormat.convertToIdr(widget.product.price * jumlahBarang, 2), style: TextStyle(fontSize: 16, fontFamily: 'poppins', fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: () {
                      if(jumlahBarang > 0)
                      {
                        int timestamp = DateTime.now().millisecondsSinceEpoch;
                        FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Keranjang').doc(widget.product.productId).set({
                          'image': widget.product.image,
                          'name': widget.product.name,
                          'price': widget.product.price,
                          'stocks': jumlahBarang,
                          'timestamp': timestamp,
                          'productId': widget.product.productId
                        }).then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage())));
                      }
                    },
                    child: Text(
                      'Keranjang',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
