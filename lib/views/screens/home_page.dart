import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Category.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/core/services/CategoryService.dart';
import 'package:marketky/views/screens/profile_page.dart';
import 'package:marketky/views/screens/search_page.dart';
import 'package:marketky/views/widgets/item_card.dart';
import 'cart_page.dart';
import 'feeds_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categoryData = CategoryService.categoryData;
  int _selectedIndex = 0;
  int bagCounter = 0, chatCounter = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        homePage(),
        FeedsPage(),
        NotificationPage(),
        ProfilePage(),
      ][_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColor.primarySoft, width: 2))),
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            (_selectedIndex == 0)
                ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Home-active.svg'), label: '')
                : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Home.svg'), label: ''),
            (_selectedIndex == 1)
                ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Category-active.svg'), label: '')
                : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Category.svg'), label: ''),
            (_selectedIndex == 2)
                ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Notification-active.svg'), label: '')
                : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Notification.svg'), label: ''),
            (_selectedIndex == 3)
                ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Profile-active.svg'), label: '')
                : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Profile.svg'), label: ''),
          ],
        ),
      ),
    );
  }

  Widget homePage()
  {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: [
        // Section 1
        Container(
          height: 190,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 26),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mencari mainan \nfavorit anakmu.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/icons/Bag.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                    (bagCounter != 0)
                                        ? Container(
                                      width: 16,
                                      height: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: AppColor.accent,
                                      ),
                                      child: Text(
                                        '$bagCounter',
                                        style: TextStyle(color: AppColor.secondary, fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ),
                            /*
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagePage()));
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/icons/Chat.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                    (chatCounter != 0)
                                        ? Container(
                                      width: 16,
                                      height: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: AppColor.accent,
                                      ),
                                      child: Text(
                                        '$chatCounter',
                                        style: TextStyle(color: AppColor.secondary, fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ),
                            */
                          ],
                        ),
                      ],
                    ),
                  )
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  margin: EdgeInsets.only(top: 24),
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: SvgPicture.asset(
                          'assets/icons/Search.svg',
                          color: Colors.black,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Text(
                        'Temukan Produk...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Section 2 - category
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColor.secondary,
          padding: EdgeInsets.only(top: 12, bottom: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kategori',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // Category list
              Container(
                margin: EdgeInsets.only(top: 12),
                height: 96,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categoryData.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 16);
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){},
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                          color: (categoryData[index].featured == true) ? Colors.white.withOpacity(0.10) : Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 6),
                              child: SvgPicture.asset(
                                '${categoryData[index].iconUrl}',
                                color: Colors.white,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${categoryData[index].name}',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Section 3 - banner
        /*
           Container(
             height: 106,
             padding: EdgeInsets.symmetric(vertical: 16),
             child: ListView.separated(
               padding: EdgeInsets.symmetric(horizontal: 16),
               scrollDirection: Axis.horizontal,
               itemCount: 3,
               separatorBuilder: (context, index) {
                 return SizedBox(width: 16);
               },
               itemBuilder: (context, index) {
                 return Container(
                   width: 230,
                   height: 106,
                   decoration: BoxDecoration(color: AppColor.primarySoft, borderRadius: BorderRadius.circular(15)),
                 );
               },
             ),
           ),
          */

        // Section 4 - product list
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16),
          child: Text(
            'Rekomendasi Mainan',
            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(products.length, (index) => ItemCard(product: products[index])),
                  ),
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
        )
      ],
    );
  }
}
