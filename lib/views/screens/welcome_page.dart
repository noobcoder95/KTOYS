import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/views/screens/home_page.dart';
import 'package:marketky/views/screens/penjual/dashboard.dart';
import 'package:marketky/views/screens/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/factory.dart';
import '../../core/services/GoogleLogin.dart';
import '../../main.dart';
//import 'package:marketky/views/screens/login_page.dart';

class WelcomePage extends StatefulWidget
{
  @override
  _WelcomePage createState() => _WelcomePage();
}
class _WelcomePage extends State<WelcomePage>{
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section 1 - Illustration
              Container(
                margin: EdgeInsets.only(top: 32),
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset('assets/icons/shopping illustration.svg'),
              ),
              // Section 2 - KTOYS with Caption
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'KTOYS',
                      style: TextStyle(
                        color: AppColor.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ),
                ],
              ),
              // Section 3 - Get Started Button
              _isSigningIn ?
              Center(
                child: Container(
                  width: 10,
                  height: 50,
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
              ) :
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () async{
                    setState(() {
                      _isSigningIn = true;
                    });

                    SharedPreferences pref = await SharedPreferences.getInstance();
                    User? user = await GoogleLoginAuth.signInWithGoogle(context: context);

                    if(user != null)
                    {
                      FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get().then((snapshot) async {
                        if (snapshot.exists)
                        {
                          DataPengguna _data = DataPengguna.fromDocument(snapshot);
                          if(_data.tipeAkun.isNotEmpty && _data.alamatLengkap.isNotEmpty && _data.namaPengguna.isNotEmpty && _data.namaLengkap.isNotEmpty)
                          {
                            namaPengguna = _data.namaPengguna;
                            namaLengkap = _data.namaLengkap;
                            alamatLengkap = _data.alamatLengkap;
                            tipeAkun = _data.tipeAkun;
                            nomorTelepon = _data.nomorTelepon;
                            alamatEmail = auth.currentUser!.email ?? '';
                            fotoProfil = auth.currentUser!.photoURL ?? '';

                            pref.setString('namaPengguna', _data.namaPengguna);
                            pref.setString('namaLengkap', _data.namaLengkap);
                            pref.setString('alamatLengkap', _data.alamatLengkap);
                            pref.setString('tipeAkun', _data.tipeAkun);
                            pref.setString('nomorTelepon', _data.nomorTelepon);
                            pref.setString('alamatEmail', auth.currentUser!.email ?? '');
                            pref.setString('fotoProfil', auth.currentUser!.photoURL ?? '');

                            if(mounted)
                            {
                              setState(() {
                                _isSigningIn = false;
                              });
                              if(user.uid == 'Je9hfwGkGDVOMX4q6N6pwu5L4Q23')
                              {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardPage()));
                              }
                              else
                              {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                              }
                            }
                          }
                          else
                          {
                            if(mounted)
                            {
                              setState(() {
                                _isSigningIn = false;
                              });
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage()));
                            }
                          }
                        }
                        else
                        {
                          if(mounted)
                          {
                            setState(() {
                              _isSigningIn = false;
                            });
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage()));
                          }
                        }
                      });
                    }
                    else
                    {
                      setState(() {
                        _isSigningIn = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Terjadi kesalahan', style: TextStyle(color: Colors.white)),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  child: Text(
                    'Mengaitkan Gmail',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
