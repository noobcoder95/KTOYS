import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/main.dart';
import 'package:marketky/views/widgets/main_app_bar_widget.dart';
import 'package:marketky/views/widgets/menu_tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        cartValue: 0,
        chatValue: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Profile Picture
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(auth.currentUser!.photoURL ?? 'assets/images/avatar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Fullname
                Container(
                  margin: EdgeInsets.only(bottom: 4, top: 14),
                  child: Text(
                    namaLengkap!,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                // Username
                Text(
                  tipeAkun!,
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
              ],
            ),
          ),
          // Section 2 - Account Menu
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'DETAIL AKUN',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.5), letterSpacing: 6 / 100, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: MenuTileWidget(
                    margin: EdgeInsets.only(top: 10),
                    icon: SvgPicture.asset(
                      'assets/icons/Heart.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Favorit',
                    subtitle: 'Yuk intip produk favoritmu kembali!',
                  ),
                ),
                // MenuTileWidget(
                //   onTap: (){},
                //   icon: SvgPicture.asset(
                //     'assets/icons/Show.svg',
                //     color: AppColor.secondary.withOpacity(0.5),
                //   ),
                //   title: 'Terakhir Dilihat',
                //   subtitle: 'Produk terakhir yang anda lihat',
                // ),
                MenuTileWidget(
                  icon: SvgPicture.asset(
                    'assets/icons/Bag.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'Pesanan',
                  subtitle: 'Riwayat pesanan anda',
                ),
                // MenuTileWidget(
                //   onTap: () {},
                //   icon: SvgPicture.asset(
                //     'assets/icons/Wallet.svg',
                //     color: AppColor.secondary.withOpacity(0.5),
                //   ),
                //   title: 'Dompet',
                //   subtitle: '',
                // ),
                GestureDetector(
                  onTap: (){},
                  child: MenuTileWidget(
                    icon: SvgPicture.asset(
                      'assets/icons/Profile.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Edit Profile',
                    subtitle: 'Mengubah detail informasi pengguna',
                  ),
                ),
              ],
            ),
          ),

          // Section 3 - Settings
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Keluar Akun',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.5), letterSpacing: 6 / 100, fontWeight: FontWeight.w600),
                  ),
                ),

                GestureDetector(
                  onTap: () async{
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
                  child: MenuTileWidget(
                    icon: SvgPicture.asset(
                      'assets/icons/Log Out.svg',
                      color: Colors.red,
                    ),
                    iconBackground: Colors.red[100]!,
                    title: 'Keluar',
                    titleColor: Colors.red,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
