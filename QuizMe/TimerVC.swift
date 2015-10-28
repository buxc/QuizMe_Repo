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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func sendNotification(){
        let notification = UILocalNotification()
        notification.alertAction = "Answer"
        notification.alertBody = question.qText
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
            timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("sendNotification"), userInfo: nil, repeats: true)
            timer.fire()
            btStopTimer.hidden = false
            running_question_timers[question.qid] = true
        }
    }
    
}
