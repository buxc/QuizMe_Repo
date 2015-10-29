//
//  TimerVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/27/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {

    var question = Question()
    var timer = NSTimer()
    
    @IBOutlet var btStopTimer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if running_question_timers[question.qid] == false{
            btStopTimer.hidden = true
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "accessReply:", name: notification_key_reply, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendAnswer", name: notification_key_seeAnswer, object: nil)

        // Do any additional setup after loading the view.
    }

    func sendAnswer(){
        let notification = UILocalNotification()
        notification.alertBody = question.aText
        //notification.category = wrong_cat_id
        notification.fireDate = NSDate(timeIntervalSinceNow: 0)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func accessReply(notification:NSNotification){
        var info = [[String:AnyObject]]()
        info.append(notification.userInfo as! [String:String])
        let answer = info[0]["reply"] as! String
        if answer == question.aText{
            sendNotificationResult("correct")
        }
        else{
            sendNotificationResult("wrong")
        }
    }
    func sendNotificationResult(verdict:String){
        let notification = UILocalNotification()
        notification.category = notification_result
        notification.fireDate = NSDate(timeIntervalSinceNow: 0)
        if verdict == "correct"{
            notification.alertBody = "Correct!"
        }
        else{
            notification.alertBody = "Wrong"
            notification.category = wrong_cat_id
        }
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/**
     SendNotification
     
     Creates and sends push notification
**/
    func sendNotification(){
        let notification = UILocalNotification()
        notification.alertBody = question.qText
        notification.category = category_id
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = NSDate(timeIntervalSinceNow: 0)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
/**
     Stop the notifications by disabling timer
**/
    @IBAction func btStopTimer_OnClick(sender: AnyObject) {
        timer.invalidate()
        running_question_timers[question.qid] = false
        btStopTimer.hidden = true
    }
/**
     Start notifications by creating timer if timer not running
**/
    @IBAction func bt_OnClick(sender: AnyObject) {
        if running_question_timers[question.qid] == false{
            timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector("sendNotification"), userInfo: nil, repeats: true)
            timer.fire()
            btStopTimer.hidden = false
            running_question_timers[question.qid] = true
        }
    }
    
}
