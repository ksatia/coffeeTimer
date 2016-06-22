//
//  TimerListTableViewController.swift
//  Coffee Timer
//
//  Created by Karan Satia on 6/22/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit

class TimerListTableViewController: UITableViewController {
    
    var coffeeTimers: [TimerModel]!
    var teaTimers: [TimerModel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coffeeTimers = [
            TimerModel(name: "Colombian", duration: 240), TimerModel(name: "Mexican", duration: 200)
        ]
        
        teaTimers = [
            TimerModel(name: "Green Tea", duration: 400), TimerModel(name: "Oolong", duration: 400), TimerModel(name: "Darjeeling", duration: 240)
        ]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return coffeeTimers.count
        }
        else {
            return teaTimers.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure cell with a closure, referencing self within the closure
        let timerModel: TimerModel = {
            if indexPath.section == 0 {
                return self.coffeeTimers[indexPath.row]
            }  else {
                return self.teaTimers[indexPath.row]
            }
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
        if section == 0 {
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
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // cast object that triggered segue event to be what we know as a tableviewcell
        if let cell = sender as? UITableViewCell {
        // grab the index path of the cell from the appropriate section
        let indexPath = tableView.indexPathForCell(cell)
        
        // if the indexPath doesn't have a nil row, continue into conditional execution
        if let row = indexPath?.row {
            
            let timerModel: TimerModel = {
                if indexPath?.section == 0 {
                    return self.coffeeTimers[row]
                } else { return self.teaTimers[row]
                }
            } ()
            
            if segue.identifier == "pushDetail" {
                let detailViewController = segue.destinationViewController as! TimerDetailViewController
                detailViewController.timerModel = timerModel }
            else if segue.identifier == "editDetail" {
                let navigationController = segue.destinationViewController as! UINavigationController
                let editViewController = navigationController.topViewController as! TimerEditViewController
                editViewController.timerModel = timerModel }
        }
    }
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

