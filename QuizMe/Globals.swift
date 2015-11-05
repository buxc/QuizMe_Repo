//
//  Globals.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/21/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
import UIKit
/**
    Global variables and functions
**/
let EXTERNAL_IP = "http://108.183.44.149"
let QUERY_USERNAME_PHP = "\(EXTERNAL_IP)/QuizMe/queryUsername.php"
let CREATE_USER_PHP = "\(EXTERNAL_IP)/QuizMe/createUser.php"
let CREATE_QUESTION_PHP = "\(EXTERNAL_IP)/QuizMe/createQuestion.php"
let GET_QUESTIONS_PHP = "\(EXTERNAL_IP)/QuizMe/getQuestions.php"
let CHECK_ANSWER_PHP = "\(EXTERNAL_IP)/QuizMe/checkAnswer.php"
let GET_ANSWER_PHP = "\(EXTERNAL_IP)/QuizMe/getAnswer.php"
let REGISTER_QUESTION_FOR_PUSH_PHP = "\(EXTERNAL_IP)/QuizMe/registerQuestionForPush.php"
let GET_REGISTERED_QUESTIONS_PHP = "\(EXTERNAL_IP)/QuizMe/getRegisteredQuestions.php"
let STOP_ASKING_PHP = "\(EXTERNAL_IP)/QuizMe/stopAsking.php"
let DELETE_QUESTION_PHP = "\(EXTERNAL_IP)/QuizMe/deleteQuestion.php"

var UID = 0
var device_token = ""
var USERNAME = ""
var running_question_timers = [Int : Bool]() //tells you whether or not a timer has started for particular question
var running_set_timers = [Int : Bool]()//tells you whether or not a timer has started for particular set
let notification_key = "switch_visibility"
let notification_key_login = "switch_login_visibility"
let notification_key_reply = "user_answered"
let notification_key_seeAnswer = "see answer"
let category_id = "category"
let notification_result = "result"
let notification_question = "question"
let notification_answer = "answer"
let wrong_cat_id = "wrong_cat"
let okCat_id = "okcat"
/**
Get_Request

Encapsulates redundant code that sets up an NSMutableURLRequest.
Request method is POST. Saves a few lines of code.

@param php POST string containing arguments to send to script
@param string of desired url
@return NSMutableURLRequest object to call NSURLSession.sharedSession().dataTaskWithRequest(request) on
**/
func getRequest(requestString : String, urlString : String) -> NSMutableURLRequest{
    let url = NSURL(string:urlString)
    let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    request.HTTPBody = requestString.dataUsingEncoding(NSUTF8StringEncoding)
    return request
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
