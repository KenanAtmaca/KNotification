//
//  Created by Kenan Atmaca
//  kenanatmaca.com
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//

import UIKit
import UserNotifications


class KNotification {

    static let instance = KNotification()
    
    let current = UNUserNotificationCenter.current()
    lazy var content:UNMutableNotificationContent = UNMutableNotificationContent()
    var actions:[UNNotificationAction] = []
    
    fileprivate init() {
        auth()
    }
    
   fileprivate func auth() {
      
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
            if error != nil {
                print("@ Request error")
                return
            }
        }
    }
    
    func schedule(at date:Date, requestId:String) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let ctrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: ctrigger)
        
        current.add(request) { (error) in
            if error != nil {
                if let err = error {
                    print("@ Request notification error. \(err)")
                }
                
                return
            }
        }
    }
    
    func schedule(at time:TimeInterval, requestId:String) {
        
        let ttrigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: ttrigger)
        
        current.add(request) { (error) in
            if error != nil {
                if let err = error {
                    print("@Request notification error. \(err)")
                }
                return
            }
        }
    }
  
    func addAttechment(name:String, attachId:String) {
        
        let aurl = attechFile(name: name)
        
        do {
            let attechment = try UNNotificationAttachment(identifier: attachId, url: aurl!, options: nil)
            content.attachments = [attechment]
        } catch {
            print("The attachment error!")
        }
        
    }
    
    fileprivate func attechFile(name:String) -> URL? {
        
        let comp = name.components(separatedBy: ".")
        
        if let path = Bundle.main.path(forResource: comp.first!, ofType: comp[1]) {
            
            let url = URL(fileURLWithPath: path)
            return url
        }
        
        return nil
    }
    
    func addActions(titles:[String],ids:[String],categoryId:String) {
      
        for i in 0..<titles.count {
            actions.append(UNNotificationAction(identifier: ids[i], title: titles[i], options: []))
        }
        
        let actionsCategory = UNNotificationCategory(identifier: categoryId, actions: actions, intentIdentifiers: [], options: [])
        
        current.setNotificationCategories([actionsCategory])

    }
    
    func removeNotification(requestId:String) {
    
        current.getPendingNotificationRequests(completionHandler: {requests -> () in
         
                for request in requests {
                 
                    if request.identifier == requestId {
                        self.current.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                        print("Deleted: \(request.identifier)")
                    } else {
                        print("id: \(request.identifier)")
                    }
             }
        })
    }
    
    func removeAllNotifications() {
        current.removeAllDeliveredNotifications()
        current.removeAllPendingNotificationRequests()
    }
   
    
}//


