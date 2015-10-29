//
//  RecentsTVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/26/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class RecentsVC: UIViewController {

    var questions = [Question]()
    var timers = [Int : NSTimerWrapper]()
    @IBOutlet var tvTable: UITableView!
    @IBOutlet var scTypeDisplayed: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        questions.removeAll()
        getQuestions()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getQuestions(){
        let send_this = "uid=\(UID)"
        let request = getRequest(send_this, urlString: GET_QUESTIONS_PHP)
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
                                for dic in json{
                                    if case let qid as String = dic["qid"]{
                                        if case let q as String = dic["question_text"]{
                                            if case let a as String = dic["answer_text"]{
                                                let question = Question(qid: Int(qid)!, qText: q, aText: a, choices: nil)
                                                self.questions.append(question)
                                                self.timers[question.qid] = NSTimerWrapper(timer: NSTimer()) //set question to having default timer
                                                running_question_timers[question.qid] = false
                                            }
                                        }
                                    }
                                }
                                self.tvTable.reloadData()
                            })
                    }
                }
                catch _ as NSError {}
            }
        }
        task.resume()
    }
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Basic") as! BasicTableViewCell?
        if(cell == nil){
            cell = BasicTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Basic")
        }
        cell!.lbQuestion.text = questions[indexPath.row].qText
        return cell!
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
        let indexPath = tvTable.indexPathForSelectedRow
        if let nextView = segue.destinationViewController as? SelectedCellVC{
            nextView.question = questions[indexPath!.row]
            nextView.timer = timers[questions[indexPath!.row].qid]!.timer
        }
    }
    

}
