//
//  CreateSetVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/28/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class CreateSetVC: UIViewController {

    @IBOutlet var tfSetNme: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/**
     MakeRequest
     The fxn that talks to the server. Sends the inputted name and password from the
     textfields into a NSMutableRequest and sends to server

    func makeRequest(){
        let send_this = "name='"
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
                                var flag = false
                                for dic in json{
                                    if case let id as String = dic["uid"]{
                                        if case let name as String = dic["name"]{
                                            if case let pw as String = dic["password"]{
                                                if self.tfPassword.text! == pw {
                                                    flag = true
                                                    UID = Int(id)!
                                                    USERNAME = name
                                                    self.clearFields()
                                                    self.performSegueWithIdentifier("loggedIn", sender: self)
                                                }
                                                if flag == false{
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
 */
    @IBAction func btCancel_OnClick(sender: AnyObject) {
        tfSetNme.text = ""
        NSNotificationCenter.defaultCenter().postNotificationName(notification_key, object: self)
    }

    @IBAction func btCreateSet_OnClick(sender: AnyObject) {
        
    }
}
