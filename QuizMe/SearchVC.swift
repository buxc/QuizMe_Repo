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
    
    //MARK: - IBOutlets
    @IBOutlet var tvTable: UITableView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Topics"
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
        var cell = tableView.dequeueReusableCellWithIdentifier("Basic") as UITableViewCell?
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Basic")
        }
        cell!.textLabel?.text = topics[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("TOPIC", sender: self)
    }
}
