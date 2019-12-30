//
//  Scientific_Notation_ConverterTests.swift
//  Scientific Notation ConverterTests
//
//  Created by Mary Paskhaver on 12/27/19.
//  Copyright © 2019 Nostaw. All rights reserved.
//

import XCTest
@testable import Scientific_Notation_Converter


class Scientific_Notation_ConverterTests: XCTestCase {
    var vc: ViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = (storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        vc.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConvertDecimalToScientificNotation() {
        vc.decimalTF.text = "12.345"
        
        // Should call convertDecimalToSciNo() if text in decimalTF is acceptable (ie: has 1 decimal pt),
        // which will change the text in baseTF and exponentTF
        vc.decimalEntered(vc.decimalTF)
        
        XCTAssert(vc.baseTF.text == "1.2345")
        XCTAssert(vc.exponentTF.text == "1")
    }
    
    func testConvertScientificNotationToDecimal() {
        vc.baseTF.text = "7.891"
        vc.exponentTF.text = "5"
        
        // Should call convertSciNoToDecimal() if base and exponent are in range,
        // which will change the text in decimalTF
        vc.baseEntered(vc.baseTF)
        
        XCTAssert(vc.decimalTF.text == "789100")
        
        vc.baseTF.text = "1.234"
        vc.exponentTF.text = "2"
        vc.exponentEntered(vc.exponentTF) // baseEntered and exponentEntered work the same way
        
        XCTAssert(vc.decimalTF.text == "123.4")
    }
    
    func testClearButton() {
        // Fill up all fields with calculation
        vc.decimalTF.text = "12.345"
        vc.decimalEntered(vc.decimalTF)

        // Imitate what would happen if clearButton was pressed-- clearAllTFs would be called
        vc.clearAllTFs(vc.clearButton)
        
        // All TFs should be empty (contain only "")
        XCTAssertTrue(vc.decimalTF.text!.isEmpty)
        XCTAssertTrue(vc.baseTF.text!.isEmpty)
        XCTAssertTrue(vc.exponentTF.text!.isEmpty)
    }
    
    func testIfBaseInRange() {
        // Base range: [1, 10)
        
        vc.baseTF.text = "10.2345"
        vc.exponentTF.text = "15"
        vc.baseEntered(vc.baseTF)
        
        XCTAssert(vc.decimalTF.text == "")
        
        vc.baseTF.text = ".012345"
        vc.exponentTF.text = "2"
        vc.exponentEntered(vc.exponentTF)
        
        XCTAssert(vc.decimalTF.text == "")
    }
    
    func testIfExponentInRange() {
        // Exponent range: [-16, 16]
        
        vc.baseTF.text = "1.2345"
        vc.exponentTF.text = "17"
        vc.baseEntered(vc.baseTF)
        
        XCTAssert(vc.decimalTF.text == "")
        
        vc.baseTF.text = "1.2345"
        vc.exponentTF.text = "-17"
        vc.exponentEntered(vc.exponentTF)
        
        XCTAssert(vc.decimalTF.text == "")
    }
    
    func testIfDecimalPointPlacementAffectsBaseAndExponentTFs() {
        // Nothing should happen if the decimalTF text is not a proper decimal
        vc.decimalTF.text = "12..345"
        vc.decimalEntered(vc.decimalTF)
        XCTAssertTrue(vc.baseTF.text!.isEmpty)
        XCTAssertTrue(vc.exponentTF.text!.isEmpty)
        
        vc.decimalTF.text = "..12345"
        vc.decimalEntered(vc.decimalTF)
        XCTAssertTrue(vc.baseTF.text!.isEmpty)
        XCTAssertTrue(vc.exponentTF.text!.isEmpty)
        
        vc.decimalTF.text = "12345.."
        vc.decimalEntered(vc.decimalTF)
        XCTAssertTrue(vc.baseTF.text!.isEmpty)
        XCTAssertTrue(vc.exponentTF.text!.isEmpty)
        
        vc.decimalTF.text = "1.23.45"
        vc.decimalEntered(vc.decimalTF)
        XCTAssertTrue(vc.baseTF.text!.isEmpty)
        XCTAssertTrue(vc.exponentTF.text!.isEmpty)
    }
    
    func testIfMinusSignPlacementAffectsDecimalTF() {
        vc.exponentTF.text = "1-"
        vc.exponentEntered(vc.exponentTF)
        XCTAssertTrue(vc.decimalTF.text!.isEmpty)

        vc.exponentTF.text = "--1"
        vc.exponentEntered(vc.exponentTF)
        XCTAssertTrue(vc.decimalTF.text!.isEmpty)

        vc.exponentTF.text = "-1-"
        vc.exponentEntered(vc.exponentTF)
        XCTAssertTrue(vc.decimalTF.text!.isEmpty)

        vc.exponentTF.text = "1--"
        vc.exponentEntered(vc.exponentTF)
        XCTAssertTrue(vc.decimalTF.text!.isEmpty)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
