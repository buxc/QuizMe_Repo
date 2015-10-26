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

    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                            if(self.tfPassword.text! == pw){
                                                UID = Int(id)!
                                                USERNAME = name
                                                self.clearFields()
                                                self.performSegueWithIdentifier("loggedIn", sender: self)
                                            }
                                            else{
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
