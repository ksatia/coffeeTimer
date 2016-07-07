//
//  TimerModel.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/11/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import Foundation

class TimerModel: NSObject {
    enum TimerType {
        case Coffee
        case Tea
    }
    
    var type: TimerType
    
    //allows properties to be dispatched using objc runtime. The code can then be accessed by objective-c methods. Happens most often when creating swift subclass of objc base class.
    dynamic var name = ""
    dynamic var duration = 0
    
    
    init(name: String, duration: Int, type: TimerType) {
        self.name = name
        self.duration = duration
        self.type = type
        super.init()
    }

    override var description: String {
            return "TimerModel(\(name))"
    }
        
}

