//
//  TimerListTableViewController.swift
//  Coffee Timer
//
//  Created by Karan Satia on 6/22/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

// shuffling array objects using existing array methods
extension Array {
    mutating func moveFrom(source: Int, toDestination destination: Int) {
        //this returns a generic object
        let object = removeAtIndex(source)
        insert(object, atIndex: destination)
    }
}


import UIKit
import CoreData

class TimerListTableViewController: UITableViewController {
    
//    var coffeeTimers: [TimerModel]!
//    var teaTimers: [TimerModel]!

    var userReorderingCells = false
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "TimerModel")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "type", ascending: true),
            NSSortDescriptor(key: "displayOrder", ascending: true)]
        
        let moc = AppDelegate().coreDataStack.managedObjectContext
        // using type as the section name splits our data into tea and coffee
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "type", cacheName: nil)
        controller.delegate = self
        return controller
    } ()
    
    // Int enumeration types increment if you don't specify a value, so Tea = 1 and numberofsections = 2
    enum TableSection: Int {
        case Coffee = 0
        case Tea
        case NumberOfSections
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*coffeeTimers = [
            TimerModel(name: "Colombian", duration: 240, type: .Coffee), TimerModel(name: "Mexican", duration: 200, type: .Coffee)
        ]
        
        teaTimers = [
            TimerModel(name: "Green Tea", duration: 400, type: .Tea), TimerModel(name: "Oolong", duration: 400, type: .Tea), TimerModel(name: "Darjeeling", duration: 240, type: .Tea) ] */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print ("Error fetching: \(error)")
        }
        
        self.navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        
        // this only works because are editing VC is a modal segue. If it's a push/pop segue, it has been popped from the navigation stack and will actually be nil (no longer in memory). If it's modal, the "VC stays in memory".
        // Rule of thumb is that if a parent VC -> another VC and both belong to the same NavCtrlr, use a Push segue. 
        // If the VCs don't belong to the same navigation controller, use a Modal. Original VC (Nav Controller holding the tableview in this case) is responsible for dismissing the modally pushed VC (editVC, in this case). The "done" button belonging to the navCtrl successfully dismisses the presented editVC.
        
        guard presentedViewController != nil else {return}
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return TableSection.NumberOfSections.rawValue
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects ?? 0
        
