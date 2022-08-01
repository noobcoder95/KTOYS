import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:marketky/constant/app_color.dart';

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  TextEditingController
  _namaPemesan = TextEditingController(),
      _totalPesanan = TextEditingController(),
      _namaProduk = TextEditingController(),
      _tanggalPemesanan = TextEditingController(),
      _tanggalPembayaran = TextEditingController(),
      _totalPembayaran = TextEditingController(),
      _resiPengiriman = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Buat Laporan', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24),
          physics: BouncingScrollPhysics(),
          children: [
            TextField(
              controller: _namaPemesan,
              autofocus: false,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Nama Pemesan',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _namaProduk,
              autofocus: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Nama Produk',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _totalPesanan,
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Total Pesanan',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _tanggalPemesanan,
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.datetime,
              onTap: (){
                showDatePicker(
                    context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101)
                ).then((pickedDate) {
                  if(pickedDate != null ){
                    _tanggalPemesanan.text = pickedDate.toString().split('.')[0];
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Tanggal Pemesanan',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _tanggalPembayaran,
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.datetime,
              onTap: (){
                showDatePicker(
                    context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101)
                ).then((pickedDate) {
                  if(pickedDate != null ){
                    _tanggalPembayaran.text = pickedDate.toString().split('.')[0];
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Tanggal Pembayaran',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _totalPembayaran,
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Total Pembayaran',
                prefixText: 'Rp. ',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _resiPengiriman,
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Resi Pengiriman',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if(
                    _namaPemesan.value.text.isNotEmpty &&
                    _totalPesanan.value.text.isNotEmpty &&
                    _namaProduk.value.text.isNotEmpty &&
                    _tanggalPemesanan.value.text.isNotEmpty &&
                    _tanggalPembayaran.value.text.isNotEmpty &&
                    _totalPembayaran.value.text.isNotEmpty &&
                    _resiPengiriman.value.text.isNotEmpty)
                  {
                    DateTime? dateOrder, datePay;
                    try
                    {
                      dateOrder = DateFormat('yyyy-MM-dd hh:mm:ss').parseLoose(_tanggalPemesanan.value.text);
                      datePay = DateFormat('yyyy-MM-dd hh:mm:ss').parseLoose(_tanggalPembayaran.value.text);
                    }
                    catch(e)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColor.primary,
                          content: Text('Tanggal pemesanan tidak valid', style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 3)));
                    }

                    try
                    {
                      datePay = DateFormat('yyyy-MM-dd hh:mm:ss').parseLoose(_tanggalPembayaran.value.text);
                    }
                    catch(e)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColor.primary,
                          content: Text('Tanggal pembayaran tidak valid', style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 3)));
                    }

                    if(dateOrder != null && datePay != null)
                    {
                      FirebaseFirestore.instance.collection('laporan').add(
                          {
                            'nama_pemesan': _namaPemesan.value.text,
                            'nama_produk': _namaProduk.value.text,
                            'total_pesanan': int.parse(_totalPesanan.value.text),
                            'tanggal_pemesanan': dateOrder.toString(),
                            'tanggal_pembayaran': datePay.toString(),
                            'resi_pengiriman': _resiPengiriman.value.text,
                            'total_pembayaran': int.parse(_totalPembayaran.value.text)
                          }).then((value) => Navigator.of(context).pop());
                    }
                  }
                else
                {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: AppColor.primary,
                      content: Text('Data Belum Lengkap', style: TextStyle(color: Colors.white)),
                      duration: Duration(seconds: 3)));
                }
              },
              child: Text(
                'Simpan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'poppins'),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                primary: AppColor.primary,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
