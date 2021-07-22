import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rhythmcare/screens/change_function_screen.dart';
import 'package:rhythmcare/screens/change_password_screen.dart';
import 'package:rhythmcare/screens/change_email_screen.dart';
import 'package:rhythmcare/screens/email_verify_screen.dart';
import 'package:rhythmcare/screens/loading_screen.dart';
import 'package:rhythmcare/screens/reset_password_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rhythmcare/screens/reminder_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'navigation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? selectedNotificationPayload;

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // if (payload == 'once') {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   List<String>? list = prefs.getStringList('reminder1');
    //   flutterLocalNotificationsPlugin.cancel(0);
    //   prefs.setStringList('reminder1', [list![0], list[1], list[2], 'inactive']);
    // }
    selectedNotificationPayload = payload;
    // selectNotificationSubject.add(payload);
    if (FirebaseAuth.instance.currentUser == null) {
      await MyApp.navigatorKey.currentState!
          .pushNamedAndRemoveUntil(LoadingScreen.routeName, (route) => false);
    } else {
      await MyApp.navigatorKey.currentState!
          .pushNamedAndRemoveUntil(Navigation.p0RouteName, (route) => false);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // void _configureSelectNotificationSubject() {
    //   selectNotificationSubject.stream.listen((String? payload) async {
    //     await Navigator.pushNamed(context, Navigation.p0RouteName);
    //   });
    // }
    //
    // _configureSelectNotificationSubject();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'RhythmCare',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.purple,
          scaffoldBackgroundColor: Colors.purple,
        ),
        navigatorKey: navigatorKey,
        home: LoadingScreen(), // check user has logged in or not
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          Navigation.p0RouteName: (context) => Navigation(0),
          Navigation.p1RouteName: (context) => Navigation(1),
          Navigation.p2RouteName: (context) => Navigation(2),
          EmailVerifyScreen.routeName: (context) => EmailVerifyScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
          ChangeEmailScreen.routeName: (context) => ChangeEmailScreen(),
          ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
          ChangeFunctionScreen.routeName: (context) => ChangeFunctionScreen(),
          LoadingScreen.routeName: (context) => LoadingScreen(),
          ReminderScreen.routeName: (context) => ReminderScreen(),
          // SetReminderScreen.routeName: (context) => SetReminderScreen(),
          // HomeScreen.routeName: (context) => HomeScreen(),
          // RecordScreen.routeName: (context) => RecordScreen(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
