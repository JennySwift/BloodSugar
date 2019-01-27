//
//  MasterViewController.swift
//  BloodSugar
//
//  Created by Jenny Swift on 21/1/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Outlets
   
    // MARK: - Variables
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var selectedFood: Food?
    
    // MARK: - IBActions
    @IBAction func showActionMenu(_ sender: Any) {
        let alert = UIAlertController(title: "Choose an Action", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Copy Net Carbs", style: .default, handler: { (UIAlertAction) in
            self.copyNetCarbsToClipboard()
        }))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (UIAlertAction) in
            self.reset()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion:  {
            
        })
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.delegate = self
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "showInfo" {
            let controller = (segue.destination as! UINavigationController).topViewController as! FoodInfoViewController
            controller.delegate = self
            controller.detailItem = selectedFood
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        selectedFood = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "showInfo", sender: indexPath)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let event = fetchedResultsController.object(at: indexPath)
        let food = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withFood: food)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

//    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
//        cell.textLabel!.text = event.timestamp!.description
//    }
    
    func configureCell(_ cell: UITableViewCell, withFood food: Food) {
        cell.textLabel!.text = food.name
        cell.detailTextLabel!.text = String(food.amount)
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Food> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
//        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
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
    var _fetchedResultsController: NSFetchedResultsController<Food>? = nil

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
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withFood: anObject as! Food)
                updateFood()
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withFood: anObject as! Food)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */
    
    // MARK: - Methods
    func reloadData() {
        self.tableView.reloadData()
        updateLabels()
    }
    
    func copyNetCarbsToClipboard() -> Void {
        let netCarbs = Helpers.roundValue(calculateTotalNetCarbs(), x: 1)
        UIPasteboard.general.string = Helpers.decimalToString(decimal: NSDecimalNumber(decimal: netCarbs))
        Helpers.playSound()
    }
    
    func reset() -> Void {
        if let foods = fetchedResultsController.fetchedObjects {
            for food in foods {
                food.amount = 0
            }
        }
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        updateLabels()
    }
    
    func setupNavigationBar() -> Void {
//        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
        navigationItem.leftBarButtonItem = addButton
    }
    
    func calculateTotalNetCarbs() -> Decimal {
        var total: Decimal = 0
        if let foods = fetchedResultsController.fetchedObjects {
            for food in foods {
                total += getNetCarbsForFood(food: food)
            }
        }
        return total
    }
    
    func calculateTotalCalories() -> Decimal {
        var total: Decimal = 0
        if let foods = fetchedResultsController.fetchedObjects {
            for food in foods {
                total += getCaloriesForFood(food: food)
            }
        }
        return total
    }
    
    func getCaloriesForFood(food: Food) -> Decimal {
        let value = Helpers.intToDecimal(int: food.amount) as Decimal / 100 * (food.caloriesPer100Grams as Decimal)
        return value
    }
    
    func getNetCarbsForFood(food: Food) -> Decimal {
        let value = Helpers.intToDecimal(int: food.amount) as Decimal / 100 * (food.netCarbsPer100Grams as Decimal)
        return value
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        //        let newEvent = Event(context: context)
        let newFood = Food(context: context)
        
        // If appropriate, configure the new managed object.
        //        newEvent.timestamp = Date()
        newFood.name = ""
        newFood.amount = 0
        
        saveContext(context: context)
    }
    
    func updateFood() -> Void {
        let context = fetchedResultsController.managedObjectContext
        
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
    
    // MARK: - Update methods
    func updateLabels() -> Void {
        let totalNetCarbs = Helpers.roundValue(calculateTotalNetCarbs(), x: 1)
        let totalCalories = Helpers.roundValue(calculateTotalCalories(), x: 1)
        self.title = "\(totalNetCarbs)N/C      \(totalCalories)C"
    }
}

extension MasterViewController: DetailViewControllerDelegate {
    func didUpdateFood(_ food: Food, _ newAmount: Int64) {
//        if let indexPath = tableView.indexPathForSelectedRow {
//            let index = indexPath[1]
//            objects[index].amount = newAmount
//        }
    }
}

extension MasterViewController: FoodInfoViewControllerDelegate {
    
}

