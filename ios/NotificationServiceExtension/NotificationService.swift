//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Boris Karabanov on 10/01/2024.
//

import UserNotifications
import Flutter

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    var flutterEngine = {
        if #available(iOS 16, *) {
            return FlutterEngine(name: "engine2", project: FlutterDartProject(precompiledDartBundle: Bundle(url: Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent().appending(component: "Frameworks").appending(component: "NotificationServiceExtension.framework"))));
        } else {
            return FlutterEngine(name: "engine2", project: FlutterDartProject(precompiledDartBundle: Bundle(url: Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent( "Frameworks").appendingPathComponent("NotificationServiceExtension.framework"))));
        }
    }()
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            DispatchQueue.main.async {
//                self.flutterEngine.run()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
