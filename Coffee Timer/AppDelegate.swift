//
//  AppDelegate.swift
//  Coffee Timer
//
//  Created by Karan Satia on 5/11/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit

func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print("Application has launched")
        coreDataStack.loadDefaultDataIfFirstLaunch()
        window?.tintColor = UIColor(red:0.35, green:0.72, blue:0.83, alpha:1.0)
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print ("Application received local")
        let alertController = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
                print("Application has resigned active")
        coreDataStack.save()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
                print("Application has entered background")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
                print("Application has entered foreground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
                print("Application has become active")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
                print("Application will terminate")
    }

}

