//
//  SettingsVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/19/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit
/**
    ViewController handling settings screen.
    Not even sure what settings we'd put in here

    *NOT FINISHED*
**/
class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func LogOut_OnClick(sender: AnyObject) {
        UID = 0
        USERNAME = ""
        navigationController?.popViewControllerAnimated(true)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
