// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome`
  String get loginPage_WELCOME {
    return Intl.message(
      'Welcome',
      name: 'loginPage_WELCOME',
      desc: '',
      args: [],
    );
  }

  /// `Enter Email`
  String get loginPage_emailHint {
    return Intl.message(
      'Enter Email',
      name: 'loginPage_emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get loginPage_passwordHint {
    return Intl.message(
      'Enter Password',
      name: 'loginPage_passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Trouble in login? `
  String get loginPage_TROUBLE_IN_LOGIN {
    return Intl.message(
      'Trouble in login? ',
      name: 'loginPage_TROUBLE_IN_LOGIN',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email`
  String get loginPage_forgot_ENTER_YOUR_EMAIL {
    return Intl.message(
      'Enter Your Email',
      name: 'loginPage_forgot_ENTER_YOUR_EMAIL',
      desc: '',
      args: [],
    );
  }

  /// `SignUp`
  String get loginPage_forgot_APPLY_button {
    return Intl.message(
      'SignUp',
      name: 'loginPage_forgot_APPLY_button',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get loginPage_FORGOT_PASSWORD {
    return Intl.message(
      'Forgot Password',
      name: 'loginPage_FORGOT_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginPage_LOGIN {
    return Intl.message(
      'Login',
      name: 'loginPage_LOGIN',
      desc: '',
      args: [],
    );
  }

  /// `SignUp`
  String get loginPage_SIGNUP {
    return Intl.message(
      'SignUp',
      name: 'loginPage_SIGNUP',
      desc: '',
      args: [],
    );
  }

  /// `Logged In Successfully`
  String get loginPage_LOGIN_SUCCESS_toast {
    return Intl.message(
      'Logged In Successfully',
      name: 'loginPage_LOGIN_SUCCESS_toast',
      desc: '',
      args: [],
    );
  }

  /// `Register with `
  String get loginPage_REGISTER_WITH {
    return Intl.message(
      'Register with ',
      name: 'loginPage_REGISTER_WITH',
      desc: '',
      args: [],
    );
  }

  /// `Social Media`
  String get loginPage_SOCIAL_MEDIA {
    return Intl.message(
      'Social Media',
      name: 'loginPage_SOCIAL_MEDIA',
      desc: '',
      args: [],
    );
  }

  /// `Problem in Signin`
  String get loginPage_PROBLEM_IN_SIGNIN_toast {
    return Intl.message(
      'Problem in Signin',
      name: 'loginPage_PROBLEM_IN_SIGNIN_toast',
      desc: '',
      args: [],
    );
  }

  /// `Want to skip for now..`
  String get loginPage_skip_login {
    return Intl.message(
      'Want to skip for now..',
      name: 'loginPage_skip_login',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get loginPage_nameHint {
    return Intl.message(
      'Enter Name',
      name: 'loginPage_nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phonenumber`
  String get loginPage_phoneHint {
    return Intl.message(
      'Enter Phonenumber',
      name: 'loginPage_phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `SKIP`
  String get loginPage_SKIP {
    return Intl.message(
      'SKIP',
      name: 'loginPage_SKIP',
      desc: '',
      args: [],
    );
  }

  /// `Greetings...`
  String get home_GREETINGS {
    return Intl.message(
      'Greetings...',
      name: 'home_GREETINGS',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get home_USER {
    return Intl.message(
      'User',
      name: 'home_USER',
      desc: '',
      args: [],
    );
  }

  /// `Search best books here...`
  String get home_search_bar {
    return Intl.message(
      'Search best books here...',
      name: 'home_search_bar',
      desc: '',
      args: [],
    );
  }

  /// `Select `
  String get home_SELECT {
    return Intl.message(
      'Select ',
      name: 'home_SELECT',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get home_CATEGORY {
    return Intl.message(
      'Category',
      name: 'home_CATEGORY',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get home_category_BOOK {
    return Intl.message(
      'Book',
      name: 'home_category_BOOK',
      desc: '',
      args: [],
    );
  }

  /// `Error check your Internet!!!`
  String get home_category_internet_error {
    return Intl.message(
      'Error check your Internet!!!',
      name: 'home_category_internet_error',
      desc: '',
      args: [],
    );
  }

  /// `What are you \nreading `
  String get home_WHAT_ARE_YOU_READING {
    return Intl.message(
      'What are you \nreading ',
      name: 'home_WHAT_ARE_YOU_READING',
      desc: '',
      args: [],
    );
  }

  /// `today?`
  String get home_TODAY {
    return Intl.message(
      'today?',
      name: 'home_TODAY',
      desc: '',
      args: [],
    );
  }

  /// `Best of the `
  String get home_BEST_OF_THE {
    return Intl.message(
      'Best of the ',
      name: 'home_BEST_OF_THE',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get home_DAY {
    return Intl.message(
      'day',
      name: 'home_DAY',
      desc: '',
      args: [],
    );
  }

  /// `Continue `
  String get home_CONTINUE {
    return Intl.message(
      'Continue ',
      name: 'home_CONTINUE',
      desc: '',
      args: [],
    );
  }

  /// `reading...`
  String get home_READING {
    return Intl.message(
      'reading...',
      name: 'home_READING',
      desc: '',
      args: [],
    );
  }

  /// `no Book has been selected`
  String get home_continue_NO_BOOK_toast {
    return Intl.message(
      'no Book has been selected',
      name: 'home_continue_NO_BOOK_toast',
      desc: '',
      args: [],
    );
  }

  /// `Crushing & Influence`
  String get home_continue_CRUSHING_INFLUENCE {
    return Intl.message(
      'Crushing & Influence',
      name: 'home_continue_CRUSHING_INFLUENCE',
      desc: '',
      args: [],
    );
  }

  /// `Explore...`
  String get explore_EXPLORE {
    return Intl.message(
      'Explore...',
      name: 'explore_EXPLORE',
      desc: '',
      args: [],
    );
  }

  /// `Latest`
  String get explore_LATEST {
    return Intl.message(
      'Latest',
      name: 'explore_LATEST',
      desc: '',
      args: [],
    );
  }

  /// `books...`
  String get explore_BOOKS {
    return Intl.message(
      'books...',
      name: 'explore_BOOKS',
      desc: '',
      args: [],
    );
  }

  /// `Searched by`
  String get explore_SEARCHED_BY {
    return Intl.message(
      'Searched by',
      name: 'explore_SEARCHED_BY',
      desc: '',
      args: [],
    );
  }

  /// `Authors`
  String get explore_AUTHOR {
    return Intl.message(
      'Authors',
      name: 'explore_AUTHOR',
      desc: '',
      args: [],
    );
  }

  /// `All Available`
  String get explore_ALL_AVAILABLE {
    return Intl.message(
      'All Available',
      name: 'explore_ALL_AVAILABLE',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get explore_BOOKS_available {
    return Intl.message(
      'Books',
      name: 'explore_BOOKS_available',
      desc: '',
      args: [],
    );
  }

  /// `Setting...`
  String get setting_SETTING {
    return Intl.message(
      'Setting...',
      name: 'setting_SETTING',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get setting_PROFILE {
    return Intl.message(
      'Profile',
      name: 'setting_PROFILE',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get setting_NORTIFICATION {
    return Intl.message(
      'Notification',
      name: 'setting_NORTIFICATION',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get setting_DOWNLOAD {
    return Intl.message(
      'Download',
      name: 'setting_DOWNLOAD',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get setting_SHARE {
    return Intl.message(
      'Share',
      name: 'setting_SHARE',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get setting_PRIVACY_POLICY {
    return Intl.message(
      'Privacy Policy',
      name: 'setting_PRIVACY_POLICY',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get setting_LOGOUT {
    return Intl.message(
      'Logout',
      name: 'setting_LOGOUT',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get setting_LANGUAGE {
    return Intl.message(
      'Language',
      name: 'setting_LANGUAGE',
      desc: '',
      args: [],
    );
  }

  /// `Example Share`
  String get setting_share_SHARE {
    return Intl.message(
      'Example Share',
      name: 'setting_share_SHARE',
      desc: '',
      args: [],
    );
  }

  /// `Example Share Text`
  String get setting_share_SHARE_TEXT {
    return Intl.message(
      'Example Share Text',
      name: 'setting_share_SHARE_TEXT',
      desc: '',
      args: [],
    );
  }

  /// `Example Chooser Title`
  String get setting_share_TITLE {
    return Intl.message(
      'Example Chooser Title',
      name: 'setting_share_TITLE',
      desc: '',
      args: [],
    );
  }

  /// `This is Ignored`
  String get setting_privacy_IGNORED {
    return Intl.message(
      'This is Ignored',
      name: 'setting_privacy_IGNORED',
      desc: '',
      args: [],
    );
  }

  /// `This is also Ignored`
  String get setting_privacy_ALSO_IGNORED {
    return Intl.message(
      'This is also Ignored',
      name: 'setting_privacy_ALSO_IGNORED',
      desc: '',
      args: [],
    );
  }

  /// `Are you Sure ?`
  String get setting_logout_ARE_YOU_SURE {
    return Intl.message(
      'Are you Sure ?',
      name: 'setting_logout_ARE_YOU_SURE',
      desc: '',
      args: [],
    );
  }

  /// `Logout with Ebook`
  String get setting_logout_LOGOUT_WITH_EBOOK {
    return Intl.message(
      'Logout with Ebook',
      name: 'setting_logout_LOGOUT_WITH_EBOOK',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get setting_logout_CANCEL {
    return Intl.message(
      'Cancel',
      name: 'setting_logout_CANCEL',
      desc: '',
      args: [],
    );
  }

  /// `Failed to Logout`
  String get setting_logout_FAILED_TO_LOGOUT_toast {
    return Intl.message(
      'Failed to Logout',
      name: 'setting_logout_FAILED_TO_LOGOUT_toast',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category_CATEGORY {
    return Intl.message(
      'Category',
      name: 'category_CATEGORY',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get detail_screen_DESCRIPTION {
    return Intl.message(
      'Description',
      name: 'detail_screen_DESCRIPTION',
      desc: '',
      args: [],
    );
  }

  /// `You might also `
  String get detail_screen_YOU_MIGHT_ALSO {
    return Intl.message(
      'You might also ',
      name: 'detail_screen_YOU_MIGHT_ALSO',
      desc: '',
      args: [],
    );
  }

  /// `like….`
  String get detail_screen_LIKE {
    return Intl.message(
      'like….',
      name: 'detail_screen_LIKE',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get detail_screen_READ {
    return Intl.message(
      'Read',
      name: 'detail_screen_READ',
      desc: '',
      args: [],
    );
  }

  /// `book Add in Favourite`
  String get detail_screen_ADD_FAVOURITE {
    return Intl.message(
      'book Add in Favourite',
      name: 'detail_screen_ADD_FAVOURITE',
      desc: '',
      args: [],
    );
  }

  /// `No books Found...`
  String get search_NO_BOOKS_FOUND {
    return Intl.message(
      'No books Found...',
      name: 'search_NO_BOOKS_FOUND',
      desc: '',
      args: [],
    );
  }

  /// `start downloading....`
  String get view_START_DOWNLOADING_toast {
    return Intl.message(
      'start downloading....',
      name: 'view_START_DOWNLOADING_toast',
      desc: '',
      args: [],
    );
  }

  /// `user permission denied`
  String get view_PERMISSION_DENIED_toast {
    return Intl.message(
      'user permission denied',
      name: 'view_PERMISSION_DENIED_toast',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get view_LOADING {
    return Intl.message(
      'Loading',
      name: 'view_LOADING',
      desc: '',
      args: [],
    );
  }

  /// `New York Time Best For 11th March 2020`
  String get beswtofday_TIME {
    return Intl.message(
      'New York Time Best For 11th March 2020',
      name: 'beswtofday_TIME',
      desc: '',
      args: [],
    );
  }

  /// `How To Win \nFriends &  Influence`
  String get beswtofday_HOW_TO_WIN {
    return Intl.message(
      'How To Win \nFriends &  Influence',
      name: 'beswtofday_HOW_TO_WIN',
      desc: '',
      args: [],
    );
  }

  /// `Gary Venchuk`
  String get beswtofday_GARY_VENCHUK {
    return Intl.message(
      'Gary Venchuk',
      name: 'beswtofday_GARY_VENCHUK',
      desc: '',
      args: [],
    );
  }

  /// `When the earth was flat and everyone wanted to win the game of the best and people….`
  String get beswtofday_WHEN_EARTH_WAS_FLAT {
    return Intl.message(
      'When the earth was flat and everyone wanted to win the game of the best and people….',
      name: 'beswtofday_WHEN_EARTH_WAS_FLAT',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get reading_card_list_DETAILS {
    return Intl.message(
      'Details',
      name: 'reading_card_list_DETAILS',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get details_screen_COMMENTS {
    return Intl.message(
      'Comments',
      name: 'details_screen_COMMENTS',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Value`
  String get details_screen_comments_textField_validation {
    return Intl.message(
      'Please Enter Value',
      name: 'details_screen_comments_textField_validation',
      desc: '',
      args: [],
    );
  }

  /// `Add a public comment`
  String get details_screen_comments_textField_hint_text {
    return Intl.message(
      'Add a public comment',
      name: 'details_screen_comments_textField_hint_text',
      desc: '',
      args: [],
    );
  }

  /// `No Comments Found`
  String get details_screen_comments_NO_COMMENTS_FOUND {
    return Intl.message(
      'No Comments Found',
      name: 'details_screen_comments_NO_COMMENTS_FOUND',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get read_more_text_SHOW_MORE {
    return Intl.message(
      'Show more',
      name: 'read_more_text_SHOW_MORE',
      desc: '',
      args: [],
    );
  }

  /// `Show less`
  String get read_more_text_SHOW_LESS {
    return Intl.message(
      'Show less',
      name: 'read_more_text_SHOW_LESS',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Book`
  String get detail_screen_PURCHASE_BOOK {
    return Intl.message(
      'Purchase Book',
      name: 'detail_screen_PURCHASE_BOOK',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get profile_USER_PROFILE {
    return Intl.message(
      'User Profile',
      name: 'profile_USER_PROFILE',
      desc: '',
      args: [],
    );
  }

  /// `Name :`
  String get profile_NAME {
    return Intl.message(
      'Name :',
      name: 'profile_NAME',
      desc: '',
      args: [],
    );
  }

  /// `Email :`
  String get profile_EMAIL {
    return Intl.message(
      'Email :',
      name: 'profile_EMAIL',
      desc: '',
      args: [],
    );
  }

  /// `Mobile :`
  String get profile_MOBILE {
    return Intl.message(
      'Mobile :',
      name: 'profile_MOBILE',
      desc: '',
      args: [],
    );
  }

  /// `Update Your Name`
  String get profile_UPDATE_YOUR_NAME {
    return Intl.message(
      'Update Your Name',
      name: 'profile_UPDATE_YOUR_NAME',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile Picture`
  String get profile_UPDATE_PROFILE_PICTURE {
    return Intl.message(
      'Update Profile Picture',
      name: 'profile_UPDATE_PROFILE_PICTURE',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get profile_CAMERA {
    return Intl.message(
      'Camera',
      name: 'profile_CAMERA',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get profile_GALLERY {
    return Intl.message(
      'Gallery',
      name: 'profile_GALLERY',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get profile_SAVE {
    return Intl.message(
      'Save',
      name: 'profile_SAVE',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully rated`
  String get detail_screen_YOU_HAVE_SUCCESSFULLY_RATED {
    return Intl.message(
      'You have successfully rated',
      name: 'detail_screen_YOU_HAVE_SUCCESSFULLY_RATED',
      desc: '',
      args: [],
    );
  }

  /// `You have already rated`
  String get detail_screen_YOU_HAVE_ALREADY_RATED {
    return Intl.message(
      'You have already rated',
      name: 'detail_screen_YOU_HAVE_ALREADY_RATED',
      desc: '',
      args: [],
    );
  }

  /// `Login First`
  String get detail_screen_LOGIN_FIRST {
    return Intl.message(
      'Login First',
      name: 'detail_screen_LOGIN_FIRST',
      desc: '',
      args: [],
    );
  }

  /// `Rate a book`
  String get detail_screen_RATE_A_BOOK {
    return Intl.message(
      'Rate a book',
      name: 'detail_screen_RATE_A_BOOK',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get detail_screen_SUBMIT {
    return Intl.message(
      'Submit',
      name: 'detail_screen_SUBMIT',
      desc: '',
      args: [],
    );
  }

  /// `Favourite`
  String get setting_screen_FAVOURITE {
    return Intl.message(
      'Favourite',
      name: 'setting_screen_FAVOURITE',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}