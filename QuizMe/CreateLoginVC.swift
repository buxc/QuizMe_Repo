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

    *FINISHED*
**/
class CreateLoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var lbError: UILabel!
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword1: UITextField!
    @IBOutlet var tfPassword2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            lbError.hidden = false
            lbError.text = "Error: Password mismatch"
            return false
        }
    }
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
                                self.lbError.text = "Error: Username taken"
                                self.lbError.hidden = false
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
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
        }
        task.resume()
    }
    @IBAction func btSubmit_OnClick(sender: AnyObject) {
        if !passwordsMatch(){
            //display error message
            return
        }
        queryUser()
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
