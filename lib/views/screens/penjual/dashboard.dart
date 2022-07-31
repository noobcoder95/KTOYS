import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/constant/factory.dart';
import 'package:marketky/core/model/Cart.dart';
import 'package:marketky/views/screens/penjual/add_product.dart';
import 'package:marketky/views/screens/penjual/detail_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/idr_currency.dart';
import '../../../core/model/Product.dart';
import '../../../main.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  int _menuIndex = 0;
  final ScrollController _listScrollController = ScrollController();
  int _limit = 20;
  int _limitIncrement = 20;

  void scrollListener()
  {
    if (_listScrollController.offset >= _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState()
  {
    super.initState();
    _listScrollController.addListener(scrollListener);
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
            title: title(),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leadingWidth: _menuIndex == 0 ? 100 : null,
            leading: _menuIndex == 0 ?
            TextButton(
                onPressed: ()=> logOut(),
                child: Text('Keluar', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600))) : null,
            actions: _menuIndex == 0 ?
            [
              TextButton(
                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct())),
                  child: Text('Tambah Produk', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)))
            ] :
            null,
          ),
          // Checkout Button
          bottomNavigationBar: Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColor.primarySoft, width: 2))),
            child: BottomNavigationBar(
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                (_menuIndex == 0)
                    ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Home-active.svg'), label: '')
                    : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Home.svg'), label: ''),
                (_menuIndex == 1)
                    ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Profile-active.svg'), label: '')
                    : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Profile.svg'), label: ''),
                (_menuIndex == 2)
                    ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Bookmark-active.svg'), label: '')
                    : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Bookmark.svg'), label: ''),
                (_menuIndex == 3)
                    ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Star-active.svg'), label: '')
                    : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Star.svg'), label: ''),
              ],
            ),
          ),
          body: body(),
        ),
        onWillPop: logOut);
  }

  Widget title()
  {
    switch(_menuIndex)
    {
      case 1:
        return Text('Data Pengguna', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600));
      case 2:
        return Text('Data Pesanan', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600));
      case 3:
        return Text('Laporan Pendapatan', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600));
      default:
        return Text('Data Produk', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600));
    }
  }

  Widget body()
  {
    switch(_menuIndex)
    {
      case 1:
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').limit(_limit).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DataPengguna> _listUser = [];
              if(snapshot.data != null)
              {
                int _length = snapshot.data!.docs.length;

                for(int i = 0; i < _length; i++)
                {
                  DataPengguna pengguna = DataPengguna.fromDocument(snapshot.data!.docs[i]);
                  if(pengguna.tipeAkun == 'Pembeli')
                  {
                    _listUser.add(pengguna);
                  }
                }
              }

              if(_listUser.length > 0)
              {
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: _listUser.length,
                    controller: _listScrollController,
                    itemBuilder: (context, index)=>
                        Container(
                          child: TextButton(
                            child: Row(
                              children: <Widget>[
                                Material(
                                  child: _listUser[index].fotoProfil.isNotEmpty
                                      ? Image.network(
                                    _listUser[index].fotoProfil,
                                    fit: BoxFit.cover,
                                    width: 50.0,
                                    height: 50.0,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xff029bd7),
                                            value: loadingProgress.expectedTotalBytes != null &&
                                                loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, object, stackTrace) {
                                      return Icon(
                                        Icons.account_circle,
                                        size: 50.0,
                                        color: Color(0xffaeaeae),
                                      );
                                    },
                                  )
                                      : Icon(
                                    Icons.account_circle,
                                    size: 50.0,
                                    color: Color(0xffaeaeae),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                              '${_listUser[index].namaLengkap}',
                                              maxLines: 1,
                                              style: TextStyle(color: Color(0xff203152), fontSize: 16, fontWeight: FontWeight.bold)
                                          ),
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                                        ),
                                        _listUser[index].alamatEmail.isNotEmpty ?
                                        Container(
                                          child: Text(
                                            _listUser[index].alamatEmail,
                                            maxLines: 1,
                                            style: TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                        ) :
                                        Container(
                                          child: Text(
                                            _listUser[index].nomorTelepon,
                                            maxLines: 1,
                                            style: TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.only(left: 20.0),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProfile(namaLengkap: _listUser[index].namaLengkap, nomorTelepon: _listUser[index].nomorTelepon, namaPengguna: _listUser[index].namaPengguna, alamatLengkap: _listUser[index].alamatLengkap, alamatEmail: _listUser[index].alamatEmail)));
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xffE8E8E8)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
                        )
                );
              }
              else
              {
                return Center(
                  child: Text('Tidak ada pesan', style: TextStyle(color: Colors.grey)),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      default:
        return StreamBuilder<QuerySnapshot>(
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
        );
    }
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

  void _onItemTapped(int index) {
    setState(() {
      _menuIndex= index;
    });
  }
}
