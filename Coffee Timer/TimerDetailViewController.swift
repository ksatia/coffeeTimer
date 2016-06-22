//
//  TimerDetailViewController.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/16/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit

class TimerDetailViewController: UIViewController {
    @IBOutlet weak var durationLabel: UILabel!
    var timerModel: TimerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = timerModel.name
        durationLabel.text = "\(timerModel.duration / 60) min \(timerModel.duration % 60) sec"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//first in first out queue vs last in first out stack
    //using cell #10, add it on the queue, using cell #11, add it on the queue. queue is now [10, 11]. use 10 first
}
