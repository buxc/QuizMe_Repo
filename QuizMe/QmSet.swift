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
class QmSet{    //'Set' is a keyword
    var pid = 0
    var name = ""
    var topic = ""
    var privat = true  //'private' is a keyword
    var creator = 0
    
    init(pid:Int, name:String, topic:String, privat:String, cr:Int){
        self.pid = pid
        self.name = name
        self.topic = topic
        self.creator = cr
        if privat == "0"{
            self.privat = false
        }
        else{
            self.privat = true
        }
    }
}