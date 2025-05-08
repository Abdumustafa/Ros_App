import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/models/doctors_details_model.dart';
import 'package:graduation_project/models/review_model.dart';
import 'package:graduation_project/modules/screens/doctors/details_widget.dart';
import 'package:graduation_project/shared/network/local/cached_data.dart';
import 'package:graduation_project/shared/network/remote/api_manager.dart';
import 'package:graduation_project/shared/utils/colors.dart';
import 'package:graduation_project/shared/utils/dialogs.dart'; // Import dialogs
import 'package:graduation_project/widgets/map_image.dart';

class DoctorsDetails extends StatefulWidget {
  static const String routeName = 'DoctorsDetails';
  const DoctorsDetails({super.key});

  @override
  State<DoctorsDetails> createState() => _DoctorsDetailsState();
}

class _DoctorsDetailsState extends State<DoctorsDetails> {
  late Future<DoctorsDetailsModel> _doctorsDetailsFuture;
  late Future<ReviewModel> _getAllReviewsFuture;
  List<Review>? reviews;
  late String doctorId;
  final reviewFormKey = GlobalKey<FormState>();
  bool _isSubmittingReview = false; // Add state to prevent double submission
  double _currentUserRating = 0.0; // State variable for user's rating input

  // Function to update the rating state
  void _updateRating(double rating) {
    setState(() {
      _currentUserRating = rating;
    });
  }

  final TextEditingController reviewController = TextEditingController();
  // Modify the function to accept rating and handle result/errors
  void _addReview(BuildContext context, double rating) async {
    if (!reviewFormKey.currentState!.validate()) return;

    // Make async
    // Prevent double submission
    if (_isSubmittingReview) return;

    // Check rating
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please add your rating."),
      ));
      return;
    }

    // Validate form

    final String review = reviewController.text.trim();
    String token = CachedData.getFromCache("token");

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Authentication error. Please log in again."),
        backgroundColor: Colors.red,
      ));
      // Optionally navigate to login screen
      return;
    }

    setState(() {
      _isSubmittingReview = true; // Set submitting flag
    });

    try {
      final response = await ApiManager.addDoctorReview(
        token: token,
        comment: review,
        rating: rating.round(),
        doctorId: doctorId,
        context: context, // Pass context for potential dialogs in ApiManager
      );

      if (response != null && response.data?["success"] == true) {
        // Success: Show success message, clear form, maybe refresh reviews
        //!added
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Review added successfully!"),
        ));
        reviewController.clear();
        _updateRating(0); // Reset rating UI
        // Refresh reviews by re-fetching
        setState(() {
          _getAllReviewsFuture = ApiManager.getAllReviews(doctorId);
        });
      } else {
        // Handle API-level errors shown by ApiManager's showError or specific messages
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response?.data?["message"] ??
              "Failed to add review. You have already reviewed this doctor."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle unexpected errors during the call
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An unexpected error occurred: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      // Always reset the submitting flag
      setState(() {
        _isSubmittingReview = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    doctorId = ModalRoute.of(context)?.settings.arguments as String;
    _doctorsDetailsFuture = ApiManager.getDoctorsDetails(doctorId);
    _getAllReviewsFuture = ApiManager.getAllReviews(doctorId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Doctor's Information",
          style: GoogleFonts.merriweather(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: FutureBuilder(
        future: _doctorsDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
              strokeCap: StrokeCap.round,
              strokeWidth: 6,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data?.doctor == null) {
            return const Center(child: Text('Doctor not found'));
          }
          final doctor = snapshot.data?.doctor;
          return buildDoctorDetailsWidget(
            context: context,
            doctorNumber: doctor?.phoneNumber ?? "",
            // send: _addReview, // Removed duplicate
            reviewFormKey: reviewFormKey,
            reviewController: reviewController,
            // addReviewFuture: addReviewFuture, // Remove parameter
            reviewsList: reviews,
            reviewsFuture: _getAllReviewsFuture,
            mapWidget: MapImage(
              latitude: doctor?.mapLocation?.lat ?? "",
              longitude: doctor?.mapLocation?.lng ?? "",
              apiKey: "AIzaSyB2U6ZXe-ombZJIig1q9kk6tYh3yjZ5pu8",
            ),
            doctorAddress: doctor?.address ?? "",
            doctorDescription: doctor?.aboutDoctor ?? "",
            doctorImage: doctor?.image?.url ?? "",
            doctorName: doctor?.name ?? "",
            experienceNumber: doctor?.experience ?? 0,
            doctorRate: doctor?.avgRating ?? 0,
            // Pass the current rating and the update function to the widget
            currentUserRating: _currentUserRating,
            onRatingChanged: _updateRating,
            // Modify the send lambda to include the current rating
            send: (context) => _addReview(context, _currentUserRating),
          );
        },
      ),
    );
  }
}
