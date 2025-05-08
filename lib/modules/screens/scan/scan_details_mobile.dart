// import 'dart:io';
// import 'dart:typed_data';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> savePdf(Uint8List pdfBytes, String fileName) async {
//   final status = await Permission.storage.request();
//   if (!status.isGranted) throw Exception('Storage permission denied');

//   Directory directory;
//   if (Platform.isAndroid) {
//     directory = (await getExternalStorageDirectory())!;
//   } else if (Platform.isIOS) {
//     directory = await getApplicationDocumentsDirectory();
//   } else {
//     throw UnsupportedError('Unsupported platform');
//   }

//   final path = '${directory.path}/$fileName';
//   final file = File(path);
//   await file.writeAsBytes(pdfBytes);
//   await OpenFile.open(path);
// }