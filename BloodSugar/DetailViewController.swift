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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var netCarbsPer100GramsTextField: UITextField!
    @IBOutlet weak var caloriesPer100GramsTextField: UITextField!
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
        updateAmountText()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            print(detail.caloriesPer100Grams)
            detailHeader.title = detail.name
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
            
            updateAmountText()
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
//        additionTextField.resignFirstResponder()
//        subtractionTextField.resignFirstResponder()
        activeTextField?.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        switch activeTextField {
        case additionTextField, subtractionTextField: addFromInputField()
        case nameTextField: updateName()
        case caloriesPer100GramsTextField: updateCaloriesPer100Grams()
        case netCarbsPer100GramsTextField: updateNetCarbsPer100Grams()
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
    
    func updateAmountText() {
        if let detail = detailItem, let detailAmountLabel = detailAmountLabel {
            detailAmountLabel.text = String(detail.amount)
        }
    }
    
    // MARK: - Helpers
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

