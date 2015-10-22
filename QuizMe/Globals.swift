//
//  Globals.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/21/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
/**
    Global variables and functions
**/
let EXTERNAL_IP = "http://108.183.44.149"
let CREATE_LOGIN_PHP = "\(EXTERNAL_IP)/QuizMe/createLogin.php"
let TEST_PHP = "\(EXTERNAL_IP)/QuizMe/test.php"

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