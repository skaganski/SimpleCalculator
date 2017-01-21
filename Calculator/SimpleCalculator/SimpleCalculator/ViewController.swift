//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Sergei Kaganski on 08/01/2017.
//  Copyright © 2017 Sergei Kaganski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // label, UILabel optional (! or ?)
    @IBOutlet private weak var display: UILabel!
    //to eliminate zero, if user is in the middle of clicking buttons
    private var userIsInTheMiddleOfTyping = false
    // method, what happens by clicking on button
    @IBAction private func touchDigit(_ sender: UIButton) {
        //sending the button's title back
        let digit=sender.currentTitle!
        //sending message to display, to show the tile of button
        //replacing zero
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    // tracking everything what is in the display
    // its double, as all results are doubles
    private var displayValue : Double{
        get{
            //converting to double
            return Double (display.text!)!
        }
        set {
            //newValue is a double, that someone is putting in dispaly
            //String(newValue) its converting Double to String
            display.text = String (newValue)
        }
    }
    // creating model
    // using new class
    private var brain = CalculatorBrain()
    // button with operations
    @IBAction private func performOperation(_ sender: UIButton) {
        // if typing, then set operation
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        
        // puting a result into display from CalculatorBrain
        displayValue = brain.result
    }
}

