//
//  CoreDataStack.swift
//  Coffee Timer
//
//  Created by Karan Satia on 6/30/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import CoreData

//MOC can load managed objects from disk, but will only load property values when first accessed. This saves application memory. If memory grows too much, the MOC can unload property values back onto the disk, which is known as 'faulting'.
//PSC (persistent store coordinator) is the next part of our stack that works with the SQLite DB backing core data. PSC helps create the database and query it, MOC saves to in-memory from disk (or faults RAM values back to disk) and manages all other faulting behaviors.
//MOM is the next stack layer. It lays out details of the objects being managed in our object graph.
class CoreDataStack {
    lazy var managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    } ()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        //create our DB store by using the documents directory (in-memory DB) -> remember that we run in a sandboxed environment and so can only access our own in-memory file structure. We get the main documnts directory for our application and append the DB name to it.
        let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("CoffeeTimer.sqlite")
        
        //use do statement and hope for success, otherwise implement error handling. Here we are configuring the coordinator by specifying a store type (SQLite), and pointing to our DB directory stored in RAM.
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options:nil)
        }
            /*  when writing a function that may throw errors, create it like this ->
                    enum AwfulError: ErrorType {case Bad case Worse case Terrible}
                    func doSomethingThatMayThrowErrors() throws -> returnType {if something happens {throw AwfulError.Bad} }
                    do {let result = try object.doSomethingThatMayThrowErrors()}
                    catch AwfulError.Bad {deal with error}
             
                when using APIs, some have error handling baked in.
                OLD -> init?(fileURL path:String, encoding enc: UInt, error error:NSErrorPointer)
                        The initialiation was seen as optional since it may fail
                NEW -> init(fileURL path:String, encoding enc: UInt)
                WHEN USING NEW SIGNATURE ->
                    do {let string = try NSString(fileURL:"/usr/documents/whatever", encoding:NSUTF8StringEncoding)
                    catch let error as NSError {print(error.localizedDescription)}
                -> We cast our constant, error, as an NSError instance and print its description. Easy.
             */
        catch {
            print("Unresolved error adding persistent store: \(error)")
        }
        return coordinator
    } ()
    
    //Use this function to get our documents directory singleton URL.
    private func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
    }
    
    // we create a MOM based on a file that will be created. The file is a compiled version of our core data schema (xcdatamodeld), which we pass off to our MOM. This is how our stack knows how to configure our managed objects (property type, property values, entity names, etc). Our file extension momd (managed object model document) represents a compiled xcdatamodeld file (which represents our schema).
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("CoffeeTimer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
}

/* 
 A QUICK ASIDE ON SWIFT CONSTANTS
 
 
 Lets say that we have the following code
 
 Class Cat {
 
    enum Temperament {
        case Angry
        case Sad
        case Friendly
    }
 
    var name: String
    var temperament: Temperament
 }
 
 Class RandomAccessVS: UIViewController {
 
 func someFunc {

 let coraline = Cat(name:"Coraline", temperament: .Angry)
 
 //THIS WILL NOT WORK
 coraline = Cat(name:"Henry", temperament:.Sad)]
 
 //THIS WILL WORK
 coraline.temperament = .Friendly
 
 //WE ARE ABLE TO CHANGE VALUES OF THE OBJECT REFERRED TO BY CORALINE, BUT WE CANNOT CHANGE WHAT CORALINE REFERS TO.
 }
 }
 */
