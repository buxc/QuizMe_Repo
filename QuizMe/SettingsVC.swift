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
**/
class SettingsVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var tvTable2: UITableView!
    @IBOutlet var tvTable: UITableView!
    //MARK: - ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - General
    /**
     logOut
     Logs the user out and returns to login screen
    **/
    func logOut(){
        UID = 0
        USERNAME = ""
        NSNotificationCenter.defaultCenter().postNotificationName("setFetchedKey", object: self)
        performSegueWithIdentifier("logOut", sender: self)
    }
    /**
     stopAsking1
     Asks user if they're sure they want to stop all questions being sent to their device.
    **/
    func stopAsking1() {
        presentConfirmBox("Stop all questions being sent to this device?", fxn: stopAsking2(), you: self)
    }
   /**
     stopAsking2
     Ceases all incoming questions to device
    **/
    func stopAsking2(){
        let send_this = "device='\(DEVICE_TOKEN)'"
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

    // MARK: - TableView functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //both tables have two rows
    }
    /**
     configures the cells for the two tableviews
     **/
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
            if indexPath.row == 0{//if selected logout cell
                logOut()
            }
            else if indexPath.row == 1{//if selected 'stop notifications' cell
                stopAsking1()
            }
        }else if tableView == tableView{
            if indexPath.row == 0{//if selected profile cell
                performSegueWithIdentifier("PROFILE", sender: self)
            }
            else if indexPath.row == 1{//if selected info cell
                performSegueWithIdentifier("INFO", sender: self)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
