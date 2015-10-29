//
//  Set.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/20/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
/**
    Database class
**/
class Set1{
    var pid = 0
    var name = ""
    var topic = ""
    var privat = true  //'private' is a keyword
    
    init(pid:Int, name:String, topic:String, privat:Bool){
        self.pid = pid
        self.name = name
        self.topic = topic
        self.privat = privat
    }
}