//
//  SelectedCellVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/26/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class SelectedCellVC: UIViewController {

    var question = Question()
    var queued = false
    var timer = NSTimer()
    var state = "q"
    
    @IBOutlet var swAskMe: UISwitch!
    @IBOutlet var tvText: UITextView!
    @IBOutlet var btSaveChanges: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tvText.text = question.qText
        if queued == true{
            swAskMe.on = true
        }else{
            swAskMe.on = false
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nextView = segue.destinationViewController as? TimerVC{
            nextView.question = question
            nextView.timer = timer
        }
    }
    @IBAction func btFlip_OnClick(sender: AnyObject) {
        if state == "q"{
            tvText.text = question.aText
            state = "a"
        }
        else{
            tvText.text = question.qText
            state = "q"
        }
    }
    
    @IBAction func btSaveChanges_OnClick(sender: AnyObject) {
    }
    func regQuestion(cond:Int){
        let send_this = "device='\(device_token)'&qid=\(question.qid)&cond=\(cond)"
        let request = getRequest(send_this, urlString: REGISTER_QUESTION_FOR_PUSH_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                var message = ""
                if cond == 1{
                    message = "Question scheduled!"
                }
                else{
                    message = "Question unscheduled!"
                }
                self.alertUser(message)
            })
            
        }
        task.resume()
    }
    @IBAction func swAskMe_Switched(sender: AnyObject) {
        if queued == true{
            regQuestion(0)
            queued = false
        }
        else{
            regQuestion(1)
            queued = true
        }
    }
    /**
     AlertUser
     displays an alertbox showing passed in message with an "ok" button
     
     @arg message to be displayed to user
     **/
    func alertUser(message:String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
