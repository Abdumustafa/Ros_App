import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditReview extends StatelessWidget {
  static const String routeName = "EditReview";
  const EditReview({super.key});

  @override
  Widget build(BuildContext context) {
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
            "Edit Review",
            style: GoogleFonts.merriweather(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
          body: Column(
            children: [
              const Center(child: Text("Edit Review")),
            ],
          ),
    );
  }
}
