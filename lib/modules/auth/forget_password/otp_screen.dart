import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/layout/provider/app_provider.dart';
import 'package:graduation_project/modules/auth/forget_password/reset_password.dart';
import 'package:graduation_project/modules/auth/forget_password/verify_email.dart';
import 'package:graduation_project/shared/utils/colors.dart';
import 'package:graduation_project/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../shared/network/remote/api_manager.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = "otpScreen";

  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  Future<Response?>? _otpCodeFuture;
  late TextEditingController codeController;
  String? email;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve email from route arguments
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs != null) {
      email = routeArgs as String;
    }
  }

  void _verifyCode({required BuildContext context}) {
    if (!_formKey.currentState!.validate()) return;
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email not found.')),
      );
      return;
    }

    setState(() {
      _otpCodeFuture = ApiManager.otpCode(
        email!.trim(),
        codeController.text.trim(),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, VerifyEmail.routeName),
          icon: const Icon(Icons.arrow_back_ios, size: 18),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Image.asset("assets/images/authlogo.png",
                      height: 120, width: 200),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    "Check your email",
                    style: GoogleFonts.merriweather(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (email != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "We’ve sent a code to ",
                          style: GoogleFonts.crimsonText(
                            fontSize: 16,
                            color: secondryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          email!.substring(
                              0,
                              email!.contains('@')
                                  ? email!.indexOf('@')
                                  : email!
                                      .length), //! To get the email without the domain part.
                          style: GoogleFonts.crimsonText(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: constraints.maxHeight * 0.09),
                  Pinput(
                    controller: codeController,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'The code you entered is incorrect. Please try again.'
                        : null,
                    errorPinTheme: PinTheme(
                      width: 300,
                      height: 77,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFF3D3D)),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    showCursor: true,
                    autofocus: true,
                    defaultPinTheme: PinTheme(
                        width: 300,
                        height: 77,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD8DADC)),
                            borderRadius: BorderRadius.circular(15)),
                        textStyle: GoogleFonts.merriweather(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    length: 4,
                    separatorBuilder: (index) {
                      return const SizedBox(
                        width: 16,
                      );
                    },
                    crossAxisAlignment: CrossAxisAlignment.center,
                    keyboardType: TextInputType.number,
                    errorTextStyle: GoogleFonts.crimsonText(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFFFF3D3D),
                    ),
                    onCompleted: (value) => _verifyCode(context: context),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.3),
                  FutureBuilder<Response?>(
                    future: _otpCodeFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                            color: primaryColor);
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        // Handle successful response
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                              settings: RouteSettings(arguments: email),
                            ),
                            (route) => false,
                          );
                        });
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(11),
                        child: CustomButton(
                          buttonText: "Send Code",
                          onPressed: () => _verifyCode(context: context),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:graduation_project/modules/auth/forget_password/reset_password.dart';
// import 'package:graduation_project/modules/auth/forget_password/verify_email.dart';
// import 'package:graduation_project/shared/utils/colors.dart';
// import 'package:graduation_project/widgets/custom_button.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';

// import '../../../shared/network/remote/api_manager.dart';

// class OtpScreen extends StatefulWidget {
//   static const String routeName = "otpScreen";

//   const OtpScreen({super.key});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController codeController;
//   String? email;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     codeController = TextEditingController();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final routeArgs = ModalRoute.of(context)?.settings.arguments;
//     if (routeArgs is String) {
//       email = routeArgs;
//     }
//   }

//   Future<void> _verifyCode() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (email == null) {
//       _showError('Email not found');
//       return;
//     }

//     try {
//       setState(() => _isLoading = true);
//       await ApiManager.otpCode(
//         email!.trim(),
//         codeController.text.trim(),
//         context,
//       );
      
//       if (context.mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ResetPassword(),
//             settings: RouteSettings(arguments: email),
//           ),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       _showError('Verification failed: ${e.toString()}');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _showError(String message) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () => Navigator.pushNamed(context, VerifyEmail.routeName),
//           icon: const Icon(Icons.arrow_back_ios, size: 18),
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: constraints.maxHeight * 0.02),
//                   Image.asset(
//                     "assets/images/authlogo.png",
//                     height: 120,
//                     width: 200,
//                     errorBuilder: (_, __, ___) => const Icon(Icons.error),
//                   ),
//                   SizedBox(height: constraints.maxHeight * 0.04),
//                   Text(
//                     "Check your email",
//                     style: GoogleFonts.merriweather(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   if (email != null)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "We’ve sent a code to ",
//                           style: GoogleFonts.crimsonText(
//                             fontSize: 16,
//                             color: secondryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           email!.split('@').first,
//                           style: GoogleFonts.crimsonText(
//                             fontSize: 18,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   SizedBox(height: constraints.maxHeight * 0.09),
//                   Pinput(
//                     controller: codeController,
//                     validator: (value) => value?.isEmpty ?? true
//                         ? 'The code you entered is incorrect'
//                         : null,
//                     errorPinTheme: PinTheme(
//                       width: 300,
//                       height: 77,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: const Color(0xFFFF3D3D)),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     showCursor: true,
//                     autofocus: true,
//                     defaultPinTheme: PinTheme(
//                       width: 300,
//                       height: 77,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: const Color(0xFFD8DADC)),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       textStyle: GoogleFonts.merriweather(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     length: 4,
//                     separatorBuilder: (index) => const SizedBox(width: 16),
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     keyboardType: TextInputType.number,
//                     errorTextStyle: GoogleFonts.crimsonText(
//                       fontSize: 12,
//                       color: const Color(0xFFFF3D3D),
//                     ),
//                     onCompleted: (_) => _verifyCode(),
//                   ),
//                   SizedBox(height: constraints.maxHeight * 0.3),
//                   _isLoading
//                       ? const CircularProgressIndicator(color: primaryColor)
//                       : Padding(
//                           padding: const EdgeInsets.all(11),
//                           child: CustomButton(
//                             buttonText: "Verify Code",
//                             onPressed: _verifyCode,
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     codeController.dispose();
//     super.dispose();
//   }
// }