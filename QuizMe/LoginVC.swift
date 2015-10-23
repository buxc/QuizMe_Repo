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

    *ALMOST FINISHED*
**/
class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var lbError: UILabel!
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
    

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if(segue.identifier == "loggedIn"){
            if(USERNAME != ""){
                
            }
        }
        // Pass the selected object to the new view controller.
    }
    
    */
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
        lbError.text = ""
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
                                    if case let name as String = dic["name"]{
                                        if case let pw as String = dic["password"]{
                                            if(self.tfPassword.text! == pw){
                                                USERNAME = name
                                                self.clearFields()
                                                self.performSegueWithIdentifier("loggedIn", sender: self)
                                            }
                                            else{
                                                self.lbError.text = "Incorrect password"
                                                self.lbError.hidden = false
                                            }
                                        }
                                    }
                                }
                            }
                            else{//if username doesn't exist
                                self.lbError.text = "Username does not exist"
                                self.lbError.hidden = false
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
}
