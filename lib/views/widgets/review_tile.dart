import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Review.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          Container(
            width: 36,
            height: 36,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage('${review.photoUrl}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Username - Rating - Comments
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username - Rating
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Text(
                            '${review.name}',
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.primary, fontFamily: 'poppins'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: RatingBarIndicator(
                            rating: review.rating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.orange[400],
                            ),
                            itemCount: 5,
                            itemSize: 16,
                            direction: Axis.horizontal,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Comments
                  Text(
                    '${review.review}',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.7), height: 150 / 100),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
