import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Cart.dart';
import 'package:marketky/views/screens/penjual/add_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/idr_currency.dart';
import '../../../core/model/Product.dart';
import '../../../main.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 5,
            title: Text('Dashboard', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          // Checkout Button
          bottomNavigationBar:  SizedBox(
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColor.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: Text(
                'Tambahkan Produk',
                style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<Cart> products = [];
                if(snapshot.data != null)
                {
                  int length = snapshot.data!.docs.length;

                  for(int i = 0; i < length; i++)
                  {
                    Product product = Product.fromJson(snapshot.data!.docs[i]);
                    if(product.storeId == auth.currentUser!.uid)
                    {
                      products.add(Cart.fromJson(snapshot.data!.docs[i]));
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
                                    image: DecorationImage(image: NetworkImage(products[index].image[0]), fit: BoxFit.cover),
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
                                        '${products[index].name}',
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
                                                '${CurrencyFormat.convertToIdr(products[index].price, 2)}',
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
                                                      if(products[index].stocks > 0)
                                                      {
                                                        FirebaseFirestore.instance.collection('products').doc(products[index].id).update({'stocks': products[index].stocks - 1}).then((value) => null);
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
                                                        '${products[index].stocks}',
                                                        style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      FirebaseFirestore.instance.collection('products').doc(products[index].id).update({'stocks': products[index].stocks + 1}).then((value) => null);
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
                        itemCount: products.length,
                      ),
                    ],
                  );
                }
                else
                {
                  return Center(
                    child: Text('Belum ada produk.', style: TextStyle(color: Colors.grey)),
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
        ),
        onWillPop: logOut);
  }
  Future<bool> logOut() async
  {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(
                left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: AppColor.primary,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Logout akun?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Color(0xff203152),
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Batal',
                      style: TextStyle(color: Color(0xff203152),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  SharedPreferences.getInstance().then((value) {
                    value.clear().then((value) {
                      GoogleSignIn().disconnect().then((value) {
                        FirebaseAuth.instance.signOut().then((value) {
                          GoogleSignIn().signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false));
                        });
                      });
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xff203152),
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Ya',
                      style: TextStyle(color: Color(0xff203152),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        }).then((value) => Future.value(value));
  }
}
