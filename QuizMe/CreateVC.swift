//
//  CreateVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/19/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit
/**
    ViewController handling screen where User creates new questions
    and sets.

    *Multiple choice questions have yet to be implemented*

    *BASICALLY FINISHED*
**/
class CreateVC: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: - Database members
    var fetched = false
    var state = "q"
    var question = Question()
    var sets = [QmSet]()
    var pickedSet : QmSet?
    //MARK: - IBOutlets
    @IBOutlet var btCreateNewSet: UIButton!
    @IBOutlet var cvView: UIView!
    @IBOutlet var lbLabel: UILabel!
    @IBOutlet var tvTextView: UITextView!
    @IBOutlet var btEnter: UIButton!
    @IBOutlet var btGoBack: UIButton!
    @IBOutlet var pvSet: UIPickerView!
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        cvView.layer.borderColor = UIColor(netHex: 0x2DE2EF).CGColor
        tvTextView.becomeFirstResponder()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchEmbeddedVisibility", name: notification_key, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reFetchSets", name: "refetchSetsKey", object: nil)
        // Do any additional setup after loading the view.
        
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
    //MARK: - General
    /**
     reFetchSets
     **/
    func reFetchSets(){
        getSets()
    }
    /**
     dismissKeyboard
     Allows keyboard to disappear
    **/
    func dismissKeyboard(){
        view.endEditing(true)
    }
/**
    InputGood
    Verifies that both question and answer provided are between 1 and 50 chars long
    @return Bool
**/
    func inputGood() -> Bool{
        if tvTextView.text?.characters.count < 200                                                                                                                                                                                                       && tvTextView.text?.characters.count > 0 {
            return true
        }
        return false
    }
    
    //MARK: - UI stuff
/**
     SwitchEmbeddedVisibility
     Switches visibility of view containing new set shit
**/
    func switchEmbeddedVisibility(){
        if cvView.hidden == true{
            cvView.hidden = false
            tvTextView.editable = false
            btCreateNewSet.hidden = true
            view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        }
        else{
            cvView.hidden = true
            tvTextView.editable = true
            btCreateNewSet.hidden = false
            view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1)
        }
    }
/**
    ChangeState
    Updates user prompt for either question or answer
**/
    func changeState(){
        if state == "q"{
            question.qText = tvTextView.text
            lbLabel.text = "Enter Answer:"
            tvTextView.text = ""
            state = "a"
            tvTextView.becomeFirstResponder()
            btGoBack.hidden = false
            
        }
        else{//state == "a"
            question.aText = tvTextView.text
            lbLabel.text = "Enter Question:"
            tvTextView.text = ""
            state = "q"
            submitQuestion()
            tvTextView.becomeFirstResponder()
            btGoBack.hidden = true
        }
    }
    //MARK: - Database interaction
    /**
    SubmitQuestion
    creates question in db
    /***SINGLE QUOTES INCLUDED IN Q.TEXT OR A.TEXT WILL MAKE REQUEST FAIL**/
    **/
    func submitQuestion(){
        let qText = formatStringRemoveQuotes(question.qText)
        let pid = sets[pvSet.selectedRowInComponent(0)].pid
        let send_this = "question='\(qText)'&answer='\(question.aText)'&uid=\(UID)&setID=\(pid)"
        let request = getRequest(send_this, urlString: CREATE_QUESTION_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                alertUser("Question created!",you:self)
                NSNotificationCenter.defaultCenter().postNotificationName("setFetchedKey", object: self)
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
        sets.append(QmSet(pid: 0, name: "NONE", topic: "", privat: "1", cr: 0))//always have 'NONE' as the first option
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
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.pvSet.reloadAllComponents()
                    })
                }
                catch let e as NSError {
                    print(e)
                }
            }
        }
        task.resume()
    }
    //MARK: - Button presses
    @IBAction func btCreate_OnClick(sender: AnyObject) {
        if(!inputGood()){
            //display error
            return
        }
        changeState()
    }
    @IBAction func btGoBack_onClick(sender: AnyObject) {
        state = "q"
        lbLabel.text = "Enter Question:"
        tvTextView.text = question.qText
        tvTextView.becomeFirstResponder()
        btGoBack.hidden = true
    }
    @IBAction func btCreateNewSet_OnClick(sender: AnyObject) {
        switchEmbeddedVisibility()
    }
    
    // MARK: - UIPickerView functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sets.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sets[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, forComponent component: Int) {
        if row != 0{
            pickedSet = sets[row]
        }
    }
    //MARK: - UITextFieldDelegate functions
    /**
     Lets keyboard dissapear after typing
     **/
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
