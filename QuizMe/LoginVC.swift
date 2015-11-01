//
//  LoginVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/18/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit
/**
    ViewController handling User Login. Pretty basic

    *PRACTICALLY FINISHED*
**/
class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var btLogin: UIButton!
    @IBOutlet var cvView: UIView!
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchEmbeddedVisibility", name: notification_key_login, object: nil)
        // Do any additional setup after loading the view.
    }

    func switchEmbeddedVisibility(){
        if cvView.hidden == true{
            cvView.hidden = false
            btLogin.enabled = false
            view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        }
        else{
            cvView.hidden = true
            btLogin.enabled = true
            view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1)
        }
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool) {
        count = 0
    }
/**
    btLogin_OnClick
    Executes when 'Log in' button pressed
**/
    @IBAction func btLogin_OnClick(sender: UIButton) {
        submitRequest()
    }
/**
    ClearFields
    
    clears uifields
**/
    func clearFields(){
        tfPassword.text = ""
        tfUsername.text = ""
    }
/**
    SubmitRequest
    The fxn that talks to the server. Sends the inputted name and password from the
    textfields into a NSMutableRequest and sends to server
**/
func submitRequest(){
        aiSpinner.startAnimating()
        let send_this = "name='\(tfUsername.text!)'&pw='\(tfPassword.text!)'"
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
                        dispatch_async(dispatch_get_main_queue(), {
                            self.aiSpinner.stopAnimating()
                            if(json.count == 1){//if username exists
                                for dic in json{
                                    if case let id as String = dic["uid"]{
                                    if case let name as String = dic["name"]{
                                        if case let pw as String = dic["password"]{
                                            if self.tfPassword.text! == pw {
                                                self.count = 1
                                                UID = Int(id)!
                                                USERNAME = name
                                                self.clearFields()
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                            }
                                            if self.count == 0{
                                                    self.alertUser("Incorrect password")
                                            }
                                            
                                           }
                                        }
                                    }
                                }
                            }
                            else{//if username doesn't exist
                                self.alertUser("Username does not exist")
                            }
                        })
                    }
                }
                catch _ as NSError {}
            }
        }
        task.resume()
    }
    @IBAction func btLogIn_OnClick(sender: AnyObject) {
        submitRequest()
    }
/**
    Text_Field_Should_Return
    
    Allows keyboard to go away after user enters quantity by pressing return
**/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func btStopAsking_OnClick(sender: AnyObject) {
        let confirmBox = UIAlertController(title: "Stop all questions being sent to this device?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        confirmBox.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.stopAsking()
        }))
        
        confirmBox.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            return
        }))
        presentViewController(confirmBox, animated: true, completion: nil)
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
    @IBAction func btCreateAccount_OnClick(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification_key_login, object: self)
    }
    func stopAsking(){
        let send_this = "device='\(device_token)'"
        let request = getRequest(send_this, urlString: STOP_ASKING_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.alertUser("Questions cancelled")
            })
            
        }
        task.resume()
    }

}
