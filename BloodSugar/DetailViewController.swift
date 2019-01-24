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

class DetailViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var netCarbsLabel: UILabel!
    @IBOutlet weak var gramsLabel: UILabel!
    @IBOutlet weak var additionTextField: UITextField!
    @IBOutlet weak var subtractionTextField: UITextField!
    
    // MARK: - Variables
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

    // MARK: - IBActions
    @IBAction func copyToClipboard(_ sender: Any) {
        if let detail = detailItem {
            UIPasteboard.general.string = String(detail.amount)
            playSound()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        detailItem?.amount = 0
//        guard let food = detailItem else {return}
        updateLabels()
//        updateAmountInMasterView(food)
    }
    
    // MARK: - Methods
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func playSound() -> Void {
        AudioServicesPlaySystemSound(1103)
    }
    
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
        switch action {
        case Action.addition:
            if let value = additionTextField.text {
                if let valueAsInt = Int64(value) {
                    detailItem?.amount += valueAsInt
//                    guard let food = detailItem else {return}
//                    updateAmountInMasterView(food)
                    additionTextField.text = ""
                }
                
            }
        case Action.subtraction:
            if let value = subtractionTextField.text {
                if let valueAsInt = Int64(value) {
                    detailItem?.amount -= valueAsInt
//                    guard let food = detailItem else {return}
//                    updateAmountInMasterView(food)
                    subtractionTextField.text = ""
                }
                
            }
        }
        updateLabels()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            navItem.title = detail.name
            
            updateLabels()
        }
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        setupKeyboardHiding()
    }
    
    // MARK: - Update methods
    func updateLabels() -> Void {
        updateAmountText()
        updateTotalCaloriesText()
        updateTotalNetCarbsText()
    }
    
    func updateAmountText() {
        if let detail = detailItem, let label = gramsLabel {
            label.text = String(detail.amount)
        }
    }
    
    func updateTotalCaloriesText() {
        if let detail = detailItem, let label = caloriesLabel {
            let value = Helpers.intToDecimal(int: detail.amount) as Decimal / 100 * (detail.caloriesPer100Grams as Decimal)
            label.text = Helpers.decimalToString(decimal: NSDecimalNumber(decimal: value))
        }
    }
    
    func updateTotalNetCarbsText() {
        if let detail = detailItem, let label = netCarbsLabel {
            let value = Helpers.intToDecimal(int: detail.amount) as Decimal / 100 * (detail.netCarbsPer100Grams as Decimal)
            label.text = Helpers.decimalToString(decimal: NSDecimalNumber(decimal: value))
        }
    }
    
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

extension DetailViewController: UITextFieldDelegate {
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

