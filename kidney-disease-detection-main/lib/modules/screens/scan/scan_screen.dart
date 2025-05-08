import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/shared/network/local/cached_data.dart';
import 'package:graduation_project/shared/network/remote/api_manager.dart';
import 'package:graduation_project/shared/utils/colors.dart';

class ScanScreen extends StatelessWidget {
  static const String routeName = "ScanScreen";
  const ScanScreen({super.key});
  Widget _buildScanButton(
      {required IconData buttonIcon,
      required Color buttonColor,
      required Color iconColor,
      required String textButton}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: buttonColor,
          radius: 30,
          child: Icon(
            buttonIcon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(textButton,
            style: GoogleFonts.crimsonText(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.8)))
      ],
    );
  }

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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Your kidney scan must be a CT scan",
            style: GoogleFonts.crimsonText(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: const Color(0xFF4B4B4B).withOpacity(0.89)),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: _buildScanButton(
                  buttonColor: const Color(0xFFD0EDFB),
                  buttonIcon: Icons.upload_file,
                  iconColor: const Color(0xFF2DC0FF),
                  textButton: "Upload file",
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {},
                child: _buildScanButton(
                  buttonColor: const Color(0xFFF2F2FE),
                  buttonIcon: Icons.image_sharp,
                  iconColor: const Color(0xFF5A6CF3),
                  textButton: "Upload image",
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {},
                child: _buildScanButton(
                  buttonColor: const Color(0xFFFFF1F1),
                  buttonIcon: Icons.camera_alt_outlined,
                  iconColor: const Color(0xFFF08F5F),
                  textButton: "Take photo",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your recent scans",
                  style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder(
                  future: ApiManager.getScanResultsHistory(token),
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
                    final scanResult = snapshot.data?.results;
                    final recentScanResults = scanResult?.take(4).toList();
                    return ListView.separated(
                      itemBuilder: (context, index) => buildRecentScanWidget(
                        context,
                        dateOfResult:
                            recentScanResults?[0].createdAt.toString() ?? "",
                        scanResultImage:
                            recentScanResults?[0].scanFile?.url ?? "",
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                      itemCount: recentScanResults?.length ?? 0,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecentScanWidget(BuildContext context,
      {required String scanResultImage, required String dateOfResult}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFFFCFCFC),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          scanResultImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scan result ${dateOfResult.substring(0, 10)}",
                        style: GoogleFonts.crimsonText(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        dateOfResult.substring(0, 10),
                        style: GoogleFonts.crimsonText(
                          color: const Color(0xFFADADAD),
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
