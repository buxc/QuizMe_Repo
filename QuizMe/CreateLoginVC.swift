//
//  CreateLoginVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/20/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class CreateLoginVC: UIViewController, UITextFieldDelegate {

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
    
    func passwordsMatch() -> Bool{
        if tfPassword1.text != "" && tfPassword1.text == tfPassword2.text{
            return true
        }
        else{
            return false
        }
    }
    func submitRequest(){
        let send_this = "name='\(tfUsername.text!)'&pw='\(tfPassword2.text!)'"
        let request = getRequest(send_this, urlString: TEST_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            if error != nil{
                print("Error with creating login")
                return
            }
            if let data = data{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray{
                        dispatch_async(dispatch_get_main_queue(), {
                            for dic in json{
                                if case let result as String = dic["name"]{
                                    if result == "success"{
                                        //display nice message
                                        self.tfUsername.text = "it worked"
                                    }
                                    else if result == "name taken"{
                                        self.tfUsername.text = "name taken"
                                    }
                                    else{
                                        self.tfUsername.text = "fucked up"
                                    }
                                }
                            }
                        })
                    }
                }
             catch _ as NSError {}
            }
        }
        task.resume()
    }
    @IBAction func btSubmit_OnClick(sender: AnyObject) {
        if !passwordsMatch(){
            //display error message
            return
        }
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
