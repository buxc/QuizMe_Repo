//
//  CreateLoginVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/20/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit
/**
    ViewController handling the create login screen
**/
class CreateLoginVC: UIViewController, UITextFieldDelegate {

    //MARK: - IBOutlets
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword1: UITextField!
    @IBOutlet var tfPassword2: UITextField!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clearFields", name: notification_key_login, object: nil)
    }

    //MARK: - Button presses
    /**
     btCancel_OnClick
     Fires when 'Cancel' button pressed
    **/
    @IBAction func btCancel_OnClick(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification_key_login, object: self)
    }
    /**
     btSubmit_onClick
     Fires when 'Submit' question pressed
    **/
    @IBAction func btSubmit_OnClick(sender: AnyObject) {
        if !passwordsMatch(){
            return
        }
        queryUser()
    }
    //MARK: - UI stuff
    /**
    clearFields
    Sets all textfields to ""
    **/
    func clearFields(){
        tfUsername.text = ""
        tfPassword1.text = ""
        tfPassword2.text = ""
    }
    //MARK: - General
    /**
        PassordsMatch
        Checks to see if passwords match and meet conditions
    
        @return Bool true if they do meet conditions, false if not
    **/
    func passwordsMatch() -> Bool{
        if tfPassword1.text != "" && tfPassword1.text == tfPassword2.text{
            return true
        }
        else{
            alertUser("Password mismatch",you:self)
            return false
        }
    }
    //MARK: - Database interaction
    /**
    SubmitRequest
    The fxn that talks to the server. Sends the inputted name and password from the 
    textfields into a NSMutableRequest and sends to server
    **/
    func queryUser(){
        aiSpinner.startAnimating()
        let send_this = "name='\(tfUsername.text!)'&pw='\(tfPassword2.text!)'"
        let request = getRequest(send_this, urlString: QUERY_USERNAME_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            if let data = data{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray{    //put response into JSON so can access like a dictionary
                        if(json.count == 0){
                            self.createUser()
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), {
                                alertUser("Username taken",you:self)
                                self.aiSpinner.stopAnimating()
                            })
                        }
                    }
                }
             catch _ as NSError {}
            }
        }
        task.resume()
    }
    /**
     PushAnswer
     Registers question for push notifications
     PARAMETERS:
        question id
        correct answer to question
        url for php file
    **/
    func pushAnswer(qid:String,answer:String,url:String){
        let send_this = "device=\(DEVICE_TOKEN)&qid=\(qid)&answer='\(answer)'"//note device token not in quotes
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
    /**
    CreateUser
    
    Inserts username and password into database
     **/
    func createUser(){
        let send_this = "name='\(tfUsername.text!)'&pw='\(tfPassword2.text!)'"
        let request = getRequest(send_this, urlString: CREATE_USER_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                alertUser("Username created",you:self)
                NSNotificationCenter.defaultCenter().postNotificationName(notification_key_login, object: self)
            })
            
        }
        task.resume()
    }
    //MARK: - UITextFieldDelegate functions
    /**
    Text_Field_Should_Return
    
    Allows keyboard to go away after user enters quantity by pressing return
    **/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
