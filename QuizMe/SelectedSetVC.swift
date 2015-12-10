//
//  SelectedSetVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 12/9/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class SelectedSetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Data members
    var questions = [Question]()
    var set : QmSet?
    //MARK: - IBOutlets
    @IBOutlet var tvTable: UITableView!
    
    //MARK: - UITableView functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = set?.name
        getQuestions(set!.pid)
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
        if let nextView = segue.destinationViewController as? BrowseQuestionVC{
            nextView.question = questions[indexPath!.row]
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
    
    // MARK: - UITableView functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Question") as UITableViewCell?
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Question")
        }
        cell!.textLabel?.text = questions[indexPath.row].qText
        return cell!
    }
        // MARK: - General
}
