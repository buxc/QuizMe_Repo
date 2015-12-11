//
//  RecentSelectedSetVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 12/10/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class RecentSelectedSetVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - Data members
    var fetched = false
    var questions = [Question]()
    var scheduledForPush = [BoolWrapper]()
    var qidsScheduledForPush = [Int]()
    var set : QmSet?
    //MARK: - IBOutlets
    @IBOutlet var tvTable: UITableView!
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    
    //MARK: - UITableView functions
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setFetched", name: "setFetchedKey", object: nil)
        self.navigationItem.title = set?.name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if fetched == false{
            getQuestions(set!.pid)
            fetched = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - General
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tvTable.indexPathForSelectedRow
        if let nextView = segue.destinationViewController as? SelectedCellVC{
            nextView.question = questions[indexPath!.row]
            nextView.queued = scheduledForPush[indexPath!.row]
            tvTable.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    
    
    //MARK: - Database interaction
    /**
    GetQuestions
    Requests all questions from server associated with logged in user.
    Stores them in questions array
    **/
    func getQuestions(id:Int){
        aiSpinner.startAnimating()
        questions.removeAll()
        let send_this = "packID=\(id)"
        let request = getRequest(send_this, urlString: GET_QUESTIONS_FROM_SET_PHP)
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
    // MARK: - UITableView functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SetToQ", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("QuestionR") as UITableViewCell?
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"QuestionR")
        }
        cell!.textLabel?.text = questions[indexPath.row].qText
        return cell!
    }
}
