//
//  AppDelegate.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/14/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func registerForPushNotifications(){
        let okAction = UIMutableUserNotificationAction()
        okAction.identifier = notification_answer
        okAction.title = "Ok"
        okAction.activationMode = .Background
        okAction.authenticationRequired = false
        okAction.destructive = false
        okAction.behavior = .Default
        let wrongAction = UIMutableUserNotificationAction()
        wrongAction.identifier = notification_result
        wrongAction.title = "See Answer"
        wrongAction.activationMode = .Background
        wrongAction.authenticationRequired = false
        wrongAction.destructive = false
        wrongAction.behavior = .Default
        let replyAction = UIMutableUserNotificationAction()
        replyAction.identifier = notification_question
        replyAction.title = "Answer"
        replyAction.activationMode = .Background
        replyAction.authenticationRequired = false
        replyAction.destructive = false
        replyAction.behavior = .TextInput
        let okCategory = UIMutableUserNotificationCategory()
        okCategory.identifier = okCat_id
        okCategory.setActions([okAction], forContext: .Minimal)
        let category = UIMutableUserNotificationCategory()
        category.identifier = category_id
        category.setActions([replyAction], forContext: .Minimal)
        let wrongCategory = UIMutableUserNotificationCategory()
        wrongCategory.identifier = wrong_cat_id
        wrongCategory.setActions([wrongAction], forContext: .Minimal)
        let categories = NSSet(array:[category,wrongCategory,okCategory]) as! Set<UIUserNotificationCategory>
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //reg device token somehow
        //let currentInstallation = PFInstallation.currentInstallation()
        var device = String(deviceToken)
        device = device.substringWithRange(Range<String.Index>(start: device.startIndex.advancedBy(1), end: device.endIndex.advancedBy(-1)))
        device = device.stringByReplacingOccurrencesOfString(" ", withString: "")
        device_token = device
        print(device_token)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? String{
                let alertCtrl = UIAlertController(title: "Time Entry", message: alert as String, preferredStyle: .Alert)
                alertCtrl.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
                // call the completion handler
                // -- pass in NoData, since no new data was fetched from the server.
                completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Device token for push nots failed")
        print(error.description)
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //registerForNotifications(application)
        registerForPushNotifications()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if let payload = userInfo["aps"] as? NSDictionary{
            if let qid = payload["qid"] as? String{
                if identifier == notification_question{
                    let reply = responseInfo[UIUserNotificationActionResponseTypedTextKey] as! String
                    pushAnswer(qid, answer: reply,url:CHECK_ANSWER_PHP)
                }
                else if identifier == notification_result{
                    pushAnswer(qid, answer: "", url: GET_ANSWER_PHP)
                }
            }
            
        }
        completionHandler()
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if identifier == notification_question{
            let reply = responseInfo[UIUserNotificationActionResponseTypedTextKey]
            NSNotificationCenter.defaultCenter().postNotificationName(notification_key_reply, object: nil, userInfo: ["reply":reply as! String])
        }
        else if identifier == notification_result{
            NSNotificationCenter.defaultCenter().postNotificationName(notification_key_seeAnswer, object: nil, userInfo: nil)
        }
        completionHandler()
    }
    func pushAnswer(qid:String,answer:String,url:String){
        let send_this = "qid=\(qid)&answer='\(answer)'"
        let request = getRequest(send_this, urlString: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data,response,error) in
            if error != nil{
                print("Error with \(url)")
                return
            }
        }
        task.resume()
    }
}

