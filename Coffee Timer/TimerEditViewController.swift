//
//  TimerEditViewController.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/16/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit
@objc protocol TimerEditViewControllerDelegate {
    // our parameter will be the VC that is invoking the functions. We call them from whatever object comforms to the protocol, but the functions are invoked by the TimerEditVC. We're defining the protocol within the same VC that is being passed as the parameter.
    func timerEditViewControllerDidCancel(viewController: TimerEditViewController)
    func timerEditViewControllerDidSave(viewController:TimerEditViewController)
}

class TimerEditViewController: UIViewController {
    
    var timerModel: TimerModel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var minutesSlider: UISlider!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var secondsSlider: UISlider!
    var creatingNewTimer = false
    // weak property. The tableVC (which will call the delegate functions) is actually creating the Edit VC, meaning it has a strong reference to it. If the delegate property here is strong, and we say the tableVC is acting as the delegate, then the tableVC has a strong reference to the editVC, and the editVC has a strong reference to the tableVC(the delegate)
    
    var delegate: TimerEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberOfMinutes = Int(timerModel.duration  /  60)
        let numberOfSeconds = timerModel.duration % 60
        nameField.text = timerModel.name
        updateLabelsWithMinutes(numberOfMinutes, seconds: numberOfSeconds)
        minutesSlider.value = Float(numberOfMinutes)
        secondsSlider.value = Float(numberOfSeconds)
    }

    @IBAction func doneWasPressed(sender: AnyObject) {
        //the text property on a text field is an optional string. If it returns nil, we turn it into a real value. The value that gets inserted is simply a blank string.
        timerModel.name = nameField.text ?? ""
        timerModel.duration = Int(minutesSlider.value) * 60 + Int(secondsSlider.value)
        self.delegate?.timerEditViewControllerDidSave(self)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let numberOfMinutes = Int(minutesSlider.value)
        let numberOfSeconds = Int(secondsSlider.value)
        minutesLabel.text = "\(numberOfMinutes)"
        secondsLabel.text = "\(numberOfSeconds)"
        updateLabelsWithMinutes(numberOfMinutes, seconds: numberOfSeconds)
    }
    
    func updateLabelsWithMinutes(minutes: Int, seconds: Int) {
        func pluralize(value: Int, singular: String, plural: String) -> String {
            switch value {
            case 1:
                return "1 \(singular)"
            case let pluralValue:
                return "\(pluralValue) \(plural)"
            }
        }
        
        minutesLabel.text = pluralize(minutes, singular: "minute", plural: "minutes")
        secondsLabel.text = pluralize(seconds, singular: "second", plural: "seconds")
    }
    
    
    @IBAction func cancelWasPressed(sender: AnyObject) {
        delegate?.timerEditViewControllerDidCancel(self)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
