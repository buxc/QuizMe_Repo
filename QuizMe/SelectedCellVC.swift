//
//  SelectedCellVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/26/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class SelectedCellVC: UIViewController {

    //MARK: - Data members
    var question = Question()
    var questionTemp = ""
    var answerTemp = ""
    var queued : BoolWrapper?  //true if question scheduled for push notification
    var timer = NSTimer()
    var state = "q"
    //MARK: - IBOutlets
    @IBOutlet var swAskMe: UISwitch!
    @IBOutlet var tvText: UITextView!
    @IBOutlet var btSaveChanges: UIButton!
    //MARK: - UIViewcontroller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTemp = question.qText
        answerTemp = question.aText
        tvText.text = question.qText
        if queued?.value == true{
            swAskMe.on = true
        }else{
            swAskMe.on = false
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    //MARK: - General
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //MARK: - Button presses
    /**
    btFlip_OnClick
    Fires when 'Flip' button is pressed
    **/
    @IBAction func btFlip_OnClick(sender: AnyObject) {
        if state == "q"{
            questionTemp = tvText.text
            tvText.text = question.aText
            state = "a"
        }
        else{
            answerTemp = tvText.text
            tvText.text = question.qText
            state = "q"
        }
    }
    /**
     btSaveChanged_OnClick
     Fires when 'Save' button pressed
    **/
    @IBAction func btSaveChanges_OnClick(sender: AnyObject) {
        if state == "q"{
            questionTemp = tvText.text
        }
        else{
            answerTemp = tvText.text
        }
        question.qText = questionTemp
        question.aText = answerTemp
    }
    @IBAction func swAskMe_Switched(sender: AnyObject) {
        if queued?.value == true{
            regQuestion(0)
            queued?.value = false
        }
        else{
            regQuestion(1)
            queued?.value = true
        }
    }
    //MARK: - Database interaction
    /**
    regQuestion
    Registers question for push notifications with db
    PARAMETERS:
        int flag signaling to either schedule or unschedule question
    **/
    func regQuestion(cond:Int){
        let send_this = "device='\(DEVICE_TOKEN)'&qid=\(question.qid)&cond=\(cond)"
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
                alertUser(message,you: self)
            })
            
        }
        task.resume()
    }

}
