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
    var numberFormatter: NumberFormatter = NumberFormatter()
    
    @IBAction func decimalEntered(_ sender: UITextField) {
        if decimalTF.text!.isEmpty || decimalTF.text!.countInstances(of: ".") > 1 {
            return
        }
        
        convertDecimalToSciNo()
    }
    
    @IBAction func exponentEntered(_ sender: UITextField) {
        if exponentTF.text!.isEmpty || exponentTF.text!.countInstances(of: "-") > 1 ||
            baseTF.text!.isEmpty || baseTF.text!.countInstances(of: ".") > 1 ||
            Double(baseTF.text!)! > 10 || Double(baseTF.text!)! < 1 ||
            Double(exponentTF.text!)! > 16 || Double(exponentTF.text!)! < -16 {
            
            return
        }
        
        convertSciNoToDecimal()
    }
    
    @IBAction func baseEntered(_ sender: UITextField) {
        if exponentTF.text!.isEmpty || exponentTF.text!.countInstances(of: "-") > 1 ||
            baseTF.text!.isEmpty || baseTF.text!.countInstances(of: ".") > 1 ||
            Double(baseTF.text!)! > 10 || Double(baseTF.text!)! < 1 ||
            Double(exponentTF.text!)! > 16 || Double(exponentTF.text!)! < -16 {
            
            return
        }
        
        convertSciNoToDecimal()
    }
    
    func convertSciNoToDecimal() {
        let baseString: String = baseTF.text!
        let base: Double = Double(baseString)!
        
        let exponentString: String = exponentTF.text!
        let exponent: Double! = Double(exponentString)
        
        let num: Double = (base * pow(10.0, exponent))
        
        // Make sure small numbers are printed without scientific notation and with max. 16 fraction digits
        let numString = numberFormatter.string(from: NSNumber(value: num))
        
        decimalTF.text = numString!
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
        
        let decimalString = numberFormatter.string(from: NSNumber(value: decimal))

        // Set text in scientific notation label to 'converted' number
        baseTF.text = decimalString
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
        
        numberFormatter.maximumFractionDigits = 16
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
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
