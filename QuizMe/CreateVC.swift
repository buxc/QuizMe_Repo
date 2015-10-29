//
//  CreateVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/19/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit
/**
    ViewController handling screen where User creates new questions
    and sets.

    *Multiple choice questions have yet to be implemented*

    *BASICALLY FINISHED*
**/
class CreateVC: UIViewController, UITextViewDelegate {

    @IBOutlet var cvView: UIView!
    @IBOutlet var lbLabel: UILabel!
    @IBOutlet var tvTextView: UITextView!
    @IBOutlet var btEnter: UIButton!
    @IBOutlet var btGoBack: UIButton!
    var state = "q"
    var question = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvTextView.becomeFirstResponder()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchEmbeddedVisibility", name: notification_key, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
/**
    InputGood
    Verifies that both question and answer provided are between 1 and 50 chars long
    @return Bool
**/
    func inputGood() -> Bool{
        if tvTextView.text?.characters.count < 200                                                                                                                                                                                                       && tvTextView.text?.characters.count > 0 {
            return true
        }
        return false
    }

/**
    SubmitQuestion
**/
    func submitQuestion(){
        let send_this = "question='\(question.qText)'&answer='\(question.aText)'&uid=\(UID)"
        let request = getRequest(send_this, urlString: CREATE_QUESTION_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.alertUser("Question created!")
            })
        }
        task.resume()
}
/**
     SwitchEmbeddedVisibility
     Switches visibility of view containing new set shit
**/
    func switchEmbeddedVisibility(){
        if cvView.hidden == true{
            cvView.hidden = false
            view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        }
        else{
            cvView.hidden = true
            view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1)
        }
    }
/**
    ChangeState
    Updates user prompt for either question or answer
**/
    func changeState(){
        if state == "q"{
            question.qText = tvTextView.text
            lbLabel.text = "Enter Answer:"
            tvTextView.text = ""
            state = "a"
            tvTextView.becomeFirstResponder()
            btGoBack.hidden = false
            
        }
        else{//state == "a"
            question.aText = tvTextView.text
            lbLabel.text = "Enter Question:"
            tvTextView.text = ""
            state = "q"
            submitQuestion()
            tvTextView.becomeFirstResponder()
            btGoBack.hidden = true
        }
    }
    @IBAction func btCreate_OnClick(sender: AnyObject) {
        if(!inputGood()){
            //display error
            return
        }
        changeState()
    }
    @IBAction func btGoBack_onClick(sender: AnyObject) {
        state = "q"
        lbLabel.text = "Enter Question:"
        tvTextView.text = question.qText
        tvTextView.becomeFirstResponder()
        btGoBack.hidden = true
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
/**
    Lets keyboard dissapear after typing
**/
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    @IBAction func btCreateNewSet_OnClick(sender: AnyObject) {
        switchEmbeddedVisibility()
    }
}
