class Review {
  String photoUrl;
  String name;
  String review;
  double rating;
  String userID;

  Review({
    required this.photoUrl,
    required this.userID,
    required this.name,
    required this.review,
    required this.rating
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      photoUrl: json['photo_url'],
      name: json['name'],
      review: json['review'],
      rating: json['rating'],
      userID: json['user_id']
    );
  }
}
