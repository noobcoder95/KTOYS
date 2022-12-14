import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Review.dart';
import 'package:marketky/views/widgets/review_tile.dart';

class ReviewsPage extends StatefulWidget {
  final List<Review> reviews;
  ReviewsPage({required this.reviews});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> with TickerProviderStateMixin {
  int _selectedTab = 0;
  double average = 0;
  List<Review> oneStar = [], twoStar = [], threeStar = [], fourStar = [], fiveStar = [];

  void init()
  {
    double value = 0;
    for(int i = 0; i < widget.reviews.length; i++)
    {
      value += widget.reviews[i].rating;
      if(widget.reviews[i].rating < 2)
      {
        oneStar.add(widget.reviews[i]);
      }
      if(widget.reviews[i].rating >= 2 && widget.reviews[i].rating < 3)
      {
        twoStar.add(widget.reviews[i]);
      }
      if(widget.reviews[i].rating >= 3 && widget.reviews[i].rating < 4)
      {
        threeStar.add(widget.reviews[i]);
      }
      if(widget.reviews[i].rating >= 4 && widget.reviews[i].rating < 5)
      {
        fourStar.add(widget.reviews[i]);
      }
      if(widget.reviews[i].rating == 5)
      {
        fiveStar.add(widget.reviews[i]);
      }
    }
    average =  value / widget.reviews.length;

  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 54,
              margin: EdgeInsets.only(top: 14),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: ()=> Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        primary: AppColor.primarySoft,
                        elevation: 0,
                        onPrimary: AppColor.primary,
                        padding: EdgeInsets.all(8),
                      ),
                      child: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 5.5 / 10,
                    height: 40,
                    decoration: BoxDecoration(color: AppColor.primarySoft, borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    child: Text(
                      'Ulasan',
                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        primary: AppColor.primarySoft,
                        elevation: 0,
                        onPrimary: AppColor.primary,
                        padding: EdgeInsets.all(8),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/Bookmark.svg',
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1 - Header
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      average.toStringAsFixed(1),
                      style: TextStyle(fontSize: 52, fontWeight: FontWeight.w700, fontFamily: 'poppins'),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: average,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.orange[400],
                        ),
                        itemCount: 5,
                        itemSize: 28,
                        direction: Axis.horizontal,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          'Berdasarkan ${widget.reviews.length} Ulasan',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Section 2 - Tab
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 16, bottom: 24),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 0;
                      });
                    },
                    child: Text(
                      'Semua Ulasan',
                      style: TextStyle(color: (_selectedTab == 0) ? Colors.white : Colors.grey),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      primary: (_selectedTab == 0) ? AppColor.primary : Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 1;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg', width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '1 (${oneStar.length})',
                            style: TextStyle(color: (_selectedTab == 1) ? Colors.white : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      primary: (_selectedTab == 1) ? AppColor.primary : Colors.white,
                      onPrimary: AppColor.border,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 2;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg', width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '2 (${twoStar.length})',
                            style: TextStyle(color: (_selectedTab == 2) ? Colors.white : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      primary: (_selectedTab == 2) ? AppColor.primary : Colors.white,
                      onPrimary: AppColor.border,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 3;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg', width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '3 (${threeStar.length})',
                            style: TextStyle(color: (_selectedTab == 3) ? Colors.white : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      primary: (_selectedTab == 3) ? AppColor.primary : Colors.white,
                      onPrimary: AppColor.border,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 4;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg', width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '4 (${fourStar.length})',
                            style: TextStyle(color: (_selectedTab == 4) ? Colors.white : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      primary: (_selectedTab == 4) ? AppColor.primary : Colors.white,
                      onPrimary: AppColor.border,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 5;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg', width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '5 (${fiveStar.length})',
                            style: TextStyle(color: (_selectedTab == 5) ? Colors.white : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      primary: (_selectedTab == 5) ? AppColor.primary : Colors.white,
                      onPrimary: AppColor.border,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),

            // Section 3 - List Review
            IndexedStack(
              index: _selectedTab,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ReviewTile(review: widget.reviews[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: widget.reviews.length,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ReviewTile(review: oneStar[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: oneStar.length,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ReviewTile(review: twoStar[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: twoStar.length,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ReviewTile(review: threeStar[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: threeStar.length,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ReviewTile(review: fourStar[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: fourStar.length,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ReviewTile(review: fiveStar[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: fiveStar.length,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
