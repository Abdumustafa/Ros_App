import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/layout/provider/app_provider.dart';
import 'package:graduation_project/shared/network/remote/api_manager.dart';
import 'package:graduation_project/shared/utils/colors.dart';
import 'package:graduation_project/widgets/components.dart';
import 'package:graduation_project/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../shared/network/local/cached_data.dart';
import '../../../../widgets/text_field.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = "ProfilePage";

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool isHidden = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _updatedEmailController = TextEditingController();

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: GoogleFonts.merriweather(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: ApiManager.getUserData(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              strokeWidth: 6,
              color: primaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data?.results;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 150,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.network(
                        "${userData?.user?.profileImage?.url}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "${userData?.user?.userName}",
                    style: GoogleFonts.roboto(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${userData?.user?.email}",
                    style: GoogleFonts.roboto(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headTitlesOfTextField("Email"),
                        CustomTextFormField(
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          controller: _updatedEmailController,
                          suffixIcon: provider.hasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.email,
                                  color: secondryColor, size: 20),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Email must not be empty. Please try again.';
                            }
                            final emailRegExp = RegExp(
                                r"^(?=\S)([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$");
                            if (!emailRegExp.hasMatch(text)) {
                              provider.showSuffixIconInError(ishasError: true);
                              return "Please enter a valid email address (example@mail.com).";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        headTitlesOfTextField("Old Password"),
                        CustomTextFormField(
                          keyboardType: TextInputType.text,
                          hintText: "Enter old password",
                          controller: _oldPasswordController,
                          obscureText: provider.isHidden,
                          suffixIcon: IconButton(
                            onPressed: () =>
                                provider.toggleObscureText(provider.isHidden),
                            icon: provider.isHidden
                                ? const Icon(Icons.visibility_outlined,
                                    color: secondryColor, size: 20)
                                : const Icon(Icons.visibility_off_outlined,
                                    color: secondryColor, size: 20),
                          ),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Password must not be empty. Please try again.';
                            }
                            if (text.length < 8) {
                              return 'Password should be at least 8 characters.';
                            }
                            final passwordRegExp = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\\$&*~]).{8,}\$');
                            if (!passwordRegExp.hasMatch(text)) {
                              return "Password must contain at least 8 characters - 1 uppercase letter, 1 lowercase\n1 number, and 1 symbol.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        headTitlesOfTextField("New Password"),
                        CustomTextFormField(
                          keyboardType: TextInputType.text,
                          hintText: "Enter new password",
                          controller: _newPasswordController,
                          obscureText: provider.isHidden,
                          suffixIcon: IconButton(
                            onPressed: () =>
                                provider.toggleObscureText(provider.isHidden),
                            icon: provider.isHidden
                                ? const Icon(Icons.visibility_outlined,
                                    color: secondryColor, size: 20)
                                : const Icon(Icons.visibility_off_outlined,
                                    color: secondryColor, size: 20),
                          ),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Password must not be empty. Please try again.';
                            }
                            if (text.length < 8) {
                              return 'Password should be at least 8 characters.';
                            }
                            final passwordRegExp = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\\$&*~]).{8,}\$');
                            if (!passwordRegExp.hasMatch(text)) {
                              return "Password must contain at least 8 characters - 1 uppercase letter, 1 lowercase\n1 number, and 1 symbol.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        headTitlesOfTextField("Confirm Password"),
                        CustomTextFormField(
                          keyboardType: TextInputType.text,
                          hintText: "Enter confirm password",
                          controller: _confirmNewPasswordController,
                          obscureText: provider.isHidden,
                          suffixIcon: IconButton(
                            onPressed: () =>
                                provider.toggleObscureText(provider.isHidden),
                            icon: provider.isHidden
                                ? const Icon(Icons.visibility_outlined,
                                    color: secondryColor, size: 20)
                                : const Icon(Icons.visibility_off_outlined,
                                    color: secondryColor, size: 20),
                          ),
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Invalid password. Follow the rules.';
                            }
                            if (text != _newPasswordController.text) {
                              return 'Passwords do not match. Please try again.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          buttonText: "Update",
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
