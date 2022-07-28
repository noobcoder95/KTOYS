import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/app_color.dart';
import 'notification_page.dart';

class InfoKtoys extends StatefulWidget {
  @override
  _InfoKtoysState createState() => _InfoKtoysState();

}
class _InfoKtoysState extends State<InfoKtoys> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Section 1 - Illustration
            Container(
              margin: EdgeInsets.only(top: 1),
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset('assets/icons/shopping illustration.svg'),
            ),
            // Section 2 - KTOYS with Caption
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'INFO KTOYS',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),
                Text(
                  'Berdiri 2019, oleh pak Rio Nugroho.\nToko mainan KToys menyediakan mainan \n berbagai macam ukuran dan variasi \ndengan harga yang sangat terjangkau untuk kalangan menengah kebawah.',
                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Section 3 - Get Started Button
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()));
                },
                child: Text(
                  'Kembali',
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
    );
  }

}
