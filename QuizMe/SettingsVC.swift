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

    @IBOutlet var tvTable2: UITableView!
    @IBOutlet var tvTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func logOut(){
        UID = 0
        USERNAME = ""
        performSegueWithIdentifier("logOut", sender: self)
    }
    
    func stopAsking1() {
        let confirmBox = UIAlertController(title: "Stop all questions being sent to this device?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        confirmBox.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.stopAsking2()
        }))
        
        confirmBox.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            return
        }))
        presentViewController(confirmBox, animated: true, completion: nil)
    }
   
    func stopAsking2(){
        let send_this = "device='\(device_token)'"
        let request = getRequest(send_this, urlString: STOP_ASKING_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                alertUser("Questions cancelled",you:self)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == tvTable{
            var cell = tableView.dequeueReusableCellWithIdentifier("Settings") as! SettingsTVC?
            if(cell == nil){
                cell = SettingsTVC(style:UITableViewCellStyle.Default, reuseIdentifier:"Settings")
            }
        
            if indexPath.row == 0{
                cell?.lbTitle.text = "Profile"
            }
            else{
                cell?.lbTitle.text = "Info"
            }
            return cell!
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("Settings2") as! Settings2TVC?
            if(cell == nil){
                cell = Settings2TVC(style:UITableViewCellStyle.Default, reuseIdentifier:"Settings2")
            }
            if indexPath.row == 0{
                cell?.lbTitle.text = "Log Out"
            }
            else{
                cell?.lbTitle.text = "Cease all notifications to this device"
            }
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if tableView == tvTable2{
            if indexPath.row == 0{
                logOut()
            }
            else if indexPath.row == 1{
                stopAsking1()
            }
        }
    }
    
}
