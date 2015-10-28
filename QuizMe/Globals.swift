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

var UID = 0
var USERNAME = ""
var running_question_timers = [Int : Bool]() //tells you whether or not a timer has started for particular question
var running_set_timers = [Int : Bool]()//tells you whether or not a timer has started for particular set

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

