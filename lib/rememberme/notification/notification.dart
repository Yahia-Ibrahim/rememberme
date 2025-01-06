import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rememberme/rememberme/models/book.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import '../models/Word.dart';
import '../providers/books_provider.dart';

class NotificationService {
  static ProviderContainer _container = ProviderContainer();
  static String _title = '';
  static String _body = '';
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
  // This is the task that WorkManager will execute in the background.
  static void callbackDispatcher() {
    // Re-initialize the FlutterLocalNotificationsPlugin for background execution
    Workmanager().executeTask((task, inputData) async {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      // Initialize notifications when the task is triggered
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'daily_notification_channel',
        'Daily Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      ProviderContainer container = ProviderContainer();
      // Get the list of books from the provider
      final books = container.read(booksNotifier);
      late final Book randomBook;
      String body = '';
      if (books.isNotEmpty) {
        // Select a random book
        randomBook = (books..shuffle()).first; // Shuffle the list and take the first one
        if(randomBook.wordList.isEmpty) {
          body = 'Arn\'t you encountering any hard words? 🤨';
        }
        else {
          List<Word> words = randomBook.wordList;
          words.shuffle();
          body = 'do you know the meaning of ${words.first}';
        }
      }
      await flutterLocalNotificationsPlugin.show(
        0,
        (books.isEmpty) ? 'Reading any thing interesting' : randomBook.title,
        body,
        platformChannelSpecifics,
      );
      print("WorkManager Task Executed: $task");
      return Future.value(true);
    });
  }

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {

  }
  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iOSInitializationSettings
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();

  }
  static Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails("channel_Id", "channel_Name"),
      iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body, tz.TZDateTime.from(scheduledDate, tz.local), platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime
    );
  }

  static Future<void> scheduleDailyNotification(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    log('now sending notification');
    await flutterLocalNotificationsPlugin.cancel(0);
    // If the scheduled time is earlier than now, schedule for the next day
    // if (scheduledTime.isBefore(now)) {
    //   scheduledTime = scheduledTime.add(const Duration(days: 1));
    // }
    // final now = tz.TZDateTime.now(tz.local);
    // final scheduledTime = now.add(const Duration(minutes: 1)); // Schedule for next minute (for testing)
    // Cancel any previously scheduled notification


    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // notification ID
      (_chooseBook()) ? _title : _title,
      _body,
      scheduledTime,
      // scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Triggers daily
    );
  }

  static bool _chooseBook() {
    if(_container.read(booksNotifier).isEmpty) {
      _title = 'Reading any thing interesting?';
      return false;
    }
    List books = _container.read(booksNotifier);
    Book randomBook = (books..shuffle()).first;
    _title = randomBook.title;
    log("entered choose Book and title is $_title");
    if(randomBook.wordList.isEmpty) {
      _body = 'Aren\'t you encountering any hard words? 🤨';
    }
    else {
      List<Word> words = randomBook.wordList;
      words.shuffle();
      _body = 'do you know the meaning of "${words.first.text}"';
    }
    return true;
  }

  static Future<void> scheduleRandomBookNotification(int hour, int minute) async {

    // Get the list of books from the provider
    // final books = _container.read(booksNotifier);

    // if (books.isNotEmpty) {
      // Select a random book
      // final randomBook = (books..shuffle()).first; // Shuffle the list and take the first one

    await scheduleDailyNotification(hour, minute); // Assuming your Book model has a title
    // }
  }
  
  static void scheduleMinNotificationTask(int hour, int minute) {
    final now = DateTime.now();
    final durationUntilNextTrigger = Duration(
      hours: hour - now.hour,
      minutes: minute - now.minute,
    );

    Workmanager().registerPeriodicTask(
      'daily-notification-task', // unique task name
      'daily-notification-task',
      initialDelay: const Duration(seconds: 15) /*durationUntilNextTrigger*/, // Delay until the first trigger
      frequency: const Duration(minutes: 16), // Repeats every 24 hours
      constraints: Constraints(
        networkType: NetworkType.not_required, // No network required
        requiresBatteryNotLow: false, // Battery status does not matter
        requiresCharging: false, // Device does not need to be charging
        requiresDeviceIdle: false, // Device does not need to be idle
      ),
      inputData: <String, dynamic>{
        'word': 'example_word',
      },
    );
  }
}