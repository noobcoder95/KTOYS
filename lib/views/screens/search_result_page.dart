import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/screens/product_detail.dart';
import '../../constant/idr_currency.dart';
import '../widgets/rating_tag.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKeyword;
  SearchResultPage({required this.searchKeyword});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController searchInputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchInputController.text = widget.searchKeyword;
    tabController = TabController(length: 4, vsync: this);
  }

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/Filter.svg',
              color: Colors.white,
            ),
          ),
        ],
        title: Container(
          height: 40,
          child: TextField(
            autofocus: false,
            controller: searchInputController,
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
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: AppColor.secondary,
            child: TabBar(
              controller: tabController,
              indicatorColor: AppColor.accent,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'poppins', fontSize: 12),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'poppins', fontSize: 12),
              tabs: [
                Tab(
                  text: 'Terkait',
                ),
                Tab(
                  text: 'Terbaru',
                ),
                Tab(
                  text: 'Populer',
                ),
                Tab(
                  text: 'Best Seller',
                ),
              ],
            ),
          ),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // 1 - Related
          ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'Hasil pencarian dari ${widget.searchKeyword}',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<Product> products = [];
                      if(snapshot.data != null)
                      {
                        int length = snapshot.data!.docs.length;

                        for(int i = 0; i < length; i++)
                        {
                          Product product = Product.fromDocument(snapshot.data!.docs[i]);
                          print(product.name);
                          print(product.storeName);
                          if(product.name.toLowerCase().contains(searchInputController.value.text.toLowerCase()) || product.storeName.toLowerCase().contains(searchInputController.value.text.toLowerCase()))
                          {
                            products.add(Product.fromDocument(snapshot.data!.docs[i]));
                          }
                        }
                      }

                      if(products.length > 0)
                      {
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(
                            products.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    FirebaseFirestore.instance.collection('populars').doc(products[index].productId).set({
                                      'name': products[index].name,
                                      'imageUrl': products[index].image[0].toString(),
                                      'productId': products[index].productId
                                    }).then((value) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: products[index])));
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2 - 16 - 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // item image
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2 - 16 - 8,
                                          height: MediaQuery.of(context).size.width / 2 - 16 - 8,
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.topLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            image: DecorationImage(image: NetworkImage(products[index].image[0].toString()), fit: BoxFit.cover),
                                          ),
                                          child: RatingTag(value: products[index].rating),
                                        ),

                                        // item details
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${products[index].name}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 2, bottom: 8),
                                                child: Text(
                                                  '${CurrencyFormat.convertToIdr(products[index].price, 2)}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Poppins',
                                                    color: AppColor.primary,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${products[index].storeName}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                        );
                      }
                      else
                      {
                        return Center(
                          child: Text('Produk yang dicari belum tersedia.', style: TextStyle(color: Colors.grey)),
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
            ],
          ),
          SizedBox(),
          SizedBox(),
          SizedBox(),
        ],
      ),
    );
  }
}
