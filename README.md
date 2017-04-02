# KNotification
İOS 10 Local Notification Classs

Create class variable

```Swift
    var notif:KNotification!
```

```Swift
     notif = KNotification.instance
        
     notif.current.delegate = self
     notif.content.title = "Title"
     notif.content.subtitle = "Subtitle"
     notif.content.body = "Hi!"
     notif.content.sound = UNNotificationSound.default()
     notif.content.categoryIdentifier = "actionTest"
     
```

Schedule notification

```Swift

    notif.schedule(at: 5, requestId: "test1") // TimeInterval
    notif.schedule(at: sender.date, requestId: "test2") // Date
    
```

Add actions

```Swift

    notif.addActions(titles: ["remind"], ids: ["remind"], categoryId: "actionTest")
    
```

Extension VC

```Swift

    extension yourVC:UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "remind" {
            print("action action !")
            print(response.notification.request.identifier)
        }
        
        completionHandler()
        
    }
}

```

Add Attachment image

```Swift

    notif.addAttechment(name: "profile.png")
    
```

