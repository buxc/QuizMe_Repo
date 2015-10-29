//
//  NSTimerWrapper.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/28/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import Foundation
/**
    Having NSTimer be a value in a dictionary wasn't working so wrap it to make it work
**/
class NSTimerWrapper{
    var timer = NSTimer()
    
    init(timer:NSTimer){
        self.timer = timer
    }
}