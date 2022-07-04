import 'dart:io';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratePDFProvider extends ChangeNotifier {
  Future<bool> callGeneratePDFapi(header, userid) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      Response response = await Dio().get(
        "https://api.smartseaman.devbyopeneyes.com/public/crew-generate-pdf/$userid",
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return true;
            }),
      );

      
      print('Response is');
      print(response.statusCode);
      File file;
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        file = File("${directory!.path}/resume.pdf");
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
      } else {
        final directory = await getApplicationDocumentsDirectory();
        file = File("${directory.path}/resume.pdf");
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
      }

      print(file.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Downloading status',
          'Your file has been downloaded at: ${file.path}');
      // var tempDir = await getApplicationDocumentsDirectory();
      // print(tempDir.path);
      // var file = File("/storage/emulated/0/Download/resume.pdf")
      //     .openSync(mode: FileMode.write);
      // file.writeFromSync(response.data);
      // print(file.path);
      // await file.close();

      // final taskId = await FlutterDownloader.enqueue(
      //   url: 'https://api.smartseaman.devbyopeneyes.com/public/generate-pdf/' +
      //       userid,
      //   savedDir: directory.path,
      //   showNotification:
      //       true, // show download progress in status bar (for Android)
      //   openFileFromNotification:
      //       true, // click on notification to open downloaded file (for Android)
      // );
      // print(response.data.toString());
      // print(taskId);

      return true;

      // Here, you're catching an error and printing it. For production
      // apps, you should display the warning to the user and give them a
      // way to restart the download.
    } catch (e) {
      print(e);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Downloading status', 'Something went wrong');
      return false;
    }
  }
}
