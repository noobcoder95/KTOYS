import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/core/model/Search.dart';
import 'package:marketky/main.dart';
import 'package:marketky/views/screens/product_detail.dart';
import 'package:marketky/views/screens/search_result_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            'assets/icons/Arrow-left.svg',
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            autofocus: false,
            onSubmitted: (string)
            {
              FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).
              collection('Pencarian').doc(string).set({'title': string}).then((value) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchResultPage(
                      searchKeyword: string,
                    ),
                  ),
                );
              });
            },
            style: TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Temukan produk...',
              prefixIcon: Container(
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset('assets/icons/Search.svg', color: Colors.white),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
          ),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search History
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Riwayat pencarian...',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Pencarian').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<SearchHistory> history = [];
                    if(snapshot.data != null)
                    {
                      int length = snapshot.data!.docs.length;

                      for(int i = 0; i < length; i++)
                      {
                        history.add(SearchHistory.fromJson(snapshot.data!.docs[i]));
                      }
                    }

                    if(history.length > 0)
                    {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SearchResultPage(
                                    searchKeyword: history[index].title,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColor.primarySoft,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text('${history[index].title}'),
                            ),
                          );
                        },
                      );
                    }
                    else
                    {
                      return Center(
                        child: Text('Belum ada riwayat pencarian.', style: TextStyle(color: Colors.grey)),
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Pencarian').get().then((docs) {
                      for(DocumentSnapshot doc in docs.docs)
                      {
                        doc.reference.delete();
                      }
                    });
                  },
                  child: Text(
                    'Hapus riwayat pencarian',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primarySoft,
                    onPrimary: AppColor.primary.withOpacity(0.3),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - Popular Search
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Pencarian populer',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('populars').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<PopularSearch> history = [];
                    if(snapshot.data != null)
                    {
                      int length = snapshot.data!.docs.length;

                      for(int i = 0; i < length; i++)
                      {
                        history.add(PopularSearch.fromJson(snapshot.data!.docs[i]));
                      }
                    }

                    if(history.length > 0)
                    {
                      return Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(history.length, (index) {
                          return GestureDetector(
                            onTap: (){
                              FirebaseFirestore.instance.collection('products').doc(history[index].productId).get().then((snapshot) {
                                if(snapshot.exists)
                                {
                                  Product item = Product.fromDocument(snapshot);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: item)));
                                }
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    margin: EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: AppColor.primarySoft,
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage('${history[index].imageUrl}'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${history[index].name}'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }
                    else
                    {
                      return Center(
                        child: Text('Produk populer belum tersedia.', style: TextStyle(color: Colors.grey)),
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
            ],
          )
        ],
      ),
    );
  }
}
