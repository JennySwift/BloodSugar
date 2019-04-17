//
//  DoseViewController.swift
//  BloodSugar
//
//  Created by Jenny Swift on 17/4/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import UIKit

class DoseViewController: UITableViewController {

    @IBOutlet weak var totalNetCarbsLabel: UILabel!
    @IBOutlet weak var bloodSugarNowLabel: UILabel!
    
    @IBOutlet weak var minutesWalkingLabel: UILabel!
    @IBOutlet weak var carbInsulinRatioLabel: UILabel!
    @IBOutlet weak var bloodSugarGoalLabel: UILabel!
    
    @IBOutlet weak var totalInsulinLabel: UILabel!
    
    
    var bloodSugarNow = 7.4
    var bloodSugarGoal = 3.8
    var minutesWalking = 0.0
    var carbInsulinRatio = 16.4
    var totalInsulin = 11.0
    var correctionFactor = 3.0
    var totalNetCarbs: Double = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateValues()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateValues()
        calculateDose()
    }
    
    func updateValues() {
        totalNetCarbs = Store.totalNetCarbs
        
//        totalNetCarbsLabel.text = Helpers.decimalToString(decimal: totalNetCarbs)
        totalNetCarbsLabel.text = String(totalNetCarbs)
        
        
        bloodSugarNowLabel.text = String(bloodSugarNow)
        bloodSugarGoalLabel.text = String(bloodSugarGoal)
        minutesWalkingLabel.text = String(minutesWalking)
        carbInsulinRatioLabel.text = String(carbInsulinRatio)
        totalInsulinLabel.text = String(totalInsulin)
    }
    
    func calculateDose() {
        var dose = bloodSugarNow - bloodSugarGoal
        dose /= correctionFactor
        
        dose += (totalNetCarbs / carbInsulinRatio)
        
        dose -= (minutesWalking / 60.0)
        
        dose -= totalInsulin
        
        self.title = String(dose)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

}
