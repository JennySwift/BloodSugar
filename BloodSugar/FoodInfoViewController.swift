//
//  FoodInfoViewController.swift
//  BloodSugar
//
//  Created by Jenny Swift on 23/1/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import UIKit

protocol FoodInfoViewControllerDelegate: class {
//    func didUpdateFood(_ detailItem: Food, _ newAmount: Int64)
}

class FoodInfoViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var netCarbsPer100GramsTextField: UITextField!
    @IBOutlet weak var caloriesPer100GramsTextField: UITextField!
    
    var activeTextField: UITextField?
    
    var detailItem: Food? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    weak var delegate: FoodInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FoodInfoViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        //For hiding keyboard when user taps outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
    
    func configureView() -> Void {
        print("configure view")
        if let detail = detailItem {
            print("in here")
            if let nameTextField = nameTextField {
                nameTextField.text = detail.name
            }
            if let caloriesPer100GramsTextField = caloriesPer100GramsTextField {
                caloriesPer100GramsTextField.text = decimalToString(decimal: detail.caloriesPer100Grams)
            }
            if let netCarbsPer100GramsTextField = netCarbsPer100GramsTextField {
                print(detail.netCarbsPer100Grams)
                netCarbsPer100GramsTextField.text = decimalToString(decimal: detail.netCarbsPer100Grams)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        activeTextField?.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        switch activeTextField {
        case nameTextField: updateName()
        case caloriesPer100GramsTextField: updateCaloriesPer100Grams()
        case netCarbsPer100GramsTextField: updateNetCarbsPer100Grams()
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    // MARK: - Update methods
    func updateCaloriesPer100Grams() -> Void {
        if let value = caloriesPer100GramsTextField.text {
            detailItem?.caloriesPer100Grams = stringToDecimal(string: value)
        }
    }
    
    func updateNetCarbsPer100Grams() -> Void {
        if let value = netCarbsPer100GramsTextField.text {
            detailItem?.netCarbsPer100Grams = stringToDecimal(string: value)
        }
    }
    
    func updateName() -> Void {
        if let value = nameTextField.text {
            detailItem?.name = value
        }
    }
    
    // MARK: - Helpers
    func intToDecimal(int: Int64) -> NSDecimalNumber {
        return stringToDecimal(string: String(int))
    }
    
    func int64ToInt32(int64: Int64) -> Int32 {
        return Int32(exactly: int64) ?? 0
    }
    
    func stringToDecimal(string: String) -> NSDecimalNumber {
        return NSDecimalNumber(string: string)
    }
    
    func decimalToString(decimal: NSDecimalNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let value = formatter.string(from: decimal) ?? ""
        return value
    }

}

extension FoodInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("should begin editing")
        activeTextField = textField
        
        return true
    }
}
