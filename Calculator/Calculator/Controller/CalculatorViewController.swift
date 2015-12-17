//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by WEIQIANG LIANG on 13/12/2015.
//  Copyright © 2015 Black Friday Studio. All rights reserved.
//

import UIKit
class CalculatorViewController: UIViewController {

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var displayLable: UILabel!

    @IBOutlet var digitButton: [UIButton]!

    // boolean value to indicate if user is not finish typing
    var userIsInTheMiddleOfTyping:Bool = false;
    // boolean value to indicate if decimal is used
    var userHasUsedDecimal:Bool = false;
    // using for π
    let pi = M_PI;
    @IBOutlet var operationButton: [UIButton]!
    @IBAction func digitPress(sender: UIButton) {
        if let digit = sender.currentTitle {
            if(digit == "." && userHasUsedDecimal){
                // do nothing, as this is second decimal
            } else {
                if(digit == "."){
                    // if user first set the decimal, we set the value to true
                    userHasUsedDecimal = true;
                }

                if userIsInTheMiddleOfTyping {// if user is in the middle of typing, then starting should not be "0"
                    var currentText = displayLable.text!;
                    if currentText[currentText.startIndex] == "0" {
                        currentText.removeAtIndex(currentText.startIndex);
                    }
                    displayLable.text = displayLable.text! + digit;
                } else {
                    if userHasUsedDecimal {// if user is not in the middle of typing and use decimal, then should starting with "0"
                        displayLable.text = "0" + digit;
                    } else {
                        displayLable.text = digit;

                    }
                    
                    self.userIsInTheMiddleOfTyping = true;
                }
            }
            addToHistory(digit);
        }
    }

    // user hit operation key
    @IBAction func operate(sender: UIButton) {
        if(userIsInTheMiddleOfTyping){
            enter();
            userIsInTheMiddleOfTyping = false;
        }
        
        let operation = sender.currentTitle!;
        addToHistory(operation);

        switch operation {
        // passing named local parameter as op1&op2, pass inline return as the main func operation and declear what to return as Double.
        //case "+": performOperation({(op1,op2) in return op1+op2});
        case "+": performOperation { $0 + $1 };
        //case "-": performOperation({(op1,op2) in return op1-op2});
        case "−": performOperation { $1 - $0 };
        //case "×": performOperation({(op1,op2) in return op1*op2});
        case "×": performOperation { $1 * $0 };
        //case "÷": performOperation({(op1,op2) in return op2/op1});
        case "÷": performOperation { $1 / $0 };
        case "√": performOperation { sqrt($0) };
        case "sin": performOperation{ sin($0) };
        case "cos": performOperation{ cos($0) };
        case "π": displayValue = pi; enter();
        default: break;
        }
    }

    // declear a method as a parameter which takes two double and return a double as performOperation's parameter
    private func performOperation (operation:(Double,Double)->Double)  {
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast());
            enter();
        }
    }

    // declear a method as a parameter which takes only one double and return a double as performOperation's parameter
    private func performOperation (operation:Double->Double)  {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast());
            enter();
        }
    }

    // user hit enter key. we calling this operation as pushing result to the stack
    @IBAction func enter() {
        self.userIsInTheMiddleOfTyping = false;
        self.userHasUsedDecimal = false;
        operandStack.append(displayValue);
        print("operandStack:"+"\(operandStack)");
    }

    @IBAction func clear() {
        self.history.text = " ";
        self.displayLable.text = " ";
        self.operandStack.removeAll();

    }

    @IBAction func back() {
        if userIsInTheMiddleOfTyping {
            if displayLable.text!.characters.count > 0 {
                // we copied the text before modified.
                var truncatedtext = displayLable.text!;
                truncatedtext = String(truncatedtext.characters.dropLast());
                if truncatedtext.characters.count > 0 {
                    self.displayLable.text = truncatedtext;
                } else {
                    // if user just started to type one character then we see this back to "0"
                    self.displayLable.text = "0";

                }
            }
        }
        addToHistory("🔙");
    }
    var operandStack = Array<Double>();
    var displayValue:Double {
        get{
            // return a double value format from string
            return NSNumberFormatter().numberFromString(displayLable.text!)!.doubleValue;
        }
        set{
            // set the double value to the text
            displayLable.text = "\(newValue)";
            userIsInTheMiddleOfTyping = false;
        }
    }

    // function to add operation/digit to history
    func addToHistory(value:String) {
        if let oldText = history.text {
            history.text = oldText + value;
        } else {
            history.text = value;
        }

    }
}
