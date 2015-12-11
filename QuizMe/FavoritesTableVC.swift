//
//  FavoritesTableViewController.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 12/8/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class FavoritesTableVC: UITableViewController {

    //MARK: - Data members
    var fetched = false
    var sets = [QmSet]()
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchFetched", name: "favorites_fetch_key", object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        if fetched == false{
            getSets()
            fetched = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - General
    func switchFetched(){
        if fetched == true{
            fetched = false
        }else{
            fetched = true
        }
    }
    //MARK: - Database interaction
    /**
     GetSets
     Fetches user defined sets from server
     **/
    func getSets(){
        sets.removeAll()
        let send_this = "uid=\(UID)"
        let request = getRequest(send_this, urlString: GET_FAVORITES_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            if let data = data{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers,NSJSONReadingOptions.AllowFragments]) as? NSArray{
                        for dic in json{
                            if case let id as String = dic["pid"]{
                                if case let pname as String = dic["name"]{
                                    if case let topic as String = dic["topic"]{
                                        if case let priv as String = dic["private"]{
                                            let temp = QmSet(pid: Int(id)!, name: pname, topic: topic, privat: priv,cr:UID)
                                            self.sets.append(temp)
                                        }
                                    }
                                }
                            }
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            
                        })
                    }
                }
                
                catch let e as NSError {
                    print(e)
                }
            }
        }
        task.resume()
    }
    
    //MARK: - UITableView functions

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("fav") as UITableViewCell?
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"fav")
        }
        cell!.textLabel?.text = sets[indexPath.row].name
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("favToq", sender: self)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nextView = segue.destinationViewController as? RecentSelectedSetVC{
            nextView.set = sets[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }

    }
    

}
