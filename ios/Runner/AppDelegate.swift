import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register method channel using the registrar — this is the reliable way
    // that works regardless of when `window` is initialized.
    let registrar = self.registrar(forPlugin: "SubscriptionManagementPlugin")!
    let channel = FlutterMethodChannel(name: "com.plant.spotify/subscription",
                                       binaryMessenger: registrar.messenger())

    channel.setMethodCallHandler { (call, result) in
      if call.method == "showManageSubscriptions" {
        if #available(iOS 15.0, *) {
          Task { @MainActor in
            guard let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive })
                    ?? UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first else {
              result(FlutterError(code: "NO_SCENE", message: "No active window scene found", details: nil))
              return
            }
            do {
              try await AppStore.showManageSubscriptions(in: windowScene)
              result(true)
            } catch {
              result(FlutterError(code: "FAILED", message: error.localizedDescription, details: nil))
            }
          }
        } else {
          result(false)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
