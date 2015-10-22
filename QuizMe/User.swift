//
//  User.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/19/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
/**
    Database Class
**/
class User{
    var uid = 0
    var name = ""
    var password = ""
    
    init(uid: Int, name: String, password: String){
        self.uid = uid
        self.name = name
        self.password = password
    }
}
