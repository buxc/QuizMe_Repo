//
//  RecentsTVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/26/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class RecentsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Data members
    var fetched = false     //if have fetched questions from server
    var sets = [QmSet]()
    var questions = [Question]()    //array of questions from server
    var scheduledForPush = [BoolWrapper]()   //parallel array with questions indicating if scheduled
    var qidsScheduledForPush = [Int]()  //qids of questions scheduled for push notifications
    
    //MARK: - IBOutlets
    @IBOutlet var tvTable: UITableView!
    @IBOutlet var scTypeDisplayed: UISegmentedControl!
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setFetched", name: "setFetchedKey", object: nil)
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
        /*This way, questions are fetched only once from the server, after user logs in*/
        if USERNAME != "" {
            if fetched == false{
                getQuestions()
                getSets()
                fetched = true
                return
            }
            tvTable.reloadData() //always reload the tableview
        }
    }
    //MARK: - General
    /**
     setFetched
     When user logs out via Settings, this fires to reset fetched to false
     **/
    func setFetched(){
        fetched = false
    }
    /**
        IsScheduled
        Determines whether or not question is scheduled for pushing
        @param qid of question of interest
        @return true is scheduled, false if not
    **/
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
    /**
     ConfigureScheduleForPush
     Sets up parallel boolean array scheduledForPush
    **/
    func configureScheduleForPush(){
        for(var i = 0; i < questions.count;i++){
            if isScheduled(questions[i].qid) == true{
                scheduledForPush[i] = BoolWrapper(val: true)
            }else{
                scheduledForPush[i] = BoolWrapper(val: false)
            }
        }
        aiSpinner.stopAnimating()
    }
    //MARK: - Database interaction
    /**
     GetScheduledQuestions
     Requests qids of all scheduled questions for this device and stores them
     in qidsScheduledForPush
    **/
    func getScheduledQuestions(){
        let send_this = "device='\(DEVICE_TOKEN)'"
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
                            gCountQueuedForPush = self.qidsScheduledForPush.count
                            self.configureScheduleForPush()
                        })
                    }
                }
                catch _ as NSError {}
            }
        }
        task.resume()
    }
    /**
     GetQuestions
     Requests all questions from server associated with logged in user. 
     Stores them in questions array
    **/
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
                                                self.scheduledForPush.append(BoolWrapper(val:false))
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
    /**
     DeleteQuestion
     Deletes question from server
    **/
    func deleteQuestion(qid:Int,index:Int){
        aiSpinner.startAnimating()
        let send_this = "qid=\(qid)"
        let request = getRequest(send_this, urlString: DELETE_QUESTION_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            if error != nil{
                //alertUser()
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.questions.removeAtIndex(index)
                self.tvTable.reloadData()
                self.aiSpinner.stopAnimating()
            })
            
        }
        task.resume()
    }
    /**
     DeleteSet
     Deletes set from server
     **/
    func deleteSet(pid:Int,index:Int){
        aiSpinner.startAnimating()
        let send_this = "pid=\(pid)"
        let request = getRequest(send_this, urlString: DELETE_SET_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            if error != nil{
                //alertUser()
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.sets.removeAtIndex(index)
                self.tvTable.reloadData()
                self.aiSpinner.stopAnimating()
            })
            
        }
        task.resume()
    }
    /**
     GetSets
     Fetches user defined sets from server
     **/
    func getSets(){
        sets.removeAll()
        let send_this = "uid=\(UID)"
        let request = getRequest(send_this, urlString: GET_SETS_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            if let data = data{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray{    //put response into JSON so can access like a dictionary
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
                    }
                    
                }
                catch _ as NSError {}
            }
        }
        task.resume()
    }
    // MARK: - UITableView functions

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scTypeDisplayed.selectedSegmentIndex == 0{
            return questions.count
        }
        else{
            return sets.count
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if scTypeDisplayed.selectedSegmentIndex == 0{
                deleteQuestion(questions[indexPath.row].qid,index: indexPath.row)
            }else{
                deleteSet(sets[indexPath.row].pid, index: indexPath.row)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if scTypeDisplayed.selectedSegmentIndex == 0{
            performSegueWithIdentifier("SelectedQuestion", sender: self)
        }else{
            performSegueWithIdentifier("SelectedSet", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Basic") as! BasicTableViewCell?
        if(cell == nil){
            cell = BasicTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Basic")
        }
        if scTypeDisplayed.selectedSegmentIndex == 0{ //if questions selected
            cell!.lbType.text = "Q:"
            cell!.lbQuestion.text = questions[indexPath.row].qText
        }
        else{ //if sets selected
            cell!.lbType.text = "S:"
            cell!.lbQuestion.text = sets[indexPath.row].name
        }
        return cell!
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tvTable.indexPathForSelectedRow
        if scTypeDisplayed.selectedSegmentIndex == 1{ //if sets selected
            if let nextView = segue.destinationViewController as? RecentSelectedSetVC{
                nextView.set = sets[indexPath!.row]
            }
        }
        else{
            if let nextView = segue.destinationViewController as? SelectedCellVC{
                nextView.question = questions[indexPath!.row]
                nextView.queued = scheduledForPush[indexPath!.row]
            }
        }
    }
    // MARK: - UISegmentedControl functions
    /**
     Fires when segmented control value changes(user clicks it)
    **/
    @IBAction func scTypeDisplayed_ValueChanged(sender: AnyObject) {
        tvTable.reloadData()
    }
}
