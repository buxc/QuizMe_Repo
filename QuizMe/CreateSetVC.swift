//
//  CreateSetVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/28/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class CreateSetVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: - Data members
    let topics = ["None", "Biology","Chemistry","Computer Science", "Entertainment", "Earth Science", "Geography", "History", "Language","Literature","Miscellaneous", "Physics", "Sports"]
    
    //MARK: - IBOutlets
    @IBOutlet var tfSetNme: UITextField!
    @IBOutlet var pvTopic: UIPickerView!
    @IBOutlet var swchPrivate: UISwitch!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Database interaction
    /**
     CreateSet
    **/
    func createSet(){
        var priv : Int
        if swchPrivate.on{
            priv = 1
        }else{
            priv = 0
        }
        let topicName = topics[pvTopic.selectedRowInComponent(0)]
        let send_this = "uid=\(UID)&name='\(tfSetNme.text!)'&topic='\(topicName)'&private=\(priv)"
        let request = getRequest(send_this, urlString: CREATE_SET_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                alertUser("Set created",you:self)
                NSNotificationCenter.defaultCenter().postNotificationName("refetchSetsKey", object: self)
                NSNotificationCenter.defaultCenter().postNotificationName(notification_key, object: self)
            })
            
        }
        task.resume()
    }
    //MARK: - Button presses
    @IBAction func btCancel_OnClick(sender: AnyObject) {
        tfSetNme.text = ""
        NSNotificationCenter.defaultCenter().postNotificationName(notification_key, object: self)
    }

    @IBAction func btCreateSet_OnClick(sender: AnyObject) {
        createSet()
    }
    // MARK: - PickerView methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return topics.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return topics[row]
    }
}
