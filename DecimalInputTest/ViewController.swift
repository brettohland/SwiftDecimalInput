//
//  ViewController.swift
//  DecimalInputTest
//
//  Created by Brett Ohland on 7/18/16.
//  Copyright © 2016 Brett Ohland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static let placeholderString = "---"
    static let readingsDecimalSeparator = "."
    static let maxFractionDigits = 2
    static let maxReadingLength = 4
    
    @IBOutlet var decimalInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.decimalInput.text = ViewController.placeholderString
    }
    
    private lazy var readingsCharacterSet: NSCharacterSet = {
        let charset = NSMutableCharacterSet()
        charset.formUnionWithCharacterSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        charset.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())
        return charset
    }()

}

extension ViewController {
    @IBAction func handleButtonPress(sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func handleEditingStart(sender: UITextField) {

        if sender.text == ViewController.placeholderString {
            
            sender.text = "0.00"
            
        }
        
    }
    
    @IBAction func handleEditingEnd(sender: UITextField) {
        if sender.text == "0.00" {
            sender.text = ViewController.placeholderString
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentNSString:NSString = textField.text else { return false }
        
        let currentString = String(currentNSString.stringByReplacingCharactersInRange(range, withString: string))
        
        // This length check takes the max reading and adds one character for the . and one more for the extra digit
        guard currentString.characters.count < ViewController.maxReadingLength + 2 else { return false }
        
        textField.text = convert(toReadingsString: (currentString as String))
        
        return false
    }
    
    func convert(toReadingsString string: String) -> String {
        
        guard string.isEmpty != true else {
            return ViewController.placeholderString
        }
        
        let characters = string.componentsSeparatedByCharactersInSet(self.readingsCharacterSet).filter { !$0.isEmpty }
        var strippedString = characters.joinWithSeparator("")
        // Strip out every non-numeric character
        
        // If the length of the string is less than 4, append 0s
        if strippedString.characters.count < ViewController.maxReadingLength {
            while strippedString.characters.count < ViewController.maxReadingLength {
                strippedString.insert("0", atIndex: strippedString.startIndex)
            }
        }
        // else only take the first 4 digits
        else {
            strippedString = String(strippedString.characters.suffix(ViewController.maxReadingLength))
        }
        
        // At this point, we'll end up with a string that will be 4 characters and a high chance that the first character
        // is a "0". Strip it out if it's there.
        if strippedString.characters.first! == Character("0") {
            strippedString = String(strippedString.characters.suffix(ViewController.maxReadingLength - 1))
        }
        
        // Add in the decimal placeholder
        strippedString.insert(Character(ViewController.readingsDecimalSeparator), atIndex: strippedString.endIndex.advancedBy(ViewController.maxFractionDigits * -1))
        
        return strippedString
    }
    
}
