//
//  TimerDetailViewController.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/16/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

//button can stop timer or start timer, depending on nil value of NSTimer variable. If we stop it, we call our stopTimer button and pass it a .Cancelled enumeration (vs timer expiring in which case we call stopTimer and pass it .Completed). If the timer is started, we create a timer function to call our timerFired function. It checks the time remaining. If there is time on the clock, we call our updateTimer function, which changes the text label to be the proper time (countdown). If there is no time, we call stopTimer and pass (.Completed). Time remaining is a calculated property that is calculated by taking (currentTime + duration) which we're calling the fireDate of the notification and subtracting the timeInterval since NOW. This property is constantly accessed by our

import UIKit

class TimerDetailViewController: UIViewController {
    weak var timerModel: TimerModel!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    var timer: NSTimer?
    var notification: UILocalNotification?
    var timeRemaining: NSInteger {
        //if notification.fireDate is nil, return 0
        guard let fireDate = notification?.fireDate else {
            return 0
        }
        let now = NSDate()
        return NSInteger(round(fireDate.timeIntervalSinceDate(now)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = timerModel.name
        countdownLabel.text =  timerModel.durationText
        timerModel.addObserver(self, forKeyPath: "duration", options: .New, context: nil)
        timerModel.addObserver(self, forKeyPath: "name", options: .New, context: nil)
    }
    
    deinit {
        timerModel.removeObserver(self, forKeyPath: "duration")
        timerModel.removeObserver(self, forKeyPath: "name")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "duration" {
            countdownLabel.text =  timerModel.durationText
        }
        else if keyPath == "name" {
            title = timerModel.name
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    @IBAction func buttonWasPressed(sender: AnyObject) {
        if let _ = timer {
            //timer is not nil, it is running and button was pressed. Stop the timer.
            stopTimer(.Cancelled)
        }
        else {
            //time isn't running and the button has been pressed. we need to start it.
            startTimer()
        }
    }
    
    func startTimer() {
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.setHidesBackButton(true, animated: true)
        startStopButton.setTitle("Stop", forState: .Normal)
        startStopButton.setTitleColor(.redColor(), forState: .Normal)
        updateTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerDetailViewController.timerFired), userInfo: nil, repeats: true)
        
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Timer Completed"
        localNotification.fireDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(timerModel.duration))
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        //set class variable to be our localNotif, thereby executing the computed value operation.
        notification = localNotification
        updateTimer()
    }
    
    enum StopTimerReason {
        case Cancelled
        case Completed
        
//        func message() -> String {
//            switch self {
//            case .Cancelled:
//                return "Timer Cancelled."
//            case .Completed:
//                return "Timer Completed."
//            }
//        }
    }
    
    func stopTimer (reason: StopTimerReason) {
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.setHidesBackButton(false, animated: true)
        //countdownLabel.text = reason.message()
        countdownLabel.text = timerModel.durationText
        startStopButton.setTitle("Start", forState: .Normal)
        startStopButton.setTitleColor(.greenColor(), forState: .Normal)
        //since we have a weak reference to the timer, once it is invalidated, the memory is set to nil
        timer?.invalidate()
        
        if reason == .Cancelled {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        notification = nil
    }
    
    func updateTimer () {
        countdownLabel.text = timerModel.durationText
    }
    
    func timerFired() {
        if timeRemaining > 0 {
            updateTimer()
        }
        else {
            stopTimer(.Completed)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let editViewController = navigationController.topViewController as! TimerEditViewController
            editViewController.timerModel = timerModel
        }
    }
//first in first out queue vs last in first out stack
    //using cell #10, add it on the queue, using cell #11, add it on the queue. queue is now [10, 11]. use 10 first
}

extension TimerModel {
    var durationText: String {
        return String(format: "%d:%02d", duration / 60, duration % 60)
    }
}
