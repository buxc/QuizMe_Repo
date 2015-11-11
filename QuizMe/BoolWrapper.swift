//
//  BoolWrapper.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 11/9/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
/**
    Used in RecentVC
    Allows Bools to be passed around by reference
**/
class BoolWrapper{
    var value : Bool
    
    init(val:Bool){
        self.value = val
    }
}
