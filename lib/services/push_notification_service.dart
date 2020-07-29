import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:storeRahisi/locator.dart';
import 'package:storeRahisi/models/user.dart';
import 'package:storeRahisi/services/auth_service.dart';
import 'package:storeRahisi/services/dialog_service.dart';
import 'package:storeRahisi/services/shared_pref_util.dart';

class PushNotificationService {
  final DialogService _dialogService = locator<DialogService>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final AuthService _authService = locator<AuthService>();

  final SharedPrefsUtil _sharedPrefsUtil = locator<SharedPrefsUtil>();
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    if (Platform.isAndroid) {
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("***********************onMessage: $message");
          await _dialogService.showDialog(
            title: message['notification']['title'],
            description: message['notification']['body'],
          );
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("********************onLaunch: $message");
          _serialiseAndNavigate(message);
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
          print("************************onResume: $message");
          _serialiseAndNavigate(message);
        },
      );
      await _authService.saveDeviceToken();
    }
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    print('*******************$message');

    if (notificationData['view'] != null) {
      // Navigate to the create post view
      if (notificationData['view'] == 'comment') {
        // _navigationService
        //     .navigateTo(routeName: AppRoutes.comments, arguments: {
        //   'incidentId': notificationData['incidentId'],
        //   'currentUserId': notificationData['userId']
        // });
      }
      // If there's no view it'll just open the app on the first view
    }
  }

  void fcmSubscribe() {
    if (_authService.currentUser != null) {
      _fcm.subscribeToTopic(
          'notifications_' + _authService.currentUser?.companyId);
    }
  }

  void fcmUnSubscribe() {
    if (_authService.currentUser != null) {
      _fcm.unsubscribeFromTopic(
          'notifications_' + _authService.currentUser?.companyId);
    }
  }
}
