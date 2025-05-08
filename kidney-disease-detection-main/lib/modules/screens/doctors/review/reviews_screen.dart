import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/modules/screens/doctors/review/edit_review.dart';
import 'package:graduation_project/shared/network/local/cached_data.dart';
import 'package:graduation_project/shared/network/remote/api_manager.dart';
import 'package:graduation_project/shared/utils/colors.dart';
import 'package:graduation_project/shared/utils/dialogs.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class UserReviewsScreen extends StatelessWidget {
  static const String routeName = "ReviewsScreen";
  const UserReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String token = CachedData.getFromCache("token");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "My Reviews",
            style: GoogleFonts.merriweather(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
      body: FutureBuilder(
          future: ApiManager.getUserReview(token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
                strokeCap: StrokeCap.round,
                strokeWidth: 6,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final userReview = snapshot.data?.results;
            return buildUserReviewWidget(
              context,
            );
          }),
    );
  }

  buildUserReviewWidget(
    BuildContext context,
    // {
    //   required String profileImage,
    //    required int rating,
    //     required String reviewDate,
    //     required String review,
    //     required String userName,
    //     required String doctorName,
    //     }
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage("profileImage"),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "userName",
                    style: GoogleFonts.merriweather(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "doctorName",
                    style: GoogleFonts.merriweather(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SmoothStarRating(
            rating: 4,
            color: Colors.amber,
            borderColor: Colors.amber,
            allowHalfRating: true,
            starCount: 5,
            size: 20.0,
          ),
          Text(
            "reviewDate",
            style: GoogleFonts.merriweather(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            "review",
            style: GoogleFonts.merriweather(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
