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

    func registerForNotifications(application : UIApplication){
        //http://fancypixel.github.io/blog/2015/06/11/ios9-notifications-and-text-input/
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
        let category = UIMutableUserNotificationCategory()
        category.identifier = category_id
        category.setActions([replyAction], forContext: .Minimal)
        let wrongCategory = UIMutableUserNotificationCategory()
        wrongCategory.identifier = wrong_cat_id
        wrongCategory.setActions([wrongAction], forContext: .Minimal)
        //category.setActions([replyAction, verdictAction], forContext: .Default)
        let categories = NSSet(array:[category,wrongCategory]) as! Set<UIUserNotificationCategory>
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        registerForNotifications(application)
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
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if identifier == notification_question{
            let reply = responseInfo[UIUserNotificationActionResponseTypedTextKey]
            NSNotificationCenter.defaultCenter().postNotificationName(notification_key_reply, object: nil, userInfo: ["reply":reply as! String])
        }
        else{
            NSNotificationCenter.defaultCenter().postNotificationName(notification_key_seeAnswer, object: nil, userInfo: nil)
        }
        completionHandler()
    }

}

