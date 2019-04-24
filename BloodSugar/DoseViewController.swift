//
//  DoseViewController.swift
//  BloodSugar
//
//  Created by Jenny Swift on 17/4/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import UIKit
import CoreData

class DoseViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    @objc
    func insertNewFigure(name: String, value: Double) {
        let context = self.fetchedResultsController.managedObjectContext
        let newFigure = Figure(context: context)
        
        newFigure.name = name
        newFigure.value = value
        
        print("inserting...")
        
        saveContext(context: context)
    }
    
    func saveContext(context: NSManagedObjectContext) -> Void {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    
    override func viewDidLoad() {
        print("dose view loaded")
        super.viewDidLoad()
        
        updateValues()
        
        insertStartingFigures()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func insertStartingFigures() {
        insertNewFigure(name: "bloodSugarStart", value: 7.4)
        insertNewFigure(name: "bloodSugarGoal", value: 3.8)
        insertNewFigure(name: "netCarbsPerInsulinUnit", value: 16.4)
        insertNewFigure(name: "totalMinutesWalking", value: 0.0)
        
        insertNewFigure(name: "totalNetCarbs", value: 0.0)
        insertNewFigure(name: "totalInsulin", value: 11.0)
        
        insertNewFigure(name: "correctionFactor", value: 3.0)
        insertNewFigure(name: "bloodSugarEnd", value: 3.8)
    }
    
    var fetchedResultsController: NSFetchedResultsController<Figure> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Figure> = Figure.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 10
        
        // Edit the sort key as appropriate.
                let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
                fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
                let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Dose")
                aFetchedResultsController.delegate = self
                _fetchedResultsController = aFetchedResultsController
        
                do {
                    try _fetchedResultsController!.performFetch()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Figure>? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        updateValues()
        calculateDose()
//        reloadData()
    }
    
    func updateValues() {
//        totalNetCarbs = Store.totalNetCarbs
//
////        totalNetCarbsLabel.text = Helpers.decimalToString(decimal: totalNetCarbs)
//        totalNetCarbsLabel.text = String(round(totalNetCarbs))
//
//
//        bloodSugarNowLabel.text = String(bloodSugarNow)
//        bloodSugarGoalLabel.text = String(bloodSugarGoal)
//        minutesWalkingLabel.text = String(minutesWalking)
//        carbInsulinRatioLabel.text = String(carbInsulinRatio)
//        totalInsulinLabel.text = String(totalInsulin)
    }
    
    func calculateDose() {
//        var dose = bloodSugarNow - bloodSugarGoal
//        dose /= correctionFactor
//
//        dose += (totalNetCarbs / carbInsulinRatio)
//
//        dose -= (minutesWalking / 60.0)
//
//        dose -= totalInsulin
//
//        self.title = String(Helpers.roundDouble(dose, x: 10))
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //        let event = fetchedResultsController.object(at: indexPath)
        let figure = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withFigure: figure)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDoseDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! DoseDetailViewController
            
            if let sender = sender {
                var indexPath = sender as! IndexPath
                
                controller.detailItem = fetchedResultsController.object(at: indexPath)
                
                print(fetchedResultsController.object(at: indexPath))
                
//                if indexPath.row == 0 {
//                    controller.detailItem = "BS Now"
//                }
//                if indexPath.row == 1 {
//                    controller.detailItem = "BS Goal"
//                }
//                if indexPath.row == 2 {
//                    controller.detailItem = "Net Carbs"
//                }
//                if indexPath.row == 3 {
//                    controller.detailItem = "Insulin"
//                }
//                if indexPath.row == 4 {
//                    controller.detailItem = "C/I"
//                }
//                if indexPath.row == 5 {
//                    controller.detailItem = "Minutes Walking"
//                }
            }
            
            
//                controller.delegate = self
//                controller.detailItem = object
//            controller.title = "insulin"
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "showDoseDetail", sender: indexPath)
//    }

    func configureCell(_ cell: UITableViewCell, withFigure figure: Figure) {
        cell.textLabel!.text = figure.name
        cell.detailTextLabel!.text = String(figure.value)
    }


    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print("update")
            //            if let food = anObject as? Food {
            //                if let indexPath = indexPath {
            //                    if let cell = tableView.cellForRow(at: indexPath) {
            //                        configureCell(cell, withFood: food)
            //                        updateFood()
            //                    }
            //
            //                }
            //
        //            }
        default:
            return
        }
        
    }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
        
        
        func reloadData() {
            //        self.tableView.reloadData()
            //        updateLabels()
        }


    

    
    

}
