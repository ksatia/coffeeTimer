//
//  TimerModel.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/11/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import Foundation

class TimerModel: NSObject {
    var coffeeName = ""
    var duration = 0
    
    init(coffeeName: String, duration: Int) {
        self.coffeeName = coffeeName
        self.duration = duration
        super.init()
        
    }

    override var description: String {
            return "TimerModel(\(coffeeName))"
    }
        
}

