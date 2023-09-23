import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:stock_price_checker_app/screens/tasks_screen.dart';
import 'package:provider/provider.dart';
import 'package:stock_price_checker_app/models/task_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/task.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  await showNotification('hi', 'how are you?', true);
  fetchData();
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        break;
    }
    print("called");
    // showNotification('hi', 'how are you?');
    bool success = true;
    // await showNotification('hi', 'how are you?');
    await fetchData();
    return Future.value(success);
  });
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
  // await Navigator.push(
  //   context as BuildContext,
  //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  // );
}
// Handle when a notification is tapped while the app is in the foreground.

Future<void> initNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentSound: false,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {});

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(
    String notificationTitle, String notificationBody, bool isDump) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics;

  if (isDump) {
    print('dump');
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notification.id', // Replace with a unique channel ID
      'general', // Replace with a descriptive channel name
      channelDescription: 'description',
      //'Your channel description', // Replace with a descriptive channel description
      priority: Priority.max,
      enableVibration: true,
      icon: 'ic_launcher',
      importance: Importance.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('dumpit'),
      playSound: true,
    );
  } else {
    print('pump');
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notification.id2', // Replace with a unique channel ID
      'general2', // Replace with a descriptive channel name
      channelDescription: 'description2',
      //'Your channel description', // Replace with a descriptive channel description
      priority: Priority.max,
      enableVibration: true,
      icon: 'ic_launcher',
      importance: Importance.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('pumpit'),
      playSound: true,
    );
  }

  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (you can use different IDs for different notifications)
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
      payload: isDump ? 'dumpit' : 'pumpit');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    // Code for iOS
    print("Running on iOS");
    await initNotifications();
    // Step 1:  Configure BackgroundFetch as usual.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate:
              false, // Continue running background tasks even if the app is terminated
          enableHeadless: true, // Enable headless mode
          startOnBoot: true, // Start background fetch on device boot
        ), (String taskId) async {
      // <-- Event callback.
      // This is the fetch-event callback.
      print("[BackgroundFetch] taskId: $taskId");

      // Use a switch statement to route task-handling.
      switch (taskId) {
        case 'com.yumiya.mytask':
          print("Received custom task");
          showNotification('hi', 'how are you?', false);
          break;
        default:
          print("Default fetch task");
      }
      // Finish, providing received taskId.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Event timeout callback
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });

    // Step 2:  Schedule a custom "oneshot" task "com.transistorsoft.customtask" to execute 5000ms from now.
    BackgroundFetch.scheduleTask(
        TaskConfig(taskId: "com.yumiya.mytask", delay: 5000 // <-- milliseconds
            ));
  } else if (Platform.isAndroid) {
    await Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerPeriodicTask(
      "com.yumiya.mytask",
      "this part to be ignored in ios",
      frequency: Duration(minutes: 15),
    );
    // Code for Android
    print("Running on Android");
  } else {
    // Code for other platforms (unlikely in Flutter)
    print("Running on another platform");
  }

  //make sure you turned on wifi connection
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    showNotification('hi', 'how are you?', false);
    fetchData();
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> fetchData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? taskStrings = prefs.getStringList('tasks');

  if (taskStrings != null) {
    List<Map<String, dynamic>> jsonData = taskStrings
        .map((taskString) => json.decode(taskString))
        .cast<Map<String, dynamic>>()
        .toList();
    List names = jsonData.map((item) => item["name"]).toList();
    List lowerLimits = jsonData.map((item) => item["lowerLimit"]).toList();
    List higherLimits = jsonData.map((item) => item["higherLimit"]).toList();
    List<int> dumped = [];
    List<int> pumped = [];
    String dumpedStr = "";
    String pumpedStr = "";

    print(names);
    for (var i = 0; i < names.length; i++) {
      final response =
          await http.get(Uri.parse("${dotenv.env['API_URL']}${names[i]}"));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON data
        final jsonData = json.decode(response.body);
        // You can now work with jsonData, which contains the response data
        print(jsonData['current_value']);
        try {
          double currentValue = double.parse(jsonData['current_value']);
          double floatLowerLimit = double.parse(lowerLimits[i]);
          double floatHigherLimit = double.parse(higherLimits[i]);
          if (currentValue >= floatHigherLimit) {
            pumped.add(i);
            pumpedStr += names[i];
            pumpedStr += ' ';
          }
          if (currentValue <= floatLowerLimit) {
            dumped.add(i);
            dumpedStr += names[i];
            dumpedStr += ' ';
          }
          // print(floatValue);
        } catch (e) {
          // Handle parsing errors, such as non-numeric input
          print("Error parsing the string: $e");
        }
        // showNotification('news', jsonData['current_value'], true);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception or handle the error as needed
        throw Exception('Failed to load data');
      }
      await Future.delayed(Duration(seconds: 10));
    }

    if (dumpedStr.isNotEmpty) {
      await showNotification('Dumped stocks:', dumpedStr, true);
    }

    if (pumpedStr.isNotEmpty) {
      await showNotification('pumped stocks:', pumpedStr, false);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}
