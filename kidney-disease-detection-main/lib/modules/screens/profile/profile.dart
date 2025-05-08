import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/modules/auth/login/login.dart';
import 'package:graduation_project/modules/screens/acccount/pages/faq_page.dart';
import 'package:graduation_project/modules/screens/acccount/pages/help_center.dart';
import 'package:graduation_project/modules/screens/acccount/pages/privacy_policy.dart';
import 'package:graduation_project/modules/screens/acccount/pages/profile_page.dart';
import 'package:graduation_project/shared/network/local/cached_data.dart';
import 'package:graduation_project/shared/network/remote/api_manager.dart';
import 'package:graduation_project/shared/utils/dialogs.dart';

class Profile extends StatelessWidget {
  static const String routeName = "Profile";
  final headerTextStyle = GoogleFonts.merriweather(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  final itemTextStyle = GoogleFonts.crimsonText(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black.withOpacity(0.7));
  void logout(BuildContext context) async {
    //! print("Pre-logout token: ${CachedData.getFromCache("token")}"); //? For debugging
    String token = CachedData.getFromCache("token");
    try {
      print("Sending token: $token");
      Response? response =
          await ApiManager.logOut(context: context, token: token);
      //! print("API response: ${response?.data}"); //? For debugging
      if (response?.data["success"] == true) {
        await CachedData.deleteFromCache("token");
        //! print("Post-deletion token: ${CachedData.getFromCache("token")}"); //? For debugging
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.lightBlue,
          duration: const Duration(seconds: 5),
          content: Text(
            "You have been logged out successfully",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ));
      }
    } catch (e) {
      showError(context, e.toString());
    }
  }

  void clearAccount(BuildContext context) async {
    String token = CachedData.getFromCache("token");
    try {
      Response? response =
          await ApiManager.deleteAccount(context: context, token: token);

      if (response?.data["success"] == true) {
        await CachedData.deleteFromCache("token");

        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.lightBlue,
          duration: const Duration(seconds: 5),
          content: Text(
            "Your account has been deleted successfully",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ));
      }
    } catch (e) {
      showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                child: Center(child: buildProfileItem())),
            const SizedBox(height: 10),
            Text(
              "Privacy",
              style: headerTextStyle,
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicy(),
                    ));
              },
              child: buildDrawerItem("assets/images/privacy-policy.png",
                  "Privacy Policy", Icons.arrow_forward_ios),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              thickness: 1.5,
              endIndent: 15,
              color: Color(0xFFD1D5DB),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Help and Support",
              style: headerTextStyle,
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaqPage(),
                    ));
              },
              child: buildDrawerItem(
                "assets/images/faq.png",
                "FAQs",
                Icons.arrow_forward_ios,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpCenter(),
                    ));
              },
              child: buildDrawerItem("assets/images/help-center.png",
                  "Help Center", Icons.arrow_forward_ios),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              thickness: 1.5,
              endIndent: 15,
              color: Color(0xFFD1D5DB),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Dangerous Zone",
              style: headerTextStyle,
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                warningDialog(
                  context,
                  "Are you sure want to delete your account?",
                  "Delete",
                  () {
                    clearAccount(context);
                  },
                );
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  "assets/images/delete.png",
                  height: 25,
                  width: 25,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  "Delete Account",
                  style: GoogleFonts.crimsonText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFe90005)),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFe90005),
                  size: 15,
                ),
              ]),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              thickness: 1.5,
              endIndent: 15,
              color: Color(0xFFD1D5DB),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Sign Out",
              style: headerTextStyle,
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                warningDialog(
                  context,
                  "Are you sure want to logout?",
                  "Logout",
                  () {
                    logout(context);
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => LoginScreen()),
                    //     (route) => false);
                  },
                );
              },
              child: buildDrawerItem("assets/images/logout.png", "Logout",
                  Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(String leftIcon, String title, IconData rightIcon) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          leftIcon,
          height: 33,
          width: 33,
        ),
        const SizedBox(
          width: 18,
        ),
        Text(
          title,
          style: itemTextStyle,
        ),
        const Spacer(),
        Icon(
          rightIcon,
          color: Colors.black.withOpacity(0.7),
          size: 15,
        ),
      ]);
}

Widget buildProfileItem() {
  return Container(
    padding: const EdgeInsets.all(12.0),
    margin: const EdgeInsets.all(5.0),
    child: Column(
      children: [
        const Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/profile_image.png"),
            ),
            CircleAvatar(
              backgroundColor: Color(0xFF666666),
              radius: 8,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 10,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          "Amir saied",
          style: GoogleFonts.merriweather(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
