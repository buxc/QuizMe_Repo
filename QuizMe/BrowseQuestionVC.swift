//
//  BrowseQuestionVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 12/10/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class BrowseQuestionVC: UIViewController {

    // MARK: - Data members
    var question : Question?
    var state = "q"
    // MARK: - IBOutlets
    @IBOutlet var tvTextView: UITextView!
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tvTextView.text = question?.qText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Button presses
    @IBAction func btFlip_OnClick(sender: AnyObject) {
        if state == "q"{
            tvTextView.text = question?.aText
            state = "a"
        }else{
            tvTextView.text = question?.qText
            state = "q"
        }
    }
}
