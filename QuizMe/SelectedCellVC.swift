//
//  SelectedCellVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/26/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class SelectedCellVC: UIViewController {

    var question = Question()
    var timer = NSTimer()
    var state = "q"
    
    @IBOutlet var tvText: UITextView!
    @IBOutlet var btSaveChanges: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tvText.text = question.qText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nextView = segue.destinationViewController as? TimerVC{
            nextView.question = question
            nextView.timer = timer
        }
    }
    @IBAction func btFlip_OnClick(sender: AnyObject) {
        if state == "q"{
            tvText.text = question.aText
            state = "a"
        }
        else{
            tvText.text = question.qText
            state = "q"
        }
    }
    
    @IBAction func btSaveChanges_OnClick(sender: AnyObject) {
    }

}
