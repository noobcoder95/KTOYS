import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/screens/product_detail.dart';
import '../../constant/app_color.dart';
import '../../constant/idr_currency.dart';
import '../../main.dart';

class FavoritePage extends StatefulWidget
{
  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Favorite', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Favorite').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            if(snapshot.data != null)
            {
              int length = snapshot.data!.docs.length;

              for(int i = 0; i < length; i++)
              {
                products.add(Product.fromDocument(snapshot.data!.docs[i]));
              }
            }

            if(products.length > 0)
            {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
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
                          height: 85,
                          padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColor.border, width: 1),
                          ),
                          child: Row(
                            children: [
                              // Image
                              GestureDetector(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: AppColor.border,
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(image: NetworkImage(products[index].image[0]), fit: BoxFit.cover),
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: products[index])));
                                },
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
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: AppColor.primarySoft,
                                            ),
                                            child: GestureDetector(
                                              child: Text('Hapus'),
                                              onTap: ()
                                              {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        AlertDialog(
                                                          title: Text('Hapus Favorite'),
                                                          content: Text('Lanjutkan untuk menghapus produk dari daftar favorite.'),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child: Text('Batal'),
                                                              style: ElevatedButton.styleFrom(
                                                                primary: AppColor.primary,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: Text('Lanjutkan'),
                                                              style: ElevatedButton.styleFrom(
                                                                primary: AppColor.primary,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                              ),
                                                              onPressed: () {
                                                                FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Favorite').doc(products[index].productId).delete().then((value) => null).then((value) => Navigator.of(context).pop());
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                );
                                              },
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
                ),
              );
            }
            else
            {
              return Center(
                child: Text('Belum ada produk tersimpan.', style: TextStyle(color: Colors.grey)),
              );
            }
          }
          else
          {
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