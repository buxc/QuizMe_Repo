//
//  Question.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/19/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
/**
    Database class
**/
class Question{
    var qid = 0
    var qText = ""
    var aText = ""
    var choices : [String]?
    
    init(qid:Int, qText:String, aText:String, choices:[String]?){
        self.qid = qid
        self.qText = qText
        self.aText = aText
        self.choices = choices
    }
}