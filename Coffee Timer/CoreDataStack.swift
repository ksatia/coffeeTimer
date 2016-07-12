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
        catch {
            print("Unresolved error adding persistent store: \(error)")
        }
        return coordinator
    } ()
    
    //Use this function to get our documents directory singleton URL.
    private func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
    }
    
    // we create a Managed Object Model (MOM) based on a file that will be created. The file is a compiled version of our core data schema (xcdatamodeld), which we pass off to our MOM. This is how our stack knows how to configure our managed objects (property type, property values, entity names, etc). Our file extension momd (managed object model document) represents a compiled xcdatamodeld file (which represents our schema).
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("CoffeeTimer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    func loadDefaultDataIfFirstLaunch() {
        let key = "hasLaunchedBefore"
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey(key)
        
        //defer puts off execution until the program leaves this scope -> aka when the function ends
        defer {
            save()
        }
        
        // if this is our first time launching
        if launchedBefore == false {
            // then we are launching now for the first time, and we can switch our Bool to true for "hasLaunchedBefore"
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: key)
            for i in 0..<5 {
                let model = NSEntityDescription.insertNewObjectForEntityForName("TimerModel", inManagedObjectContext: managedObjectContext) as! TimerModel
                
                switch i {
                case 0:
                    model.name = NSLocalizedString("Colombian", comment: "Colombian coffee name")
                    model.duration = 240
                    model.type = .Coffee
                case 1:
                    model.name = NSLocalizedString("Mexican", comment: "Mexican coffee name")
                    model.duration = 200
                    model.type = .Coffee
                case 2:
                    model.name = NSLocalizedString("Green Tea", comment: "Green tea name")
                    model.duration = 400
                    model.type = .Tea
                case 3:
                    model.name = NSLocalizedString("Earl Gray", comment: "Earl Gray tea name")
                    model.duration = 240
                    model.type = .Tea
                default:
                    model.name = NSLocalizedString("Chamomile", comment: "Chamomile tea name")
                    model.duration = 240
                    model.type = .Tea
                }
                
                model.displayOrder = Int32(i)
            }
        }
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        }
        catch {
            print("error saving: \(error)")
        }
    }
}

/*  Core Data Process =
        1. Create schema. This is turned into a managed object model document (momd) that is fed to an instance of the managed object model. This configures managed object properties and values.
        2. Create a persistent store coordinator. Feed it a Managed Object Model so that it has information about our objects that it can then use to configure a persistent storage type (SQLite in our case). We locate our application file directory, specify the file we will be saving to, and pass that file URL to our persistent store coordinator during configuration.
        3. Create a managed object context which manages our instances of managed objects. The MOC is responsible for lazily loading property values for managed objects. It is also responsible for memory faulting (unloading managed object instances back to the disk to save memory).
        4. Query the PSC and use managed objects, which are handled (in terms of retrieval and memory) by the managed object context. 


 NOTE ON ERROR HANDLING
 when writing a function that may throw errors, create it like this ->
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
 

NOTE ON CONSTANTS
 Class Cat {
    enum Temperament {
        case Angry
        case Sad
        case Friendly
    }
 
    var name: String
    var temperament: Temperament
 }
 
 Class RandomVC: UIViewController {
 
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
