import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _fireBaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}
class NotificationService{
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // Storing instances
    final _messaging = FirebaseMessaging.instance;
    final _localNotifications = FlutterLocalNotificationsPlugin();
    bool _isFlutterLocalNotificationsPluginInitialized = false;

    Future<void> intialize() async {
      FirebaseMessaging.onBackgroundMessage(_fireBaseMessagingBackgroundHandler);
      await _requestPermission();
      await _setupMessageHandlers();
      final token = await _messaging.getToken();
      print("FCM Token $token");
    }

    Future<void> _requestPermission() async {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );
      print('Notification Permission status ${settings.authorizationStatus}');
    }

    Future<void> setupFlutterNotifications() async {
      if(_isFlutterLocalNotificationsPluginInitialized){
        return;
      }

      //android setup
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notification',
        description: 'This channel is used for important notifications.',
        importance: Importance.high
      );

      await _localNotifications.resolvePlatformSpecificImplementation
      <AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
      );

      await _localNotifications.initialize(
          initializationSettings,
        onDidReceiveNotificationResponse: (details) {

        }
      );

      _isFlutterLocalNotificationsPluginInitialized = true;
    }

    Future<void> showNotification(RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android != null){
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'high_importance_channel',
                  'High Importance Notification',
                  channelDescription: 'This channel is used for important notifications.',
                  importance: Importance.high,
                  priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
          ),
          payload: message.data.toString(),
        );
      }
    }

    Future<void> _setupMessageHandlers() async{
      //foreground Message
      FirebaseMessaging.onMessage.listen((message){
        showNotification(message);
      });

      //backgroundMessage
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      //openedApp
      final initalMessage = await _messaging.getInitialMessage();
      if(initalMessage != null){
        _handleBackgroundMessage(initalMessage);
      }
    }

    void _handleBackgroundMessage(RemoteMessage message){
      if(message.data['type']=='chat'){
        //open chat screen
      }
    }
}