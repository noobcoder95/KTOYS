import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/views/screens/cart_page.dart';
import 'package:marketky/views/screens/search_page.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartValue;
  final int chatValue;

  MainAppBar({
    required this.cartValue,
    required this.chatValue,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              child: Container(
                height: 40,
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(
                        'assets/icons/Search.svg',
                        color: Colors.white,
                        width: 18,
                        height: 18,
                      ),
                    ),
                    Text(
                      'Temukan Produk...',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 16),
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
                  (widget.cartValue != 0)
                      ? Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.accent,
                    ),
                    child: Text(
                      '${widget.cartValue}',
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
              margin: EdgeInsets.only(left: 16),
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
                  (widget.chatValue != 0)
                      ? Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.accent,
                    ),
                    child: Text(
                      '${widget.chatValue}',
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
      ), systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
