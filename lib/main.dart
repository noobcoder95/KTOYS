import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:flutter/services.dart';
import 'package:marketky/views/screens/home_page.dart';
import 'package:marketky/views/screens/penjual/dashboard.dart';
import 'package:marketky/views/screens/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String? namaLengkap, namaPengguna, alamatLengkap, tipeAkun;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  namaPengguna = preferences.getString('namaPengguna');
  namaLengkap = preferences.getString('namaLengkap');
  alamatLengkap = preferences.getString('alamatLengkap');
  tipeAkun = preferences.getString('tipeAkun');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColor.primary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
      ),
      home: auth.currentUser != null && auth.currentUser!.uid != 'Je9hfwGkGDVOMX4q6N6pwu5L4Q23' ?
      HomePage() :
      auth.currentUser != null && auth.currentUser!.uid == 'Je9hfwGkGDVOMX4q6N6pwu5L4Q23' ?
      DashboardPage() :
      WelcomePage(),
    );
  }
}
