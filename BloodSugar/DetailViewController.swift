//
//  DetailViewController.swift
//  BloodSugar
//
//  Created by Jenny Swift on 21/1/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import UIKit
import AVFoundation

protocol DetailViewControllerDelegate: class {
    func didUpdateFood(_ detailItem: Food, _ newAmount: Int64)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var detailHeader: UINavigationItem!
    @IBOutlet weak var detailAmountLabel: UILabel!
    @IBOutlet weak var additionTextField: UITextField!
    @IBOutlet weak var subtractionTextField: UITextField!
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var totalNetCarbsLabel: UILabel!
    
    @IBAction func copyToClipboard(_ sender: Any) {
        if let detail = detailItem {
            UIPasteboard.general.string = String(detail.amount)
            playSound()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        detailItem?.amount = 0
        guard let food = detailItem else {return}
        updateAmountText()
        updateAmountInMasterView(food)
    }

    var detailItem: Food? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    weak var delegate: DetailViewControllerDelegate?
    
    var action = Action.addition
    var activeTextField: UITextField?
    
    enum Action {
        case addition
        case subtraction
    }
    
    func playSound() -> Void {
        AudioServicesPlaySystemSound(1103)
    }
    
    @IBAction func subtractionInputFocused(_ sender: Any) {
        print("subtraction focused")
    }
    
    @IBAction func additionInputFocused(_ sender: Any) {
        print("addition focused")
    }
    
    fileprivate func updateAmountInMasterView(_ food: Food) {
        if let newAmount = detailItem?.amount {
            delegate?.didUpdateFood(food, newAmount)
        }
    }
    
    func addFromInputField() -> Void {
        switch action {
        case Action.addition:
            if let value = additionTextField.text {
                if let valueAsInt = Int64(value) {
                    print(valueAsInt)
                    detailItem?.amount += valueAsInt
                    guard let food = detailItem else {return}
                    updateAmountInMasterView(food)
                    additionTextField.text = ""
                }
                
            }
        case Action.subtraction:
            if let value = subtractionTextField.text {
                if let valueAsInt = Int64(value) {
                    detailItem?.amount -= valueAsInt
                    guard let food = detailItem else {return}
                    updateAmountInMasterView(food)
                    subtractionTextField.text = ""
                }
                
            }
        }
        updateLabels()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            detailHeader.title = detail.name
            
            updateLabels()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        //For hiding keyboard when user taps outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Update methods
    func updateLabels() -> Void {
        updateAmountText()
        updateTotalCaloriesText()
        updateTotalNetCarbsText()
    }
    
    func updateAmountText() {
        if let detail = detailItem, let detailAmountLabel = detailAmountLabel {
            detailAmountLabel.text = String(detail.amount)
        }
    }
    
    func updateTotalCaloriesText() {
        if let detail = detailItem, let label = totalCaloriesLabel {
            let value = intToDecimal(int: detail.amount) as Decimal / 100 * (detail.caloriesPer100Grams as Decimal)
            label.text = decimalToString(decimal: NSDecimalNumber(decimal: value))
        }
    }
    
    func updateTotalNetCarbsText() {
        if let detail = detailItem, let label = totalNetCarbsLabel {
            let value = intToDecimal(int: detail.amount) as Decimal / 100 * (detail.netCarbsPer100Grams as Decimal)
            label.text = decimalToString(decimal: NSDecimalNumber(decimal: value))
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

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("should begin editing")
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

