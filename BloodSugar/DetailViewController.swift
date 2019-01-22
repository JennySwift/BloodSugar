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
    
    func updateName() -> Void {
        if let value = nameTextField.text {
            detailItem?.name = value
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
            detailHeader.title = detail.name
            if let nameTextField = nameTextField {
                nameTextField.text = detail.name
            }
            
            updateAmountText()
        }
    }
    
    func updateAmountText() {
        if let detail = detailItem, let detailAmountLabel = detailAmountLabel {
            detailAmountLabel.text = String(detail.amount)
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
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

