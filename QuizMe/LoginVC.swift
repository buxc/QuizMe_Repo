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

    *NOT FINISHED*
**/
class LoginVC: UIViewController, UITextFieldDelegate {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
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
    SubmitRequest
    Sends username and password to server to verify login info
**/
    func submitRequest(){
        
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
