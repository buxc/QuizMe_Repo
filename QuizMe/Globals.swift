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
//MARK: - URLs
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
let GET_SETS_PHP = "\(EXTERNAL_IP)/QuizMe/getSets.php"
let CREATE_SET_PHP = "\(EXTERNAL_IP)/QuizMe/createSet.php"
let GET_FAVORITES_PHP = "\(EXTERNAL_IP)/QuizMe/getFavorites.php"
//MARK: - Global variables
var UID = 0
var DEVICE_TOKEN = ""
var USERNAME = ""
var gCountQueuedForPush = 0
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
//MARK: - Global functions
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
/**
 AlertUser
 displays an alertbox showing passed in message with an "ok" button
 
 @arg message to be displayed to user
 **/
func alertUser(message:String,you:UIViewController){
    let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    you.presentViewController(alert, animated: true, completion: nil)
}
/**
 Extension to UIColor granting a function that gives a color from a hex string
**/
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
/**
    FormatStringRemoveQuotes
**/
func formatStringRemoveQuotes(string:String) ->String{
    
    return string.stringByReplacingOccurrencesOfString("'", withString: "")
}
/**
 presentConfirmBox
 presents a confirmbox to the user
 PARAMETERS:
 message shown in box
 a void function with no parameters to perfrom lest the user clicks 'Yes'
 viewcontroller operating in(just pass in self)
 **/
func presentConfirmBox(message:String, fxn : (),you:UIViewController){
    let confirmBox = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.Alert)
    confirmBox.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
        fxn
    }))
    
    confirmBox.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        return
    }))
    you.presentViewController(confirmBox, animated: true, completion: nil)
}
