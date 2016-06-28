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
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    var timer: NSTimer?
    var timeRemaining = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = timerModel.name
        durationLabel.text = "\(timerModel.duration / 60) min \(timerModel.duration % 60) sec"
        countdownLabel.text = "Timer not started."
    }

    @IBAction func buttonWasPressed(sender: AnyObject) {
        if let _ = timer {
            //timer is not nil, it is running and button was pressed. Stop the timer.
            stopTimer(.Cancelled)
        }
        else {
            //time isn't running and the button has been pressed. we need to start it.
            stopTimer(.Completed)
        }
    }
    
    func startTimer() {
        navigationItem.setHidesBackButton(true, animated: true)
        startStopButton.setTitle("Stop", forState: .Normal)
        timeRemaining = timerModel.duration
        countdownLabel.text = String(format: "%d:02%d", timeRemaining/60, timeRemaining%60)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerDetailViewController.timerFired), userInfo: nil, repeats: true)
    }
    
    enum StopTimerReason {
        case Cancelled
        case Completed
        
        func message() -> String {
            switch self {
            case .Cancelled:
                return "Timer Cancelled."
            case .Completed:
                return "Timer Completed."
            }
        }
    }
    
    func stopTimer (reason: StopTimerReason) {
        navigationItem.setHidesBackButton(false, animated: true)
        countdownLabel.text = reason.message()
        startStopButton.setTitle("Start", forState: .Normal)
        timer?.invalidate()
        timer = nil
    }
    
    func timerFired() {
        if timeRemaining > 0 {
            countdownLabel.text = String(format: "%d:%02d", timeRemaining/60, timeRemaining%60)
            
        }
        else {
            stopTimer(.Completed)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//first in first out queue vs last in first out stack
    //using cell #10, add it on the queue, using cell #11, add it on the queue. queue is now [10, 11]. use 10 first
}
