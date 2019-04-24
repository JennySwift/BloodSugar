//
//  DoseDetailViewController.swift
//  BloodSugar
//
//  Created by Jenny Swift on 17/4/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import UIKit

protocol DoseDetailViewControllerDelegate: class {
//    func didUpdateFood(_ detailItem: Food, _ newAmount: Int64)
}


class DoseDetailViewController: UITableViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var additionTextField: UITextField!
    
    @IBOutlet weak var subtractionTextField: UITextField!
    weak var delegate: DoseDetailViewControllerDelegate?
    
//    var detailItem = "Insulin"
    // MARK: - Variables
    var detailItem: Figure? {
        didSet {
            // Update the view.
//            configureView()
        }
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        configureView()
        setupKeyboardHiding()
        
//        self.title = detailItem?
        
//        print(detailItem?)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    
    
    
    
    
    
    
    
    
    
    var action = Action.addition
    var activeTextField: UITextField?
    
    enum Action {
        case addition
        case subtraction
    }
    
    // MARK: - IBActions
    
    
    // MARK: - Methods
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    func setupKeyboardHiding() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        //For hiding keyboard when user taps outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    //    fileprivate func updateAmountInMasterView(_ food: Food) {
    //        if let newAmount = detailItem?.amount {
    //            delegate?.didUpdateFood(food, newAmount)
    //        }
    //    }
    
    func addFromInputField() -> Void {
//        switch action {
//        case Action.addition:
//            if let value = additionTextField.text {
//                if let valueAsInt = Int64(value) {
//                    detailItem?.amount += valueAsInt
//                    //                    guard let food = detailItem else {return}
//                    //                    updateAmountInMasterView(food)
//                    additionTextField.text = ""
//                }
//
//            }
//        case Action.subtraction:
//            if let value = subtractionTextField.text {
//                if let valueAsInt = Int64(value) {
//                    detailItem?.amount -= valueAsInt
//                    //                    guard let food = detailItem else {return}
//                    //                    updateAmountInMasterView(food)
//                    subtractionTextField.text = ""
//                }
//
//            }
//        }
//        updateLabels()
    }
//
//    func configureView() {
//        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            navItem.title = detail.name
//
//            updateLabels()
//        }
//    }
    
    // MARK: - Update methods
//    func updateLabels() -> Void {
//        updateAmountText()
//        updateTotalCaloriesText()
//        updateTotalNetCarbsText()
//    }
    
//    func updateAmountText() {
//        if let detail = detailItem, let label = gramsLabel {
//            label.text = String(detail.amount)
//        }
//    }
//
//    func updateTotalCaloriesText() {
//        if let detail = detailItem, let label = caloriesLabel {
//            let value = Helpers.intToDecimal(int: detail.amount) as Decimal / 100 * (detail.caloriesPer100Grams as Decimal)
//            label.text = Helpers.decimalToString(decimal: value)
//        }
//    }
//
//    func updateTotalNetCarbsText() {
//        if let detail = detailItem, let label = netCarbsLabel {
//            let value = Helpers.intToDecimal(int: detail.amount) as Decimal / 100 * (detail.netCarbsPer100Grams as Decimal)
//            label.text = Helpers.decimalToString(decimal: value)
//        }
//    }
    
    // MARK: - @objc
    @objc func dismissKeyboard() {
        activeTextField?.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        switch activeTextField {
        case additionTextField, subtractionTextField: addFromInputField()
        case .none:
            return
        case .some(_):
            return
        }
    }

}

extension DoseDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        if textField == additionTextField {
            action = Action.addition
        }
        if textField == subtractionTextField {
            action = Action.subtraction
        }
        return true
    }
}
