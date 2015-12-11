//
//  SearchVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/19/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit
/**
    ViewController handling the search screen.
**/
class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Data members
    let topics = ["Biology","Chemistry","Computer Science", "Entertainment", "Earth Science", "Geography", "History", "Language","Literature","Miscellaneous", "Physics", "Sports"]
    var favorites = [Int]() //pids of favorites
    //MARK: - IBOutlets
    @IBOutlet var tvTable: UITableView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Topics"
        getFavorites()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tvTable.indexPathForSelectedRow
        if let nextView = segue.destinationViewController as? SelectedTopicVC{
            nextView.topic = topics[indexPath!.row]
            nextView.favorites = favorites
            tvTable.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    

    // MARK: - UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Topic") as UITableViewCell?
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Topic")
        }
        cell!.textLabel?.text = topics[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("TOPIC", sender: self)
    }
    
    //MARK: - Database interaction
    /**
    GetFavorites
    Fetches user defined sets from server
    **/
    func getFavorites(){
        favorites.removeAll()
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
                                            self.favorites.append(temp.pid)
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                catch let e as NSError {
                    print(e)
                }
            }
        }
        task.resume()
    }
}