//        if section == TableSection.Coffee.rawValue {
//            return coffeeTimers.count
//        }
//        else {
//            return teaTimers.count
//        }
    }
    
    func timerModelFromIndexPath(indexPath: NSIndexPath) -> TimerModel {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! TimerModel
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure cell with a closure, referencing self within the closure
        let timerModel: TimerModel = {
            return timerModelFromIndexPath(indexPath)
        } ()
        
        let text = timerModel.name
        if let textLabel = cell.textLabel {
            textLabel.text = text
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // guard statement saying that we must be in editing mode in order to segue. If we're not in editing and we selected a row, that means that we are trying to get to the detail VC which will simply let control flow cascade to the performSegue function.
        // If we ARE in editing mode, we continue into our code and perform the proper segue after selecting the cell
        // With this guard statement, if the bool expression is false, it executes the else block.
        guard tableView.editing else{return}
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("editDetail", sender: cell)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == TableSection.Coffee.rawValue {
            return "Coffees"
        } else {
            return "Teas"
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
        let timer = timerModelFromIndexPath(indexPath)
        timer.managedObjectContext?.deleteObject(timer)
//     // Delete the row from the data source
//        let row = indexPath.row
//        if indexPath.section == TableSection.Coffee.rawValue {
//            coffeeTimers.removeAtIndex(row)
//        }
//        else {
//            teaTimers.removeAtIndex(row)
//        }
//        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        }
//     else if editingStyle == .Insert {
//     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    //data source method that
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        userReorderingCells = true
        //get the section and the model contained in the section
        
        let sectionInfo = fetchedResultsController.sections?[fromIndexPath.section]
        // now we have an array of objects from core data based on section
        var objectsInSection = sectionInfo?.objects ?? []
        objectsInSection.moveFrom(fromIndexPath.row, toDestination: toIndexPath.row)
        
        //models are in correct order, now we must update displayOrder to match new ordering
        for i in 0..<objectsInSection.count {
            let model = objectsInSection[i] as! TimerModel
            model.displayOrder = Int32(i)
        }
        
        userReorderingCells = false
        AppDelegate().coreDataStack.save()
        
//        if fromIndexPath.section == TableSection.Coffee.rawValue {
//            coffeeTimers.moveFrom(fromIndexPath.row, toDestination: toIndexPath.row)
//        }
//        else {
//            teaTimers.moveFrom(fromIndexPath.row, toDestination: toIndexPath.row)
//        }
     }

    //this delegate method actually tells the table view if the move being attempted is allowed. If it's allowed, we return the index path the cell was being moved to. After this, moveRowAtIndexPath, toIndexPath is called. This is a datasource method.
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        // we're trying to move the cell within the same section (allowed)
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }
        
        // not allowed, so we just return the index path of the last item in the section. Tea is below, so if we're trying to move to the below section, we should set our "border" to be the bottom of the coffee section (aka count-1)
        if sourceIndexPath.section == TableSection.Coffee.rawValue {
            //return NSIndexPath(forItem: coffeeTimers.count - 1, inSection: TableSection.Coffee.rawValue)
            let sectionInfo = fetchedResultsController.sections?[TableSection.Coffee.rawValue]
            let numberOfCoffeeTimers = sectionInfo?.numberOfObjects ?? 0
            return NSIndexPath(forItem: numberOfCoffeeTimers - 1, inSection: 0)
        }
        // not allowed, so we return the index of the top item in the tea section. If we're trying to move tea to the ABOVE SECTION of coffee, we should default to the top of the tea list (can't go past the top, think of it as a border)
        else {
            return NSIndexPath(forItem: 0, inSection: TableSection.Tea.rawValue)
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // cast object that triggered segue event to be what we know as a tableviewcell
        if let cell = sender as? UITableViewCell {
        // grab the index path of the cell from the appropriate section
        let indexPath = tableView.indexPathForCell(cell)
        
        // if the indexPath doesn't have a nil row, continue into conditional execution
            
            let timerModel = timerModelFromIndexPath(indexPath!)
            
            if segue.identifier == "pushDetail" {
                let detailViewController = segue.destinationViewController as! TimerDetailViewController
                detailViewController.timerModel = timerModel }
                
            else if segue.identifier == "editDetail" {
                let navigationController = segue.destinationViewController as! UINavigationController
                let editViewController = navigationController.topViewController as! TimerEditViewController
                editViewController.timerModel = timerModel
                editViewController.delegate = self }
        }
            
            else if let _ = sender as? UIBarButtonItem {
                if segue.identifier == "newTimer" {
                    let navigationController = segue.destinationViewController as! UINavigationController
                    let editViewController = navigationController.topViewController as! TimerEditViewController
                    editViewController.creatingNewTimer = true
                    
                    let moc = AppDelegate().coreDataStack.managedObjectContext
                    editViewController.timerModel = NSEntityDescription.insertNewObjectForEntityForName("TimerModel", inManagedObjectContext: moc) as! TimerModel
                    editViewController.delegate = self
                }
            }
    }
    

    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.copy(_:)) {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        let timerModel: TimerModel = {
            return timerModelFromIndexPath(indexPath)
        } ()
        
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = timerModel.name
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "pushDetail" {
            if tableView.editing {
                return false
            }
        }
        return true
    }
    
}


// DELEGATE METHODS

extension TimerListTableViewController: TimerEditViewControllerDelegate {
    func timerEditViewControllerDidCancel(viewController: TimerEditViewController) {
        if viewController.creatingNewTimer {
            AppDelegate().coreDataStack.managedObjectContext.deleteObject(viewController.timerModel)
        }
    }
    
    func timerEditViewControllerDidSave(viewController: TimerEditViewController) {
        let _ = try? AppDelegate().coreDataStack.managedObjectContext.save()
    }
}
    /*
        let model = viewController.timerModel
        let type = model.type
        if model.name!.characters.count > 0 {
        if type == .Coffee {
            if !coffeeTimers.contains(model) {
                coffeeTimers.append(model)
            }
            // our editVC can both add new beverages or edit existing ones. If we edit a beverage type from tea to coffee, we need to add it to our coffee array and remove it from the tea array. We filter for our model item and return a boolean - if our bool evaluates to false, it means that it DOES exist in our array, and we "filter" it out. If the boolean evaluates to true, it means that it DOESN'T exist in our array (item != model means none of the array members are equal to our model) and we leave it alone.
            
            teaTimers = teaTimers.filter( { (item) -> Bool in
                return item != model})
    }
        else {
            if !teaTimers.contains(model) {
                teaTimers.append(model)
        }
        
        coffeeTimers = coffeeTimers.filter( { (item) -> Bool in
            return item != model})
            }}}
}*/

extension TimerListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // begin updating tableView when our fetched results are starting to come in
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        // make sure we aren't reordering cells. If we are, exit immediately.
        guard userReorderingCells == false else {return}
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        guard userReorderingCells == false else {return}
    
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
        
    }


}
