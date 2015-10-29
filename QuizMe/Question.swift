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
class Question: Hashable,Equatable{
    var hashValue : Int {
        get{return qid}
    }
    var qid = 0
    var qText = ""
    var aText = ""
    var choices : [String]?
    
    init(){
        qid = 0
        qText = ""
        aText = ""
        choices = nil
    }
    
    init(qid:Int, qText:String, aText:String, choices:[String]?){
        self.qid = qid
        self.qText = qText
        self.aText = aText
        self.choices = choices
    }
    
}
// MARK: Equatable
    func ==(lhs: Question, rhs: Question) -> Bool{
    return lhs.qid == rhs.qid
}
// MARK: Hashable
//public var hashValue: Int { get }