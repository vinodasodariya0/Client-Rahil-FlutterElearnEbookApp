import 'package:elearn/screens/home.dart';
import 'package:elearn/splashScreen.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consttants.dart';
import 'generated/l10n.dart';
import 'model/detailsProvider.dart';

const String feature1 = 'feature1', feature2 = 'feature2';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString('email');
  print("email====$email");
  int count = pref.getInt('languageCount');
  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  ///one signal notification

  final String oneSignalAppId = "8e2b9c1a-2e1f-4973-999b-0e5db221e537";
  OneSignal.shared.setAppId(oneSignalAppId);
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {});

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {});

  OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges emailChanges) {});

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(isLightTheme: isLightTheme),
        child: AppStart(
          languageCount: count,
          email: email,
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => DetailsProvider(),
        child: Home(),
      ),
    ],
    child: AppStart(
      languageCount: count,
      email: email,
    ),
  ));
}

class AppStart extends StatelessWidget {
  AppStart({Key key, this.email, this.languageCount}) : super(key: key);
  final String email;
  int languageCount;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MyApp(
      themeProvider: themeProvider,
      email: email,
      languageCount: languageCount,
    );
  }
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  // This widget is the root of your application.
  final ThemeProvider themeProvider;

  const MyApp(
      {Key key, @required this.themeProvider, this.email, this.languageCount})
      : super(key: key);
  final String email;
  final int languageCount;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        isLoading = true;
      });

      setState(() {
        S.load(Locale(
            languageMap[widget.languageCount != null ? widget.languageCount : 0]
                ['set1'],
            languageMap[widget.languageCount != null ? widget.languageCount : 0]
                ['set2']));
      });
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.languageCount =
        widget.languageCount != null ? widget.languageCount : 0;
    precacheImage(new AssetImage('assets/images/b.png'), context);
    precacheImage(new AssetImage('assets/images/darkback.png'), context);

    // return Sizer(builder: (context, orientation, deviceType) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Light Dark Theme',
      theme: widget.themeProvider.themeData(),
      home: Splash_Screen(email: widget.email),

      //   widget.email != null ? HomeScreen() : Login(),
      localizationsDelegates: [
        // 1
        S.delegate,
        // 2
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: S.delegate.supportedLocales,
    );

    //}
  }
}
