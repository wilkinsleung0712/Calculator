//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by WEIQIANG LIANG on 13/12/2015.
//  Copyright © 2015 Black Friday Studio. All rights reserved.
//

import Foundation
class CalculatorBrain {
    enum OP{
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String,((Double,Double)->Double))
    }

    var opStack = [OP]();
    // a dictionary object to
    var knownOps = [String:OP]();

    init(){
        // adding all operation and how we calculate those math operation here.

//        //case "+": performOperation({(op1,op2) in return op1+op2});
//        case "+": performOperation { $0 + $1 };
//        //case "-": performOperation({(op1,op2) in return op1-op2});
//        case "−": performOperation { $1 - $0 };
//        //case "×": performOperation({(op1,op2) in return op1*op2});
//        case "×": performOperation { $1 * $0 };
//        //case "÷": performOperation({(op1,op2) in return op2/op1});
//        case "÷": performOperation { $1 / $0 };
//        case "√": performOperation { sqrt($0) };
//        case "sin": performOperation{ sin($0) };
//        case "cos": performOperation{ cos($0) };
//        case "π": displayValue = pi; enter(); π should be consider as digit not operation

        knownOps["+"] = OP.BinaryOperation("+", +);
        knownOps["-"] = OP.BinaryOperation("-"){ $1 - $0 };
        knownOps["×"] = OP.BinaryOperation("×", *);
        knownOps["÷"] = OP.BinaryOperation("÷"){ $1 / $0};
        knownOps["√"] = OP.UnaryOperation("√", sqrt);
        knownOps["sin"] = OP.UnaryOperation("sin", sin);
        knownOps["cos"] = OP.UnaryOperation("cos", cos);

    }

    // perform evaluation logic
    func evaluate(ops:[OP]) -> (result:Double?, remainingOps:[OP]) {
        if !ops.isEmpty{
            var remainingOps = ops;
            let op = remainingOps.removeLast();
            switch op {
            case .Operand(let operand):
                    return (operand, remainingOps);
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps);
                if let operationResult = operandEvaluation.result {
                    return (operation(operationResult), operandEvaluation.remainingOps);
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainingOps);
                if let operationResult1 = operandEvaluation1.result {
                    let operandEvaluation2 = evaluate(operandEvaluation1.remainingOps);
                    if let operationResult2 = operandEvaluation2.result {
                        return (operation(operationResult1,operationResult2),operandEvaluation2.remainingOps);
                    }
                }
            }
        }
        // we return nil and ops if ops isEmpty
        return (nil,ops);
    }

    func evaluate() ->Double? {
        //could be variable operands, so copying array helps
        let (result,remainder) = evaluate(opStack);
        print("\(opStack) = \(result) with \(remainder) left over.");
        return result;
    }

    func pushOperand(operand:Double){
        opStack.append(OP.Operand(operand));
    }

    func performOperating(symbol:String){
        if let operation = knownOps[symbol] {
            opStack.append(operation);
        }
    }


}