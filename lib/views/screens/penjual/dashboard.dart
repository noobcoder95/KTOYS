import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/constant/factory.dart';
import 'package:marketky/core/model/Cart.dart';
import 'package:marketky/views/screens/penjual/add_product.dart';
import 'package:marketky/views/screens/penjual/detail_user.dart';
import 'package:marketky/views/screens/penjual/sales_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/idr_currency.dart';
import '../../../core/model/Product.dart';
import '../../../main.dart';
import '../product_detail.dart';

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
            leadingWidth: 100,
            leading: TextButton(
                onPressed: ()=> logOut(),
                child: Text('Keluar', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600))),
            actions: actionButton(),
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
        return Text('Laporan\nPendapatan', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600));
      default:
        return Text('Data Produk', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600));
    }
  }

  Widget body()
  {
    switch(_menuIndex)
    {
      case 1:
        return Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
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
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 250,
                        child: ListView.builder(
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
                                                Container(
                                                  child: Text(
                                                    _listUser[index].namaPengguna,
                                                    maxLines: 1,
                                                    style: TextStyle(color: Color(0xff203152)),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                                ),
                                                Container(
                                                  child: Text(
                                                    _listUser[index].alamatEmail,
                                                    maxLines: 1,
                                                    style: TextStyle(color: Color(0xff203152)),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                                ),
                                                Container(
                                                  child: Text(
                                                    _listUser[index].nomorTelepon,
                                                    maxLines: 1,
                                                    style: TextStyle(color: Color(0xff203152)),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                                ),
                                                Container(
                                                  child: Text(
                                                    _listUser[index].alamatLengkap,
                                                    maxLines: 1,
                                                    style: TextStyle(color: Color(0xff203152)),
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
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: Text('Cetak Laporan'),
                                      content: Text('Cetak Laporan Pengguna?'),
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
                                          child: Text('Cetak'),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          onPressed: () async
                                          {
                                            final pdf = pw.Document();

                                            List<pw.TableRow> dataLaporan = [];
                                            dataLaporan.add(
                                                pw.TableRow(
                                                    children: [
                                                      pw.Text('Nama Lengkap', textAlign: pw.TextAlign.center),
                                                      pw.Text('Nama Pengguna', textAlign: pw.TextAlign.center),
                                                      pw.Text('Email', textAlign: pw.TextAlign.center),
                                                      pw.Text('Alamat', textAlign: pw.TextAlign.center),
                                                      pw.Text('Nomor Telepon', textAlign: pw.TextAlign.center),
                                                    ]
                                                )
                                            );

                                            for(int i = 0; i < _listUser.length; i++)
                                            {
                                              dataLaporan.add(
                                                  pw.TableRow(
                                                      children: [
                                                        pw.Text(_listUser[i].namaLengkap, textAlign: pw.TextAlign.center),
                                                        pw.Text(_listUser[i].namaPengguna, textAlign: pw.TextAlign.center),
                                                        pw.Text(_listUser[i].alamatEmail, textAlign: pw.TextAlign.center),
                                                        pw.Text(_listUser[i].alamatLengkap, textAlign: pw.TextAlign.center),
                                                        pw.Text(_listUser[i].nomorTelepon, textAlign: pw.TextAlign.center),
                                                      ]
                                                  )
                                              );
                                            }

                                            pdf.addPage(
                                              pw.Page(
                                                  pageFormat: PdfPageFormat.a4,
                                                  build: (pw.Context context) => pw.Container(
                                                    height: double.infinity,
                                                    color: PdfColors.white,
                                                    child: pw.Column(
                                                        children: [
                                                          pw.Container(
                                                            padding: pw.EdgeInsets.only(bottom: 10),
                                                            alignment: pw.Alignment.center,
                                                            decoration: pw.BoxDecoration(
                                                              border: pw.Border(
                                                                bottom: pw.BorderSide(width: 4, color: PdfColors.black),
                                                              ),
                                                            ),
                                                            child: pw.Column(
                                                              mainAxisAlignment: pw.MainAxisAlignment.start,
                                                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                                                              children: [
                                                                pw.Text('Toko Mainan KTOYS', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                                pw.Text('Jl. Bakti Jaya Raya No. 1, Harapan Jaya, Kec. Bekasi Utara, Kota Bekasi, Jawa Barat, 17124', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 16)),
                                                                pw.Text('Telp. 089652861099', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(),  fontSize: 16)),
                                                              ],
                                                            ),
                                                          ),
                                                          pw.Container(
                                                            padding: pw.EdgeInsets.symmetric(vertical: 10),
                                                            child: pw.Text('Laporan Pengguna', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                          ),
                                                          pw.Container(
                                                            margin: pw.EdgeInsets.all(10),
                                                            child: pw.Table(
                                                                border: pw.TableBorder.all(),
                                                                children: dataLaporan
                                                            ),
                                                          ),
                                                          pw.Expanded(
                                                              child: pw.Align(
                                                                  alignment: pw.Alignment.bottomRight,
                                                                  child: pw.Column(
                                                                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                                      mainAxisAlignment: pw.MainAxisAlignment.end,
                                                                      children: [
                                                                        pw.Text('Bekasi, ${DateTime.now().toString().split(' ')[0]}'),
                                                                        pw.SizedBox(height: 50),
                                                                        pw.Text('Riyo Nugroho'),
                                                                      ]
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    ),
                                                  )
                                              ),
                                            );

                                            Directory? extDir = await getExternalStorageDirectory();

                                            if(extDir != null)
                                            {
                                              final String dirPath = "${extDir.path}/laporan";
                                              await Directory(dirPath).create(recursive: true);
                                              final file = File('$dirPath/pengguna-${DateTime.now().toString().split(' ')[0]}.pdf');
                                              await file.writeAsBytes(await pdf.save());
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 6,
                                child: Text(
                                  'Jumlah Pengguna', textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'poppins'),
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
                                  '${_listUser.length.toString()} Pengguna',
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
                    ],
                  );
                }
                else
                {
                  return Center(
                    child: Text('Tidak ada pengguna', style: TextStyle(color: Colors.grey)),
                  );
                }
              }
              else
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      case 2:
        return Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('pesanan').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<DataPesanan> products = [];
                if(snapshot.data != null)
                {
                  int length = snapshot.data!.docs.length;

                  for(int i = 0; i < length; i++)
                  {
                    products.add(DataPesanan.fromDocument(snapshot.data!.docs[i]));
                  }
                }

                if(products.length > 0)
                {
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 250,
                        child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text('Hapus Produk'),
                                              content: Text('Lanjutkan untuk menghapus laporan.'),
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
                                                    FirebaseFirestore.instance.collection('pesanan').doc(products[index].idPesanan).delete().then((value) => null).then((value) => Navigator.of(context).pop());
                                                  },
                                                ),
                                              ],
                                            )
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: products[index].tanggalPengiriman != null && products[index].resiPengiriman != null && products[index].resiPengiriman!.isNotEmpty ?
                                    300 : 240,
                                    padding: EdgeInsets.only(top: 5, left: 5, right: 12),
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
                                              image: DecorationImage(image: NetworkImage(products[index].imageUrl), fit: BoxFit.cover),
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
                                                  'Nama Pemesan:\n${products[index].namaPemesan}',
                                                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
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
                                              Container(
                                                margin: EdgeInsets.only(top: 4, bottom: 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // Product Price
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 26,
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: AppColor.primarySoft,
                                                        ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            'Batalkan',
                                                            style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        if(products[index].statusPesanan == 'cancel')
                                                        {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              backgroundColor: AppColor.primary,
                                                              content: Text('Pesanan telah dibatalkan', style: TextStyle(color: Colors.white)),
                                                              duration: Duration(seconds: 3)));
                                                        }
                                                        else
                                                        {
                                                          FirebaseFirestore.instance.collection('pesanan').doc(products[index].idPesanan).update(
                                                              {
                                                                'resi_pengiriman': null,
                                                                'tanggal_pengiriman': null,
                                                                'status_pesanan': 'cancel'
                                                              }
                                                          ).then((value) => null);
                                                        }
                                                      },
                                                    ),
                                                    // Increment Decrement Button
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 26,
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: AppColor.primarySoft,
                                                        ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            'Konfirmasi',
                                                            style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        if(products[index].statusPesanan == 'cancel')
                                                        {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              backgroundColor: AppColor.primary,
                                                              content: Text('Pesanan telah dibatalkan', style: TextStyle(color: Colors.white)),
                                                              duration: Duration(seconds: 3)));
                                                        }
                                                        else if(products[index].statusPesanan == 'confirmed' && products[index].tanggalPengiriman != null && products[index].resiPengiriman != null && products[index].resiPengiriman!.isNotEmpty)
                                                        {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              backgroundColor: AppColor.primary,
                                                              content: Text('Pesanan telah dikonfirmasi', style: TextStyle(color: Colors.white)),
                                                              duration: Duration(seconds: 3)));
                                                        }
                                                        else
                                                        {
                                                          TextEditingController resiPengiriman = TextEditingController(), tanggalPengiriman = TextEditingController();

                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  AlertDialog(
                                                                    title: Text('Konfirmasi Pesanan', textAlign: TextAlign.center),
                                                                    content: Container(
                                                                      height: 120,
                                                                      child: Column(
                                                                        children: [
                                                                          TextField(
                                                                            controller: resiPengiriman,
                                                                            maxLines: 1,
                                                                            decoration: InputDecoration(hintText: "Resi Pengiriman"),
                                                                            keyboardType: TextInputType.text,
                                                                          ),
                                                                          SizedBox(height: 10),
                                                                          TextField(
                                                                            controller: tanggalPengiriman,
                                                                            onTap: (){
                                                                              showDatePicker(
                                                                                  context: context, initialDate: DateTime.now(),
                                                                                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                                                                  lastDate: DateTime(2101)
                                                                              ).then((pickedDate) {
                                                                                if(pickedDate != null ){
                                                                                  tanggalPengiriman.text = pickedDate.toString().split('.')[0];
                                                                                }
                                                                              });
                                                                            },
                                                                            decoration: InputDecoration(hintText: "Tanggal Pengiriman"),
                                                                            keyboardType: TextInputType.datetime,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <Widget>[
                                                                      ElevatedButton(
                                                                        child: Text('Konfirmasi'),
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: AppColor.primary,
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                        ),
                                                                        onPressed: () {
                                                                          DateTime? date;
                                                                          try
                                                                          {
                                                                            date = DateFormat('yyyy-MM-dd hh:mm:ss').parseLoose(tanggalPengiriman.value.text);
                                                                          }
                                                                          catch(e)
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                backgroundColor: AppColor.primary,
                                                                                content: Text('Tanggal pengiriman tidak valid', style: TextStyle(color: Colors.white)),
                                                                                duration: Duration(seconds: 3)));
                                                                          }

                                                                          if(resiPengiriman.value.text.isNotEmpty && date != null)
                                                                          {
                                                                            FirebaseFirestore.instance.collection('pesanan').doc(products[index].idPesanan).update(
                                                                                {
                                                                                  'resi_pengiriman': resiPengiriman.value.text,
                                                                                  'tanggal_pengiriman': date.toString(),
                                                                                  'status_pesanan': 'confirmed'
                                                                                }
                                                                            ).then((value) => Navigator.of(context).pop());
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ));
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: 16),
                              itemCount: products.length,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: Text('Cetak Laporan'),
                                      content: Text('Cetak Laporan Pesanan?'),
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
                                          child: Text('Cetak'),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          onPressed: () async
                                          {
                                            final pdf = pw.Document();

                                            List<pw.TableRow> dataLaporan = [];
                                            dataLaporan.add(
                                                pw.TableRow(
                                                    children: [
                                                      pw.Text('Nama Pemesan', textAlign: pw.TextAlign.center),
                                                      pw.Text('Nama Produk', textAlign: pw.TextAlign.center),
                                                      pw.Text('Total Pesanan', textAlign: pw.TextAlign.center),
                                                      pw.Text('Tanggal Pemesanan', textAlign: pw.TextAlign.center),
                                                      pw.Text('Total Pembayaran', textAlign: pw.TextAlign.center),
                                                      pw.Text('Resi Pengiriman', textAlign: pw.TextAlign.center)
                                                    ]
                                                )
                                            );

                                            for(int i = 0; i < products.length; i++)
                                            {
                                              dataLaporan.add(
                                                  pw.TableRow(
                                                      children: [
                                                        pw.Text(products[i].namaPemesan, textAlign: pw.TextAlign.center),
                                                        pw.Text(products[i].namaProduk, textAlign: pw.TextAlign.center),
                                                        pw.Text(products[i].jumlahItem.toString(), textAlign: pw.TextAlign.center),
                                                        pw.Text(products[i].tanggalPemesanan.toString().split(' ')[0], textAlign: pw.TextAlign.center),
                                                        pw.Text(products[i].totalHarga.toString().split(' ')[0], textAlign: pw.TextAlign.center),
                                                        pw.Text(products[i].resiPengiriman ?? 'Status Pesanan: ${products[i].statusPesanan.toUpperCase()}', textAlign: pw.TextAlign.center),
                                                      ]
                                                  )
                                              );
                                            }

                                            pdf.addPage(
                                              pw.Page(
                                                  pageFormat: PdfPageFormat.a4,
                                                  build: (pw.Context context) => pw.Container(
                                                    height: double.infinity,
                                                    color: PdfColors.white,
                                                    child: pw.Column(
                                                        children: [
                                                          pw.Container(
                                                            padding: pw.EdgeInsets.only(bottom: 10),
                                                            alignment: pw.Alignment.center,
                                                            decoration: pw.BoxDecoration(
                                                              border: pw.Border(
                                                                bottom: pw.BorderSide(width: 4, color: PdfColors.black),
                                                              ),
                                                            ),
                                                            child: pw.Column(
                                                              mainAxisAlignment: pw.MainAxisAlignment.start,
                                                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                                                              children: [
                                                                pw.Text('Toko Mainan KTOYS', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                                pw.Text('Jl. Bakti Jaya Raya No. 1, Harapan Jaya, Kec. Bekasi Utara, Kota Bekasi, Jawa Barat, 17124', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 16)),
                                                                pw.Text('Telp. 089652861099', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(),  fontSize: 16)),
                                                              ],
                                                            ),
                                                          ),
                                                          pw.Container(
                                                            padding: pw.EdgeInsets.symmetric(vertical: 10),
                                                            child: pw.Text('Laporan Pesanan', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                          ),
                                                          pw.Container(
                                                            margin: pw.EdgeInsets.all(10),
                                                            child: pw.Table(
                                                                border: pw.TableBorder.all(),
                                                                children: dataLaporan
                                                            ),
                                                          ),
                                                          pw.Expanded(
                                                              child: pw.Align(
                                                                  alignment: pw.Alignment.bottomRight,
                                                                  child: pw.Column(
                                                                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                                      mainAxisAlignment: pw.MainAxisAlignment.end,
                                                                      children: [
                                                                        pw.Text('Bekasi, ${DateTime.now().toString().split(' ')[0]}'),
                                                                        pw.SizedBox(height: 50),
                                                                        pw.Text('Riyo Nugroho'),
                                                                      ]
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    ),
                                                  )
                                              ),
                                            );

                                            Directory? extDir = await getExternalStorageDirectory();

                                            if(extDir != null)
                                            {
                                              final String dirPath = "${extDir.path}/laporan";
                                              await Directory(dirPath).create(recursive: true);
                                              final file = File('$dirPath/pesanan-${DateTime.now().toString().split(' ')[0]}.pdf');
                                              await file.writeAsBytes(await pdf.save());
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 6,
                                child: Text(
                                  'Jumlah Pesanan', textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'poppins'),
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
                                  '${products.length.toString()} Pesanan',
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
                    ],
                  );
                }
                else
                {
                  return Center(
                    child: Text('Belum ada pesanan.', style: TextStyle(color: Colors.grey)),
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
      case 3:
        return Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('laporan').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<DataLaporan> laporan = [];
                int totalPenghasilan = 0;
                if(snapshot.data != null)
                {
                  int length = snapshot.data!.docs.length;

                  for(int i = 0; i < length; i++)
                  {
                    laporan.add(DataLaporan.fromDocument(snapshot.data!.docs[i]));
                  }

                  if(laporan.length > 0)
                  {
                    int lengthLaporan = laporan.length, harga = 0;
                    for(int i = 0; i < lengthLaporan; i++)
                    {
                      harga = harga + laporan[i].totalPembayaran;
                    }
                    totalPenghasilan = harga;
                  }
                }

                if(laporan.length > 0)
                {
                  return Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height - 250,
                          child: ListView(
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
                                      height: 175,
                                      padding: EdgeInsets.only(top: 5, left: 12, right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: AppColor.border, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                laporan[index].namaProduk,
                                                style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'poppins', color: AppColor.secondary),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  '${CurrencyFormat.convertToIdr(laporan[index].totalPembayaran, 2)}',
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.primary),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'Total Pesanan:',
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.primary),
                                                ),
                                              ),
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
                                                    '${laporan[index].totalPesanan} Item',
                                                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 2, bottom: 8),
                                                child: Text(
                                                  'Nama Pemesan:\n${laporan[index].namaPemesan}',
                                                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 2, bottom: 8),
                                                child: Text(
                                                  'Tanggal Pemesanan:\n${laporan[index].tanggalPemesanan.toString().split('.')[0]}',
                                                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 2, bottom: 8),
                                                child: Text(
                                                  'Tanggal Pembayaran:\n${laporan[index].tanggalPembayaran.toString().split('.')[0]}',
                                                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 2, bottom: 8),
                                                child: Text(
                                                  'Resi Pengiriman:\n${laporan[index].resiPengiriman}',
                                                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    onLongPress: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text('Hapus Produk'),
                                                content: Text('Lanjutkan untuk menghapus laporan.'),
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
                                                      FirebaseFirestore.instance.collection('laporan').doc(laporan[index].id).delete().then((value) => null).then((value) => Navigator.of(context).pop());
                                                    },
                                                  ),
                                                ],
                                              )
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(height: 16),
                                itemCount: laporan.length,
                              ),
                            ],
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: Text('Cetak Laporan'),
                                      content: Text('Cetak Laporan Pendapatan?'),
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
                                          child: Text('Cetak'),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          onPressed: () async
                                          {
                                            final pdf = pw.Document();

                                            List<pw.TableRow> dataLaporan = [];
                                            dataLaporan.add(
                                              pw.TableRow(
                                                  children: [
                                                    pw.Text('Nama Pemesan', textAlign: pw.TextAlign.center),
                                                    pw.Text('Nama Produk', textAlign: pw.TextAlign.center),
                                                    pw.Text('Total Pesanan', textAlign: pw.TextAlign.center),
                                                    pw.Text('Tanggal Pemesanan', textAlign: pw.TextAlign.center),
                                                    pw.Text('Tanggal Pembayaran', textAlign: pw.TextAlign.center),
                                                    pw.Text('Total Pembayaran', textAlign: pw.TextAlign.center),
                                                    pw.Text('Resi Pengiriman', textAlign: pw.TextAlign.center)
                                                  ]
                                              )
                                            );

                                            for(int i = 0; i < laporan.length; i++)
                                            {
                                              dataLaporan.add(
                                                pw.TableRow(
                                                    children: [
                                                      pw.Text(laporan[i].namaPemesan, textAlign: pw.TextAlign.center),
                                                      pw.Text(laporan[i].namaProduk, textAlign: pw.TextAlign.center),
                                                      pw.Text(laporan[i].totalPesanan.toString(), textAlign: pw.TextAlign.center),
                                                      pw.Text(laporan[i].tanggalPemesanan.toString().split(' ')[0], textAlign: pw.TextAlign.center),
                                                      pw.Text(laporan[i].tanggalPembayaran.toString().split(' ')[0], textAlign: pw.TextAlign.center),
                                                      pw.Text(laporan[i].totalPembayaran.toString(), textAlign: pw.TextAlign.center),
                                                      pw.Text(laporan[i].resiPengiriman, textAlign: pw.TextAlign.center)
                                                    ]
                                                )
                                              );
                                            }

                                            pdf.addPage(
                                              pw.Page(
                                                pageFormat: PdfPageFormat.a4,
                                                build: (pw.Context context) => pw.Container(
                                                  height: double.infinity,
                                                  color: PdfColors.white,
                                                  child: pw.Column(
                                                      children: [
                                                        pw.Container(
                                                          padding: pw.EdgeInsets.only(bottom: 10),
                                                          alignment: pw.Alignment.center,
                                                          decoration: pw.BoxDecoration(
                                                            border: pw.Border(
                                                              bottom: pw.BorderSide(width: 4, color: PdfColors.black),
                                                            ),
                                                          ),
                                                          child: pw.Column(
                                                            mainAxisAlignment: pw.MainAxisAlignment.start,
                                                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                                                            children: [
                                                              pw.Text('Toko Mainan KTOYS', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                              pw.Text('Jl. Bakti Jaya Raya No. 1, Harapan Jaya, Kec. Bekasi Utara, Kota Bekasi, Jawa Barat, 17124', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 16)),
                                                              pw.Text('Telp. 089652861099', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(),  fontSize: 16)),
                                                            ],
                                                          ),
                                                        ),
                                                        pw.Container(
                                                          padding: pw.EdgeInsets.symmetric(vertical: 10),
                                                          child: pw.Text('Laporan Pendapatan', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                        ),
                                                        pw.Container(
                                                          margin: pw.EdgeInsets.all(10),
                                                          child: pw.Table(
                                                            border: pw.TableBorder.all(),
                                                            children: dataLaporan
                                                          ),
                                                        ),
                                                        pw.Expanded(
                                                          child: pw.Align(
                                                              alignment: pw.Alignment.bottomRight,
                                                              child: pw.Column(
                                                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                                                  children: [
                                                                    pw.Text('Bekasi, ${DateTime.now().toString().split(' ')[0]}'),
                                                                    pw.SizedBox(height: 50),
                                                                    pw.Text('Riyo Nugroho'),
                                                                  ]
                                                              )
                                                          )
                                                        )
                                                      ]
                                                  ),
                                                )
                                              ),
                                            );

                                            Directory? extDir = await getExternalStorageDirectory();

                                            if(extDir != null)
                                            {
                                              final String dirPath = "${extDir.path}/laporan";
                                              await Directory(dirPath).create(recursive: true);
                                              final file = File('$dirPath/pendapatan-${DateTime.now().toString().split(' ')[0]}.pdf');
                                              await file.writeAsBytes(await pdf.save());
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 6,
                                child: Text(
                                  'Total Pendapatan', textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'poppins'),
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
                                  CurrencyFormat.convertToIdr(totalPenghasilan, 2),
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
                    ],
                  );
                }
                else
                {
                  return Center(
                    child: Text('Belum ada laporan.', style: TextStyle(color: Colors.grey)),
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
      default:
        return Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<Cart> products = [];
                  if(snapshot.data != null)
                  {
                    int length = snapshot.data!.docs.length;

                    for(int i = 0; i < length; i++)
                    {
                      products.add(Cart.fromJson(snapshot.data!.docs[i]));
                    }
                  }

                  if(products.length > 0)
                  {
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height - 240,
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
                                            FirebaseFirestore.instance.collection('products').doc(products[index].id).get().then((snapshot) {
                                              if(snapshot.exists)
                                              {
                                                Product product = Product.fromDocument(snapshot);
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: product)));
                                              }
                                            });
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
                                                              else
                                                              {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) =>
                                                                        AlertDialog(
                                                                          title: Text('Hapus Produk'),
                                                                          content: Text('Lanjutkan untuk menghapus produk.'),
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
                                                                                FirebaseFirestore.instance.collection('products').doc(products[index].id).delete().then((value) => null).then((value) => Navigator.of(context).pop());
                                                                              },
                                                                            ),
                                                                          ],
                                                                        )
                                                                );
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
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: ()
                            {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Cetak Laporan'),
                                        content: Text('Cetak Laporan Produk?'),
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
                                            child: Text('Cetak'),
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColor.primary,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            ),
                                            onPressed: () async
                                            {
                                              final pdf = pw.Document();

                                              List<pw.TableRow> dataLaporan = [];
                                              dataLaporan.add(
                                                  pw.TableRow(
                                                      children: [
                                                        pw.Text('Nama Produk', textAlign: pw.TextAlign.center),
                                                        pw.Text('Jumlah Produk', textAlign: pw.TextAlign.center),
                                                        pw.Text('Harga/Item', textAlign: pw.TextAlign.center),
                                                      ]
                                                  )
                                              );

                                              for(int i = 0; i < products.length; i++)
                                              {
                                                dataLaporan.add(
                                                    pw.TableRow(
                                                        children: [
                                                          pw.Text(products[i].name, textAlign: pw.TextAlign.center),
                                                          pw.Text(products[i].stocks.toString(), textAlign: pw.TextAlign.center),
                                                          pw.Text(products[i].price.toString(), textAlign: pw.TextAlign.center),
                                                        ]
                                                    )
                                                );
                                              }

                                              pdf.addPage(
                                                pw.Page(
                                                    pageFormat: PdfPageFormat.a4,
                                                    build: (pw.Context context) => pw.Container(
                                                      height: double.infinity,
                                                      color: PdfColors.white,
                                                      child: pw.Column(
                                                          children: [
                                                            pw.Container(
                                                              padding: pw.EdgeInsets.only(bottom: 10),
                                                              alignment: pw.Alignment.center,
                                                              decoration: pw.BoxDecoration(
                                                                border: pw.Border(
                                                                  bottom: pw.BorderSide(width: 4, color: PdfColors.black),
                                                                ),
                                                              ),
                                                              child: pw.Column(
                                                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                                                children: [
                                                                  pw.Text('Toko Mainan KTOYS', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                                  pw.Text('Jl. Bakti Jaya Raya No. 1, Harapan Jaya, Kec. Bekasi Utara, Kota Bekasi, Jawa Barat, 17124', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 16)),
                                                                  pw.Text('Telp. 089652861099', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helvetica(),  fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                            pw.Container(
                                                              padding: pw.EdgeInsets.symmetric(vertical: 10),
                                                              child: pw.Text('Laporan Produk', textAlign: pw.TextAlign.center, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18)),
                                                            ),
                                                            pw.Container(
                                                              margin: pw.EdgeInsets.all(10),
                                                              child: pw.Table(
                                                                  border: pw.TableBorder.all(),
                                                                  children: dataLaporan
                                                              ),
                                                            ),
                                                            pw.Expanded(
                                                                child: pw.Align(
                                                                    alignment: pw.Alignment.bottomRight,
                                                                    child: pw.Column(
                                                                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                                        mainAxisAlignment: pw.MainAxisAlignment.end,
                                                                        children: [
                                                                          pw.Text('Bekasi, ${DateTime.now().toString().split(' ')[0]}'),
                                                                          pw.SizedBox(height: 50),
                                                                          pw.Text('Riyo Nugroho'),
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                          ]
                                                      ),
                                                    )
                                                ),
                                              );

                                              Directory? extDir = await getExternalStorageDirectory();

                                              if(extDir != null)
                                              {
                                                final String dirPath = "${extDir.path}/laporan";
                                                await Directory(dirPath).create(recursive: true);
                                                final file = File('$dirPath/produk-${DateTime.now().toString().split(' ')[0]}.pdf');
                                                await file.writeAsBytes(await pdf.save());
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      )
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: Text(
                                    'Total Produk', textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'poppins'),
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
                                    '${products.length} Jenis',
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
            )
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

  List<Widget>? actionButton(){
    switch(_menuIndex)
    {
      case 1:
        return null;
      case 2:
        return null;
      case 3:
        return [
          TextButton(
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReport())),
              child: Text('Buat Laporan', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)))
        ];
      default:
        return [
          TextButton(
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct())),
              child: Text('Tambah Produk', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)))
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _menuIndex= index;
    });
  }
}
