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
    var scheduledForPush = [Bool]()
    var qidsScheduledForPush = [Int]()
    @IBOutlet var tvTable: UITableView!
    @IBOutlet var scTypeDisplayed: UISegmentedControl!
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if USERNAME == ""{
            /*
            Causes 2 warnings: "Presenting view controllers on detached view controllers is discouraged" and
            379ae97e0b0b7b98d3521
            2015-11-04 22:43:06.371 QuizMe[686:195977] Unbalanced calls to begin/end appearance transitions for <UITabBarController:
            */
            performSegueWithIdentifier("logIn", sender: self)
        }
    }
    override func viewWillAppear(animated: Bool) {
        getQuestions()
    }
    func isScheduled(qid:Int) -> Bool{
        let limit = qidsScheduledForPush.count
        var i = 0
        while i < limit{
            if qid == qidsScheduledForPush[i]{
                return true
            }
            /*if qid < qidsScheduledForPush[i]{//array is sorted, so if array[i] > qid then qid not in list
                return false
            }*/
            i++
        }
        return false
    }
    func configureScheduleForPush(){
        for(var i = 0; i < questions.count;i++){
            if isScheduled(questions[i].qid) == true{
                scheduledForPush[i] = true
            }else{
                scheduledForPush[i] = false
            }
        }
        aiSpinner.stopAnimating()
    }
    func getScheduledQuestions(){
        let send_this = "device='\(device_token)'"
        let request = getRequest(send_this, urlString: GET_REGISTERED_QUESTIONS_PHP)
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
                                    self.qidsScheduledForPush.append(Int(qid)!)
                                }
                            }
                            self.configureScheduleForPush()
                        })
                    }
                }
                catch _ as NSError {}
            }
        }
        task.resume()
    }

    func getQuestions(){
        if(UID == 0){
            return
        }
        aiSpinner.startAnimating()
        questions.removeAll()
        qidsScheduledForPush.removeAll()
        scheduledForPush.removeAll()
        let send_this = "uid=\(UID)"
        let request = getRequest(send_this, urlString: GET_QUESTIONS_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with getting questions")
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
                                                self.scheduledForPush.append(false)
                                            }
                                        }
                                    }
                                }
                                self.tvTable.reloadData()
                                self.getScheduledQuestions()
                            })
                    }
                }
                catch _ as NSError {}
            }
        }
        task.resume()
    }
    
    func deleteQuestion(qid:Int){
        let send_this = "qid=\(qid)"
        let request = getRequest(send_this, urlString: DELETE_QUESTION_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            if error != nil{
                print("Error with order request")
                return
            }
            self.getQuestions()
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

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteQuestion(questions[indexPath.row].qid)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Basic") as! BasicTableViewCell?
        if(cell == nil){
            cell = BasicTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Basic")
        }
        cell!.lbQuestion.text = questions[indexPath.row].qText
        return cell!
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tvTable.indexPathForSelectedRow
        if let nextView = segue.destinationViewController as? SelectedCellVC{
            nextView.question = questions[indexPath!.row]
            if scheduledForPush[indexPath!.row] == true{
                nextView.queued = true
            }else{
                nextView.queued = false
            }
        }
    }
    

}
