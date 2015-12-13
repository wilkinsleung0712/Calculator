//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by WEIQIANG LIANG on 13/12/2015.
//  Copyright © 2015 Black Friday Studio. All rights reserved.
//

import UIKit
class CalculatorViewController: UIViewController {

    @IBOutlet weak var displayLable: UILabel!

    @IBOutlet var digitButton: [UIButton]!
    var userIsInTheMiddleOfTyping:Bool = false;

    @IBOutlet var operationButton: [UIButton]!
    @IBAction func digitPress(sender: UIButton) {
        let digit = sender.currentTitle;
        if(self.userIsInTheMiddleOfTyping.boolValue){
            displayLable.text = displayLable.text! + digit!;
        } else {
            displayLable.text = digit!;
            self.userIsInTheMiddleOfTyping = true;
        }
    }

    // user hit operation key
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!;

        switch operation {
        // passing named local parameter as op1&op2, pass inline return as the main func operation and declear what to return as Double.
        //case "+": performOperation({(op1,op2) in return op1+op2});
        case "+": performOperation { $0 + $1 };
        //case "-": performOperation({(op1,op2) in return op1-op2});
        case "-": performOperation { $1 - $0 };
        //case "×": performOperation({(op1,op2) in return op1*op2});
        case "×": performOperation { $1 * $0 };
        //case "÷": performOperation({(op1,op2) in return op2/op1});
        case "÷": performOperation { $1 / $0 };
        case "√": performOperation { sqrt($0) };
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
        operandStack.append(displayValue);
        print("operandStack:"+"\(operandStack)");
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

}
