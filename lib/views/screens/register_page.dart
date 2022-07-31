import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/views/screens/penjual/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:marketky/views/screens/login_page.dart';
//import 'package:marketky/views/screens/otp_verification_page.dart';

import '../../main.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  TextEditingController
  _namaLengkap = TextEditingController(),
  _namaPengguna = TextEditingController(),
  _alamatLengkap = TextEditingController(),
  _nomorTelepon = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Daftar', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      /*
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: TextButton.styleFrom(
            primary: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sudah mempunyai akun?',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' Masuk',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      */
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Header
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              'Welcome to KTOYS  👋',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Text(
              'Sudah siap untuk mempunyai akun member? \nMohon mengisi form pendaftaran!',
              style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12, height: 150 / 100),
            ),
          ),
          // Section 2  - Form
          // Full Name
          TextField(
            controller: _namaLengkap,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Nama Lengkap',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Profile.svg', color: AppColor.primary),
              ),
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
            controller: _namaPengguna,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Nama Pengguna',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: Text('@', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColor.primary)),
              ),
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
            controller: _alamatLengkap,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Alamat Lengkap',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Location.svg', color: AppColor.primary),
              ),
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
            controller: _nomorTelepon,
            autofocus: false,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Nomor Telepon',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Call.svg', color: AppColor.primary),
              ),
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

          /*
          SizedBox(height: 16),
          // Password
          TextField(
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Lock.svg', color: AppColor.primary),
              ),
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
              //
              suffixIcon: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/Hide.svg', color: AppColor.primary),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Repeat Password
          TextField(
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Mengulang Password',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Lock.svg', color: AppColor.primary),
              ),
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
              //
              suffixIcon: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/Hide.svg', color: AppColor.primary),
              ),
            ),
          ),
          */
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async{
              SharedPreferences preferences = await SharedPreferences.getInstance();
              if(_namaLengkap.value.text.isNotEmpty && _namaPengguna.value.text.isNotEmpty && _alamatLengkap.value.text.isNotEmpty && _nomorTelepon.value.text.isNotEmpty)
              {
                FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).set(
                    {
                      'namaPengguna': _namaPengguna.value.text,
                      'namaLengkap': _namaLengkap.value.text,
                      'alamatLengkap': _alamatLengkap.value.text,
                      'nomorTelepon': _nomorTelepon.value.text,
                      'alamatEmail': auth.currentUser!.email ?? '',
                      'fotoProfil': auth.currentUser!.photoURL ?? '',
                      'tipeAkun': auth.currentUser!.uid != 'ykRHnUnEOJS554UoeyvLSeciQRt1' ? 'Pembeli' : 'Penjual'
                    }).then((_) async {

                      preferences.setString('namaPengguna', _namaPengguna.value.text);
                      preferences.setString('namaLengkap', _namaLengkap.value.text);
                      preferences.setString('alamatLengkap', _alamatLengkap.value.text);
                      preferences.setString('nomorTelepon', _nomorTelepon.value.text);
                      preferences.setString('alamatEmail', auth.currentUser!.email ?? '');
                      preferences.setString('fotoProfil', auth.currentUser!.photoURL ?? '');
                      preferences.setString('tipeAkun', auth.currentUser!.uid != 'ykRHnUnEOJS554UoeyvLSeciQRt1' ? 'Pembeli' : 'Penjual');
                      setState(() {
                        namaPengguna = _namaPengguna.value.text;
                        namaLengkap = _namaLengkap.value.text;
                        alamatLengkap = _alamatLengkap.value.text;
                        nomorTelepon = _nomorTelepon.value.text;
                        alamatEmail = auth.currentUser!.email ?? '';
                        fotoProfil = auth.currentUser!.photoURL ?? '';
                        tipeAkun = auth.currentUser!.uid != 'ykRHnUnEOJS554UoeyvLSeciQRt1' ? 'Pembeli' : 'Penjual';
                      });

                      if(auth.currentUser!.uid == 'ykRHnUnEOJS554UoeyvLSeciQRt1')
                      {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardPage()));
                      }
                      else
                      {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                      }
                    });
              }
              else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Data belum lengkap!', style: TextStyle(color: Colors.white)),
                  duration: Duration(seconds: 3),
                ));
              }
            },
            child: Text(
              'Lanjutkan',
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

          /*
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'atau lanjutkan dengan',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          // SIgn in With Google
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/Google.svg',
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Masuk dengan Google',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              primary: AppColor.primarySoft,
              elevation: 0,
              shadowColor: Colors.transparent,
              onPrimary: AppColor.primary,
            ),
          ),
          */
        ],
      ),
    );
  }
}
