import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/models/review_model.dart';
import 'package:graduation_project/modules/screens/doctors/review/reviews_screen.dart';
import 'package:graduation_project/shared/utils/dialogs.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildDoctorDetailsWidget(
    {required String doctorImage,
    required String doctorNumber,
    required BuildContext context,
    required String doctorName,
    required int experienceNumber,
    required String doctorDescription,
    required Widget mapWidget,
    required int doctorRate,
    required Future<ReviewModel>? reviewsFuture,
    // required Future<Response?>? addReviewFuture, // Remove parameter
    required List<Review>? reviewsList,
    required GlobalKey<FormState> reviewFormKey,
    required TextEditingController reviewController,
    required Function(BuildContext) send, // Specify context parameter type
    required double currentUserRating, // Add rating state parameter
    required Function(double) onRatingChanged, // Add rating update callback

    // required double reviewRate, // Keep commented if not used
    // required Function(double) onRatingChangedMethod, // Keep commented if not used
    //  required int totalReviews,
    required String doctorAddress}) {
  return SingleChildScrollView(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Image.network(
                doctorImage,
                height: 200,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                height: 14,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      Container(
        height: 600,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                doctorName,
                style: GoogleFonts.merriweather(
                  color: const Color(0xFF2F79E8),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final whatsappUrl = "https://wa.me/2$doctorNumber";

                  if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                    await launchUrl(Uri.parse(whatsappUrl));
                  } else {
                    showError(
                        context, "WhatsApp is not installed on your device");
                  }
                },
                child: Container(
                    width: 63,
                    height: 33,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F79E8).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Center(
                      child: Image.asset("assets/images/whatsapp_icon.png"),
                    )),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFCB551)),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${doctorRate.toInt()}",
                    style: GoogleFonts.montserrat(
                        color: const Color(0xFF333333),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ]),

            // Text(
            //   "Cardiologist",
            //   style: GoogleFonts.merriweather(
            //     color: const Color(0xFF2F79E8),
            //     fontWeight: FontWeight.bold,
            //     fontSize: 15,
            //   ),
            // ),
            Text(
              " ${experienceNumber.toInt()} years of experience ",
              style: GoogleFonts.crimsonText(
                color: Colors.black.withOpacity(0.6),
                fontSize: 11.5,
                fontWeight: FontWeight.normal,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.black.withOpacity(0.6),
                  size: 15,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  doctorAddress,
                  style: GoogleFonts.crimsonText(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              "About Doctor",
              style: GoogleFonts.merriweather(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Text(
              doctorDescription,
              style: GoogleFonts.crimsonText(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Location",
              style: GoogleFonts.crimsonText(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            mapWidget,
            const SizedBox(
              height: 22,
            ),
            Row(
              children: [
                Text(
                  "reviews",
                  style: GoogleFonts.crimsonText(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserReviewsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Your Review",
                    style: GoogleFonts.crimsonText(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ));
                    //! Create the Sceltonizer .
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data?.results == []) {
                    return const Center(child: Text('Reviews not found'));
                  }
                  final reviews = snapshot.data?.results ?? [];
                  if (reviews.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/no_reviews_icon.png",
                              scale: 10,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              'No reviews Yet\nBe the first one',
                              style: GoogleFonts.crimsonText(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: reviews.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F9FE),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 0.5, color: const Color(0xFFCFDEF9)),
                            ),
                            padding: const EdgeInsets.all(12.5),
                            width: 214,
                            height: 80,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: NetworkImage(
                                          reviews[index]
                                              .user
                                              .profileImage
                                              .toString()),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          reviews[index].user.userName,
                                          style: GoogleFonts.crimsonText(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SmoothStarRating(
                                            allowHalfRating: false,
                                            rating: reviews[index]
                                                .rating
                                                .toDouble(),
                                            starCount: 5,
                                            size: 15.0,
                                            color: const Color(0xFFFCB551),
                                            borderColor:
                                                const Color(0xFFFCB551),
                                            spacing: 0.0),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      textDirection: TextDirection.rtl,
                                      reviews[index].createdAt.substring(0, 10),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 7,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(reviews[index].comment,
                                    style: GoogleFonts.crimsonText(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
      const SizedBox(
        height: 25,
      ),
      Container(
        padding: const EdgeInsets.all(10),
        height: 250,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20.0,
                  backgroundImage:
                      AssetImage('assets/images/profile_image.png'),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text("John Doe",
                    style: GoogleFonts.crimsonText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.8),
                    )),
              ],
            ),
            const SizedBox(
              width: 19.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SmoothStarRating(
                        allowHalfRating: false,
                        onRatingChanged: (rating) {
                          // Correct parameter name
                          onRatingChanged(rating); // Call the update function
                        },
                        starCount: 5,
                        rating: currentUserRating, // Set initial/current rating
                        size: 26.0,
                        // filledIconData: Icons.blur_off, // Consider using default icons or customizing
                        // halfFilledIconData: Icons.blur_on, // Consider using default icons or customizing
                        color: const Color(0xFFFCB551),
                        borderColor: const Color(0xFFFCB551),
                        spacing: 10,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Form(
                        key: reviewFormKey,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 3,
                          maxLength: 157,
                          textInputAction: TextInputAction.newline,
                          autofocus: true,
                          style: GoogleFonts.crimsonText(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            // Wrap IconButton in a Builder to get correct context
                            suffixIcon: Builder(
                                builder: (BuildContext iconButtonContext) {
                              return IconButton(
                                onPressed: () => send(
                                    iconButtonContext), // Pass builder's context
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              );
                            }),
                            filled: true,
                            fillColor: const Color(0XFFF2F2F2),
                            focusColor: const Color(0XFFF2F2F2),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 12),
                            hintText: 'Describe your experience',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            errorStyle: GoogleFonts.crimsonText(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          validator: (value) {
                            // Also check if the trimmed value is empty
                            if (value == null || value.trim().isEmpty) {
                              return 'You cannot send an empty review';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Optional: Add logic for text changes
                          },
                          controller: reviewController, // Assign the controller
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]),
  );
}
