import 'dart:io';

import 'package:elearn/widgets/download_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'downloaddb.dart';
import 'favdb.dart';
import 'feed.dart';

class DetailsProvider extends ChangeNotifier {
  bool loading = true;
  EbookApp entry;
  var favDB = FavoriteDB();
  var dlDB = DownloadsDB();

  bool faved = false;
  bool downloaded = false;

  checkFav() async {
    List c = await favDB.check({'id': entry.id.toString()});
    if (c.isNotEmpty) {
      setFaved(true);
    } else {
      setFaved(false);
    }
  }

  addFav() async {
    await favDB.add({'id': entry.id.toString(), 'item': entry.toJson()});
    checkFav();
  }

  removeFav() async {
    favDB.remove({'id': entry.id.toString()}).then((v) {
      (v);
      checkFav();
    });
  }

  // check if book has been downloaded before
  checkDownload() async {
    List downloads = await dlDB.check({'id': entry.id.toString()});
    if (downloads.isNotEmpty) {
      // check if book has been deleted
      String path = downloads[0]['path'];

      if (await File(path).exists()) {
        setDownloaded(true);
      } else {
        setDownloaded(false);
      }
    } else {
      setDownloaded(false);
    }
  }

  Future<List> getDownload(id) async {
    List c = await dlDB.check({'id': id.toString()});
    return c;
  }

  addDownload(Map body, id) async {
    await dlDB.removeAllWithId({'id': id});
    await dlDB.add(body);
    checkDownload();
  }

  removeDownload() async {
    dlDB.remove({'id': entry.id.toString()}).then((v) {
      (v);
      checkDownload();
    });
  }

  Future downloadFile(BuildContext context, String url, String filename, int id,
      String img) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      startDownload(context, url, filename, id, img);
    } else {
      startDownload(context, url, filename, id, img);
    }
  }

  startDownload(BuildContext context, String url, String filename, int id,
      String img) async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      Directory(appDocDir.path + '/Ebook').create();
    }
    print("directory==================${appDocDir.path}");

    String path;
    try {
      path = Platform.isIOS
          ? appDocDir.path + '/$filename.epub'
          : appDocDir.path + '/Ebook/$filename.epub';
      File file = File(path);
      if (!await file.exists()) {
        await file.create();
      } else {
        await file.delete();
        await file.create();
      }
    } catch (e) {
      print('ERROR IN DOWNLOAD $e');
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) {
      if (v != null) {
        addDownload({
          'id': id.toString(),
          'path': path,
          'image': img,
          'size': v,
          'name': filename,
        }, id.toString());
      }
    });
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }

  void setDownloaded(value) {
    downloaded = value;
    notifyListeners();
  }
}
