import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationServices {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize("resource://raw/logo", [
      NotificationChannel(
        channelKey: "dictionary key",
        channelName: "Easy Dictionary",
        channelDescription: "Easy Dictionary Details",
        importance: NotificationImportance.Max,
        playSound: true,
        soundSource: "resource://raw/notificationsound",
      )
    ]);
  }

  Future<void> createNotification(context, String word, String meaning) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: "dictionary key",
            title: "Word Of The Day",
            body: "${word} : $meaning",
            notificationLayout: NotificationLayout.BigText,
            customSound: "resource://raw/notificationsound",
            wakeUpScreen: true,
            category: NotificationCategory.Event),
        schedule: NotificationCalendar(
            hour: 16,
            minute: 10,
            second: 02,
            repeats: true,
            allowWhileIdle: true));
  }
}
