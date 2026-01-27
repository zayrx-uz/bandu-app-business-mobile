import Flutter
import UIKit
import YandexMapsMobile

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    YMKMapKit.setApiKey("d5c9e62b-6c61-4f7e-a8bf-0eb4eb01348b")
    GeneratedPluginRegistrant.register(with: self)

    // APNS registration — FCM token olish uchun zarur (iOS)
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
