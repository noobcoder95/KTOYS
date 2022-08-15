import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/main.dart';
import 'package:marketky/views/screens/image_viewer.dart';
import 'package:marketky/views/screens/reviews_page.dart';
import 'package:marketky/views/widgets/modals/add_to_cart_modal.dart';
import 'package:marketky/views/widgets/rating_tag.dart';
import 'package:marketky/views/widgets/review_tile.dart';
import 'package:marketky/views/widgets/selectable_circle_color.dart';
import 'package:marketky/views/widgets/selectable_circle_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constant/idr_currency.dart';
import '../../core/model/Review.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  ProductDetail({required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  List<Product> favorite = [];
  List<Review> reviews = [];
  
  @override
  void initState() {
    super.initState();
    init();
  }
  
  void init()
  {
    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Favorite').get().then((value) {
      if(value.docs.length > 0)
      {
        for(int i = 0; i < value.docs.length; i++)
        {
          Product product = Product.fromDocument(value.docs[i]);
          favorite.add(product);
        }
      }
    });
    FirebaseFirestore.instance.collection('products').doc(widget.product.productId).get().then((product) {
      Product _product = Product.fromDocument(product);
      reviews.addAll(_product.reviews);
      setState(() {});
      print(reviews.length);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: tipeAkun == 'Pembeli' ?
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColor.border, width: 1),
          ),
        ),
        child: Row(
          children: [
            /*
            Container(
              width: 64,
              height: 64,
              margin: EdgeInsets.only(right: 14),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColor.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {},
                child: SvgPicture.asset('assets/icons/Chat.svg', color: Colors.white),
              ),
            ),
            */
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return AddToCartModal(product: widget.product);
                      },
                    );
                  },
                  child: Text(
                    'Masukkan Keranjang',
                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: reviews.any((element) => element.userID == auth.currentUser!.uid) ?
                    Colors.grey :
                    AppColor.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: ()
                  {
                    if(reviews.any((element) => element.userID == auth.currentUser!.uid))
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: AppColor.primary,
                        content: Text('Anda sudah pernah memberi ulasan'),
                        duration: Duration(seconds: 3),
                      ));
                    }
                    else
                    {
                      TextEditingController text = TextEditingController();
                      double rating = 3;
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('Ulasan', textAlign: TextAlign.center),
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * .2 + 50,
                                  child: Column(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          rating = value;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        height: 100,
                                        child: TextField(
                                          controller: text,
                                          maxLines: null,
                                          decoration: InputDecoration(hintText: "Beri ulasan"),
                                          keyboardType: TextInputType.multiline,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('Kirim'),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColor.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    onPressed: () {
                                      if(text.value.text.isNotEmpty)
                                      {
                                        Review newReview = Review(
                                            photoUrl: auth.currentUser!.photoURL ?? '',
                                            userID: auth.currentUser!.uid,
                                            name: namaPengguna!,
                                            review: text.value.text,
                                            rating: rating);

                                        reviews.add(newReview);
                                        List listReview = [];
                                        double rateAmount = 0;
                                        for(int i = 0; i < reviews.length; i++)
                                        {
                                          listReview.add({
                                            'photo_url': reviews[i].photoUrl,
                                            'name': reviews[i].name,
                                            'review': reviews[i].review,
                                            'rating': reviews[i].rating,
                                            'user_id': reviews[i].userID
                                          });
                                          rateAmount = rateAmount + reviews[i].rating;
                                        }
                                        FirebaseFirestore.instance.collection('products').doc(widget.product.productId).update({
                                          'reviews': listReview,
                                          'rating': rateAmount / listReview.length
                                        }).then((value) => Navigator.of(context).pop());
                                      }
                                    },
                                  ),
                                ],
                              )
                      ).then((value) => setState((){}));
                    }
                  },
                  child: Text(
                    'Beri Ulasan',
                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ) :
      null,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - appbar & product image
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // product image
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(imageUrl: widget.product.image),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  color: Colors.white,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    controller: productImageSlider,
                    children: List.generate(
                      widget.product.image.length,
                      (index) => Image.network(
                        widget.product.image[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // appbar
              Padding(
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
                          '${widget.product.storeName}',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            DocumentReference doc = FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collection('Favorite').doc(widget.product.productId);

                            doc.get().then((value)
                            {
                              if(value.exists)
                              {
                                favorite.removeWhere((product) => product.productId == widget.product.productId);
                                doc.delete().then((value) => setState((){}));

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: AppColor.primary,
                                  content: Text('Produk dihapus dari favorite'),
                                  duration: Duration(seconds: 3),
                                ));
                              }

                              else
                              {
                                favorite.add(widget.product);
                                List colors = [], sizes = [];

                                for(int i = 0; i < widget.product.colors.length; i++)
                                {
                                  colors.add({
                                    'name': widget.product.colors[i].name,
                                    'color': widget.product.colors[i].color.toString(),
                                  });
                                }

                                for(int i = 0; i < widget.product.sizes.length; i++)
                                {
                                  sizes.add({
                                    'name': widget.product.sizes[i].name,
                                    'size': widget.product.sizes[i].size,
                                  });
                                }

                                doc.set({
                                  'image': widget.product.image,
                                  'name': widget.product.name,
                                  'price': widget.product.price,
                                  'rating': 5.0,
                                  'stocks': 0,
                                  'description': widget.product.description,
                                  'store_name': widget.product.storeName,
                                  'store_id': widget.product.storeId,
                                  'colors': colors,
                                  'sizes': sizes,
                                  'reviews': []
                                }).then((value) => setState((){}));

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: AppColor.primary,
                                  content: Text('Produk ditambahkan ke favorite'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            primary: AppColor.primarySoft,
                            elevation: 0,
                            onPrimary: AppColor.primary,
                            padding: EdgeInsets.all(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/Heart.svg',
                            color: favorite.any((element) => element.productId == widget.product.productId) ?
                            Colors.red :
                            Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // indicator
              Positioned(
                bottom: 16,
                child: SmoothPageIndicator(
                  controller: productImageSlider,
                  count: widget.product.image.length,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColor.primary.withOpacity(0.2),
                    activeDotColor: AppColor.primary.withOpacity(0.2),
                    dotHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - product info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.secondary),
                        ),
                      ),
                      RatingTag(
                        margin: EdgeInsets.only(left: 10),
                        value: widget.product.rating,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Text(
                    '${CurrencyFormat.convertToIdr(widget.product.price, 2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.primary),
                  ),
                ),
                Text(
                  widget.product.description,
                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), height: 150 / 100),
                ),
              ],
            ),
          ),
          // Section 3 - Color Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warna',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                SelectableCircleColor(
                  colorWay: widget.product.colors,
                  margin: EdgeInsets.only(top: 12),
                ),
              ],
            ),
          ),

          // Section 4 - Size Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ukuran',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                SelectableCircleSize(
                  productSize: widget.product.sizes,
                  margin: EdgeInsets.only(top: 12),
                ),
              ],
            ),
          ),

          // Section 5 - Reviews
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  childrenPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  title: Text(
                    'Ulasan',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'poppins',
                    ),
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reviews.length > 0 ?
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ReviewTile(review: reviews[index]),
                      separatorBuilder: (context, index) => SizedBox(height: 16),
                      itemCount: reviews.length,
                    ) :
                    Center(
                      child: Text('Belum ada ulasan'),
                    ),
                    reviews.length > 0 ?
                    Container(
                      margin: EdgeInsets.only(left: 52, top: 12, bottom: 6),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReviewsPage(
                                reviews: reviews,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat ulasan lainnya',
                          style: TextStyle(color: AppColor.secondary, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          onPrimary: AppColor.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          primary: AppColor.primarySoft,
                        ),
                      ),
                    ) :
                    SizedBox.shrink()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
