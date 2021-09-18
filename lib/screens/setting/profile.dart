import 'dart:convert' as convert;
import 'dart:io';

import 'package:elearn/consttants.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/title.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({this.name, this.image, this.email, this.phonenumber});

  String name;
  String image;
  String email;
  String phonenumber;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController;
  int user_id;

  bool spin = false;
  var path;
  File imageF;
  final _form = GlobalKey<FormState>();
  String user_name;
  String _email;
  String type;
  SharedPreferences pref;

  @override
  void initState() {
    pre();
    getUserProfile();
    super.initState();
  }

  pre() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      _email = pref.getString("email");
    });
    type = pref.getString("type");
  }

  getUserProfile() async {
    setState(() {
      spin = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    user_id = pref.getInt('uid');
    var response = await http
        .get(Uri.parse("$mainapilink/user_profile_api.php?id=$user_id"));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body)["EBOOK_APP"];
      setState(() {
        user_name = jsonResponse[0]["name"];
        _email = jsonResponse[0]["email"];
      });
      nameController = TextEditingController(text: "${user_name}");
      if (jsonResponse.toString().contains('successflly')) {
        pref.setString("name", nameController.text);
        pref.setString('photo', jsonResponse[0]["user_image"]);
      }
    } else {}
    setState(() {
      spin = false;
    });
  }

  void takePhoto(ImageSource source, context) async {
    path = await ImagePicker.pickImage(
      imageQuality: 50,
      maxHeight: 1080,
      maxWidth: 1080,
      source: source,
    ).then((value) async {
      setState(() {
        if (value != null) {
          imageF = value;

          // profileImage(context, imageF);
        } else {}
      });
    });
  }

  void savename() async {
    try {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();
      setState(() {
        spin = true;
      });
      final String url = "$mainapilink/user_profile_update_api.php";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // fixedFile.absolute != null
      //     ? request.files.add(await http.MultipartFile.fromPath(
      //     'user_image', fixedFile.absolute.path))
      //     : null;
      request.fields['method_name'] = "user_profile_update";
      request.fields['user_id'] = "$user_id";
      request.fields['name'] = "${nameController.text}";
      request.fields['email'] = "${_email != null ? _email : _email}";

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var i = convert.jsonDecode(response.body);
        ('user id ${response.body}');
        if (i['EBOOK_APP'][0]['success'].toString().contains('1')) {
          //  Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profile Updated Successfully',
                style: TextStyle(color: Colors.green),
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed Profile Updated',
                style: TextStyle(color: Colors.green),
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed Profile Updated',
            style: TextStyle(color: Colors.green),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      ('ERROR IN PROFILE $e');
    } finally {
      setState(() {
        spin = true;
      });
    }
    setState(() {
      spin = true;
    });
  }

  void saveProfile() async {
    // try {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      spin = true;
    });

    final originalFile = File(imageF.absolute.path);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final height = originalImage.height;
    final width = originalImage.width;

    // Let's check for the image size
    // This will be true also for upside-down photos but it's ok for me

    // We'll use the exif package to read exif data
    // This is map of several exif properties
    // Let's check 'Image Orientation'

    final exifData = await readExifFromBytes(imageBytes);

    img.Image fixedImage;
    if (height < width) {
      // rotate
      if (exifData['Image Orientation'].printable.contains('Horizontal')) {
        fixedImage = img.copyRotate(originalImage, 90);
      } else if (exifData['Image Orientation'].printable.contains('180')) {
        fixedImage = img.copyRotate(originalImage, -90);
      } else if (exifData['Image Orientation'].printable.contains('CCW')) {
        fixedImage = img.copyRotate(originalImage, 180);
      } else if (exifData['Image Orientation'].printable.contains('90 CW')) {
        fixedImage = img.copyRotate(originalImage, 90);
      } else {
        fixedImage = img.copyRotate(originalImage, 0);
      }
    }
    // Here you can select whether you'd like to save it as png
    // or jpg with some compression
    // I choose jpg with 100% quality
    File fixedFile;

    if (fixedImage == null) {
      fixedFile = File(imageF.absolute.path);
    } else {
      fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    try {
      final String url = "$mainapilink/user_profile_update_api.php";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      fixedFile.absolute != null
          ? request.files.add(await http.MultipartFile.fromPath(
              'user_image', fixedFile.absolute.path))
          : null;
      request.fields['method_name'] = "user_profile_update";
      request.fields['user_id'] = "$user_id";
      request.fields['name'] = "${nameController.text}";
      request.fields['email'] = "${_email != null ? _email : _email}";

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var i = convert.jsonDecode(response.body);

        if (i['EBOOK_APP'][0]['success'].toString().contains('1')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profile Updated Successfully',
                style: TextStyle(color: Colors.green),
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed Profile Updated',
                style: TextStyle(color: Colors.green),
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed Profile Updated',
            style: TextStyle(color: Colors.green),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() {
      spin = false;
    });
    // } catch (e) {
    //   ("Exception$e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Progress(
          spin: spin,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: themeProvider.isLightTheme
                ? Color(0xFFFFFFFF)
                : Color(0xFF26242e),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  TitleBar(
                      ontap: () {
                        Navigator.of(context).pop();
                      },
                      image: 'assets/images/1.svg',
                      appbartitle: "Profile"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeProvider.isLightTheme
                            ? Colors.black54
                            : Colors.white54,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            S.of(context).profile_USER_PROFILE,
                            style: TextStyle(
                                color: themeProvider.isLightTheme
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 22,
                                fontFamily: 'Helvetica Neue'
                                // color: themeProvider.isLightTheme
                                //     ? Colors.white
                                //     : Colors.white54,
                                ),
                          ),
                        ),
                        Divider(
                          endIndent: 50,
                          indent: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: SvgPicture.asset(
                                  'assets/images/profile.svg',
                                  color: themeProvider.isLightTheme
                                      ? Colors.black54
                                      : Colors.white54,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  user_name == null
                                      ? "Loading .."
                                      : "  $user_name",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: themeProvider.isLightTheme
                                        ? Colors.black54
                                        : Colors.white54,
                                    fontFamily: 'Helvetica Neue',
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: SvgPicture.asset(
                                    'assets/images/at.svg',
                                    color: themeProvider.isLightTheme
                                        ? Colors.black54
                                        : Colors.white54,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Text(
                                  // widget.email == null ?
                                  "  $_email",
                                  // : widget.email,
                                  maxLines: 3,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: themeProvider.isLightTheme
                                        ? Colors.black54
                                        : Colors.white54,
                                    fontSize: 18, fontFamily: 'Helvetica Neue',
                                    //   color: themeProvider.isLightTheme
                                    //       ? Colors.white
                                    //       : Colors.white54,
                                    // ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        widget.phonenumber == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      S.of(context).profile_MOBILE,
                                      style: TextStyle(
                                        color: themeProvider.isLightTheme
                                            ? Colors.white
                                            : Colors.white54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.phonenumber,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: themeProvider.isLightTheme
                                            ? Colors.white
                                            : Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  type == "GOOGLE"
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                S.of(context).profile_UPDATE_YOUR_NAME,
                                style: TextStyle(
                                  color: themeProvider.isLightTheme
                                      ? Colors.black54
                                      : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                  type == "GOOGLE"
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: _form,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty)
                                  return S
                                      .of(context)
                                      .details_screen_comments_textField_validation;
                                else
                                  return null;
                              },
                              controller: nameController,
                              autofocus: false,
                              decoration: new InputDecoration(
                                hintText: S.of(context).loginPage_nameHint,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                hintStyle: TextStyle(
                                  color: themeProvider.isLightTheme
                                      ? Colors.black54
                                      : Colors.white54,
                                  fontFamily: "Nunito",
                                ),
                                border: OutlineInputBorder(
                                  gapPadding: 5,
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: themeProvider.isLightTheme
                                          ? Colors.black54
                                          : Colors.white54,
                                      width: 3),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: themeProvider.isLightTheme
                                          ? Colors.black54
                                          : Colors.white54,
                                      width: 3),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: themeProvider.isLightTheme
                                    ? Colors.black54
                                    : Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                  type == "GOOGLE"
                      ? Container()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider.isLightTheme
                                  ? Colors.black54
                                  : Colors.white54,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    S
                                        .of(context)
                                        .profile_UPDATE_PROFILE_PICTURE,
                                    style: TextStyle(
                                      color: themeProvider.isLightTheme
                                          ? Colors.black54
                                          : Colors.white54,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Divider(
                                  endIndent: 50,
                                  indent: 50,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            25), // <-- Radius
                                      ),
                                      color: buttonColorAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              "assets/images/camera.svg",
                                              color: Colors.white,
                                              height: 20,
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              S.of(context).profile_CAMERA,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        takePhoto(ImageSource.camera, context);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            25), // <-- Radius
                                      ),
                                      color: buttonColorAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/gallery.svg",
                                              height: 20,
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              S.of(context).profile_GALLERY,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        takePhoto(ImageSource.gallery, context);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                  type == "GOOGLE"
                      ? Container()
                      : RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(50), // <-- Radius
                          ),
                          color: buttonColorAccent,
                          child: Text(
                            "Save",
                            // S.of(context).profile_SAVE,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            imageF != null ? saveProfile() : savename();
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Innertxt extends StatelessWidget {
  const Innertxt({Key key, @required this.name, @required this.header})
      : super(key: key);

  final String header;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$header ',
          style: TextStyle(
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'Nunito',
              color: Theme.of(context).buttonColor),
        ),
        SizedBox(
          width: 50,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: Colors.white,
          elevation: 30,
          child: Container(
            height: 45,
            width: 250,
            child: Center(
              child: Text(
                name != null ? name : '',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'Nunito',
                    color: Theme.of(context).buttonColor),
              ),
            ),
          ),
        )
      ],
    );
  }
}
