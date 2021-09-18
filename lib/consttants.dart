import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:elearn/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import 'epub_viewer_lib/epub_viewer.dart';
import 'epub_viewer_lib/model/epub_locator.dart';
import 'epub_viewer_lib/utils/util.dart';
import 'generated/l10n.dart';

Color buttonColor = Color(0xff263238);
Color buttonColorAccent = Color(0xff2055AD);

const kBlackColor = Color(0xFF393939);
const background = Color(0xff20202f);
const kLightBlackColor = Color(0xFF8F8F8F);
const kIconColor = Color(0xFFF48A37);
const kProgressIndicator = Color(0xFFBE7066);
const mainapilink = "https://rahilmohammad.in/collegesathi";
final kShadowColor = Color(0xFFD3D3D3).withOpacity(.84);

const List<Map<String, dynamic>> languageMap = [
  {'flag': 'en', 'language': 'English', 'set1': 'en', 'set2': 'EN'},
  {'flag': 'in', 'language': 'Hindi', 'set1': 'hi', 'set2': 'HI'},
  {'flag': 'ar', 'language': 'Arabic', 'set1': 'ar', 'set2': 'AR'},
  {'flag': 'de', 'language': 'German', 'set1': 'de', 'set2': 'DE'},
  {'flag': 'es', 'language': 'Spanish', 'set1': 'es', 'set2': 'ES'},
  {'flag': 'fr', 'language': 'French', 'set1': 'fr', 'set2': 'FR'},
  {'flag': 'ja', 'language': 'Japanese', 'set1': 'ja', 'set2': 'JA'},
  {'flag': 'ru', 'language': 'Russian', 'set1': 'ru', 'set2': 'RU'},
  {'flag': 'th', 'language': 'Thai', 'set1': 'th', 'set2': 'TH'},
  {'flag': 'ur', 'language': 'Urdu', 'set1': 'ur', 'set2': 'UR'},
  {'flag': 'zh', 'language': 'Chinese', 'set1': 'zh', 'set2': 'ZH'},
  {'flag': 'in', 'language': 'Tamil', 'set1': 'ta', 'set2': 'TA'},
  {'flag': 'in', 'language': 'Telugu', 'set1': 'te', 'set2': 'TE'},
  {'flag': 'in', 'language': 'Kannada', 'set1': 'kn', 'set2': 'KN'},
  {'flag': 'ko', 'language': 'Korean', 'set1': 'ko', 'set2': 'KO'},
];

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1508150777642424/3292860364';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1508150777642424/3292860364';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1508150777642424/3380490275';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1508150777642424/3380490275';
  }
  return null;
}

class Constants {
  //App related strings
  static String appName = 'Flutter Ebook App';

  static formatBytes(bytes, decimals) {
    if (bytes == 0) return 0.0;
    var k = 1024,
        dm = decimals <= 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        i = (log(bytes) / log(k)).floor();
    return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
  }
}

/// app share link
const String appShareAndroid = "https://play.google.com/store";
const String appShareIOS = "https://www.apple.com/in/app-store/";

String pathepub;
Directory appDocDirFolder;

Future<String> createFolderInAppDocDir() async {
  Directory downloadsDirectory;
  //Get this App Document Directory

  if (Platform.isAndroid) {
    downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
  } else {
    downloadsDirectory = await getLibraryDirectory();
    downloadsDirectory = await getApplicationDocumentsDirectory();
  }
  //App Document Directory + folder name

  appDocDirFolder = Directory('${downloadsDirectory.path}/elearn/');
  pathepub = appDocDirFolder.path;
  (appDocDirFolder);
  if (await appDocDirFolder.exists()) {
    //if folder already exists return path
    return appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder =
        await appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}

String folderInAppDocDir;
var downpath;

getPath() async {
  folderInAppDocDir = await createFolderInAppDocDir();
}

download(BuildContext context, String booklink) {
  getPath();
  try {
    FlutterDownloader.registerCallback(downloadCallback);
    FlutterDownloader.enqueue(
            url: booklink,
            savedDir: folderInAppDocDir,
            showNotification: true,
            openFileFromNotification: true)
        .then((value) => Fluttertoast.showToast(
            msg: S.of(context).view_START_DOWNLOADING_toast,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0))
        .whenComplete(() {
      return ("Complete");
    });
    epub(booklink);
  } catch (e) {
    ("ERROR ::: $e");
  }
}

epub(String link) {
  downpath = link.substring(link.lastIndexOf('/') + 1, link.length);
  // ('book path ====$localPath');

  EpubViewer.setConfig(
    themeColor: Colors.black,
    identifier: "book",
    scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
    allowSharing: false,
    enableTts: false,
  );
  ("PATH ::: $folderInAppDocDir$downpath");
  EpubViewer.open(
    '$folderInAppDocDir$downpath',
    // '/storage/emulated/0/Download/elearn/$downpath',
    lastLocation: EpubLocator.fromJson({
      "bookId": "9701",
      "href": "/OEBPS/ch06.xhtml",
      "created": 1539934158390,
      "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
    }),
  ); //
  EpubViewer.locatorStream;
  EpubViewer.locatorStream.listen((locator) {
    ('LOCATOR:${EpubLocator.fromJson(jsonDecode(locator))}');
  });
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  try {
    if (debug) {
      ('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  } catch (e) {
    ('ERROR IN EPUB DOWNLOAD  $e');
  }
}

///Listview image
List images = [
  "assets/listview/1.png",
  "assets/listview/2.png",
  "assets/listview/3.png",
  "assets/listview/4.png",
];
