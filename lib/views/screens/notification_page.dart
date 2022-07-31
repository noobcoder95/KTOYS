import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Notification.dart';
import 'package:marketky/views/widgets/main_app_bar_widget.dart';

import '../../main.dart';
import 'info_ktoys.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => InfoKtoys()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColor.primarySoft, width: 1)),
              ),
              child: Row(
                children: [
                  // Icon Box
                  Container(
                    width: 46,
                    height: 46,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/Info Square.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                  ),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Info KTOYS', style: TextStyle(color: AppColor.secondary, fontFamily: 'poppins', fontWeight: FontWeight.w500)),
                        SizedBox(height: 2),
                        Text('Lihat lebih jauh mengenai KTOYS', style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12)),
                      ],
                    )
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.border,
                  ),
                ],
              ),
            ),
          ),
          // Section 2 - Status ( LIST )
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'STATUS PESANAN',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.5), letterSpacing: 6 / 100, fontWeight: FontWeight.w600),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Notifikasi').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<UserNotification> notifs = [];
                      if(snapshot.data != null)
                      {
                        int length = snapshot.data!.docs.length;

                        for(int i = 0; i < length; i++)
                        {
                          notifs.add(UserNotification.fromJson(snapshot.data!.docs[i]));
                        }
                      }

                      if(notifs.length > 0)
                      {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: AppColor.border,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(image: NetworkImage('${notifs[index].imageUrl}'), fit: BoxFit.cover),
                                      ),
                                      margin: EdgeInsets.only(right: 16),
                                    ),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Title
                                          Text(
                                            '${notifs[index].title}',
                                            style: TextStyle(color: AppColor.secondary, fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                          ),
                                          // Description
                                          Container(
                                            margin: EdgeInsets.only(top: 2, bottom: 8),
                                            child: Text(
                                              '${notifs[index].description}',
                                              style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                            ),
                                          ),
                                          // Datetime
                                          Row(
                                            children: [
                                              SvgPicture.asset('assets/icons/Time Circle.svg', color: AppColor.secondary.withOpacity(0.7)),
                                              Container(
                                                margin: EdgeInsets.only(left: 10),
                                                child: Text(
                                                  '${notifs[index].dateTime}',
                                                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: notifs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        );
                      }
                      else
                      {
                        return Center(
                          child: Text('Tidak ada notifikasi.', style: TextStyle(color: Colors.grey)),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
