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
        title = timerModel.coffeeName
        durationLabel.text = "\(timerModel.duration / 60) min \(timerModel.duration % 60) sec"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
