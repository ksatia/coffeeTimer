//
//  ViewController.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/11/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //implicitly unwrapped optional so it can be nil. We are expecting it to be initialized.
    //property observer. if we set the value of timerModel, we can do something right before it sets and right after. Avoid coupling code where we directly call a method. If we no need to call the method, don't track down where we passed a message to it. Just delete from here.
    
    var timerModel: TimerModel! {
        willSet(newModel) {
            print("About to change to \(newModel)")
        }
        didSet {
            updateUserInterface()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Root"
        setupModel()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    func setupModel() {
        timerModel = TimerModel (coffeeName: "Colombian Coffee", duration: 240)
    }
    
    func updateUserInterface () {

    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Preparing for segue with identifier:\(segue.identifier)")
        if segue.identifier == "pushDetail" {
            let viewController = segue.destinationViewController
                as! TimerDetailViewController
            viewController.timerModel = timerModel
        }
        
        else if segue.identifier == "editDetail" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let viewController = navigationController.topViewController
                as! TimerEditViewController
            viewController.timerModel = timerModel
        }
    }
    
    
    //Using an if let statement uses an optional property and allows for conditional if the variable in question is nil
    //UINavigationController is an optional property of UIViewController, and it may not exist for a single page application. If this is the case, we can use an if let statement to potentially unwrap the optional, instead of using the implicitly unwrapped optional which can cause a crash if a nil value is encountered.
    
    /*
        
        if let nav = currentViewController.navigationController {
            nav.hidesBarsOnSwipe = true
            nav.property = value
            nav.property = value
        } 
    
        This is in contrast to doing the following - 
        currentVC.navigationController?.hidesBarsOnSwipe = true
        currentVC.navigationController?.property = value
        Here we are actually using the optional value of the nav controller and seeing if it exists. If it does, assign value to the properties.
    
    
        if we tried this and the value was nil, our program would crash. This is an implicitly unwrapped optional in use.
        currentVC.navigationController!.hidesBarsOnSwipe = true
    */
    
    
}

