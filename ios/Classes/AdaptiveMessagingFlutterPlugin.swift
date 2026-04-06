import Flutter
import UIKit
import AdaptiveMessaging

public class AdaptiveMessagingFlutterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "adaptive_messaging",
            binaryMessenger: registrar.messenger()
        )
        let instance = AdaptiveMessagingFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        switch call.method {

        case "setFCMToken":
            guard let token = args["token"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "token is required", details: nil))
                return
            }
            Task {
                await AdaptiveMessaging.shared.updateFCMToken(token: token)
                DispatchQueue.main.async { result(nil) }
            }

        case "isAdaptiveNotification":
            guard let payload = args["payload"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "payload is required", details: nil))
                return
            }
            result(AdaptiveMessaging.shared.isAdaptiveNotification(data: payload))

        case "showAdaptiveNotification":
            guard let payload = args["payload"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "payload is required", details: nil))
                return
            }
            AdaptiveMessaging.shared.showNotification(from: payload)
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
