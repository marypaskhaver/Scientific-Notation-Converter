//
//  ViewController.swift
//  Scientific Notation Converter
//
//  Created by Mary Paskhaver on 12/27/19.
//  Copyright © 2019 Nostaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var decimalTF: UITextField!
    @IBOutlet weak var baseTF: UITextField!
    @IBOutlet weak var exponentTF: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBAction func decimalEntered(_ sender: UITextField) {
        if decimalTF.text!.isEmpty || decimalTF.text!.countInstances(of: ".") > 1 {
            return
        }
        
        convertDecimalToSciNo()
    }
    
    @IBAction func exponentEntered(_ sender: UITextField) {
        if exponentTF.text!.isEmpty || exponentTF.text!.countInstances(of: "-") > 1 ||
            baseTF.text!.isEmpty || baseTF.text!.countInstances(of: ".") > 1 ||
            !exponentTF.text!.isInt {
            
            return
        }
        
        convertSciNoToDecimal()
    }
    
    @IBAction func baseEntered(_ sender: UITextField) {
        if exponentTF.text!.isEmpty || exponentTF.text!.countInstances(of: "-") > 1 ||
            baseTF.text!.isEmpty || baseTF.text!.countInstances(of: ".") > 1 ||
            !exponentTF.text!.isInt {
            
            return
        }
        
        convertSciNoToDecimal()
    }
    
    func convertSciNoToDecimal() {
        let baseString: String = baseTF.text!
        let base: Double = Double(baseString)!
        
        let exponentString: String = exponentTF.text!
        let exponent: Double! = Double(exponentString)
        
        if base == 0 {
            baseTF.text = String(base)
            return
        }
        
        let num: Double = (base * pow(10.0, exponent))
        
        print("a")
        print(String(num))
        print(num.toString())
        print("b")
        
        
        if exponent < 16 && exponent > -16 {
            print("foo")
            decimalTF.text = String(num)
        } else {
            print("bar")
            decimalTF.text = num.toString()
        }
        
        if (decimalTF.text!.count > 16) {
            let num = round(num * 10000000000000000) / 10000000000000000
            decimalTF.text = num.toString()
        }
    
    }
    
    
    func convertDecimalToSciNo() {
        let stringDecimal: String = decimalTF.text!
        var decimal: Double = Double(stringDecimal)!
        
        var exponent: Int = 0
        
        if decimal == 0 {
            baseTF.text = String(decimal)
            return
        }
        
        if decimal < 1 {
            while decimal < 1 {
                decimal *= 10.0
                exponent -= 1
            }
        } else if decimal > 1 {
            while decimal > 10 {
                decimal /= 10.0
                exponent += 1
            }
        }
        
        // Remove trailing zeros
        decimal = decimal.removeZerosFromEnd()
        
        // Set text in scientific notation label to 'converted' number
        baseTF.text = String(decimal)
        exponentTF.text = String(exponent)
    }
    
    @IBAction func clearAllTFs(_ sender: UIButton) {
        decimalTF.text = ""
        baseTF.text = ""
        exponentTF.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
        decimalTF.inputView =  DecimalKeypad(target: decimalTF)
        baseTF.inputView =  DecimalKeypad(target: baseTF)
        exponentTF.inputView = DecimalKeypadWithMinus(target: exponentTF)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension Double {
    func removeZerosFromEnd() -> Double {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        
        return Double(String(formatter.string(from: number) ?? "0"))!
    }
    
    // Prints out full number, not Apple scientific notation (ex: 4e+16)
    func toString(decimal: Int = 16) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        
        return string
    }

}

extension String {
    // Must be at least 1
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        
        return count
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
}
