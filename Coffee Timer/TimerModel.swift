//
//  TimerModel.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/11/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import Foundation

class TimerModel: NSObject {
    var name = ""
    var duration = 0
    
    init(name: String, duration: Int) {
        self.name = name
        self.duration = duration
        super.init()
        
    }

    override var description: String {
            return "TimerModel(\(name))"
    }
        
}

