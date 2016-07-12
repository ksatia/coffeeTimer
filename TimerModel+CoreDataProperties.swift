//
//  TimerModel+CoreDataProperties.swift
//  Coffee Timer
//
//  Created by Karan Satia on 7/8/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimerModel {

    // has to be Objc in order to use with Managed Variables (type)
    @objc enum TimerType: Int32 {
        case Coffee = 0
        case Tea
    }

    @NSManaged var name: String?
    @NSManaged var duration: Int32
    @NSManaged var type: TimerType
    @NSManaged var displayOrder: Int32
    

}
