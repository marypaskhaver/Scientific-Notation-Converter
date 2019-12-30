//
//  ScientificNotationKeyboard.swift
//  Scientific Notation Converter
//
//  Created by Mary Paskhaver on 12/28/19.
//  Copyright © 2019 Nostaw. All rights reserved.
//

import UIKit

class ScientificNotationKeyboard: DecimalKeyboard {
    
    var powerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("^", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Power"
        button.addTarget(self, action: #selector(didTapPowerButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var spaceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("space", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Space"
        button.addTarget(self, action: #selector(didTapSpaceButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var xButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("x", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "x"
        button.addTarget(self, action: #selector(didTapXButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(target: UIKeyInput) {
        super.init(target: target)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Actions

extension ScientificNotationKeyboard {
    @objc func didTapPowerButton(_ sender: DigitButton) {
        target?.insertText("^")
    }
    
    @objc func didTapSpaceButton(_ sender: DigitButton) {
        target?.insertText(" ")
    }
    
    @objc func didTapXButton(_ sender: DigitButton) {
        target?.insertText("x")
    }
}

// MARK: - Private initial configuration methods

private extension ScientificNotationKeyboard {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }

    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)

        for row in 0 ..< 3 {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)

            for column in 0 ..< 3 {
                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
            }
        }

        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        
        subStackView.addArrangedSubview(decimalButton)
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)
        
        let topRowButtonsView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(topRowButtonsView)
        
        topRowButtonsView.addArrangedSubview(powerButton)
        topRowButtonsView.addArrangedSubview(xButton)
        topRowButtonsView.addArrangedSubview(spaceButton)

    }

    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}

