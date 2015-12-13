//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by WEIQIANG LIANG on 13/12/2015.
//  Copyright © 2015 Black Friday Studio. All rights reserved.
//

import Foundation
class CalculatorBrain {
    var digitStack:[String];



    init() {
        digitStack = [""];
    }

    func pushToStack(digit:String) {
        digitStack.append(digit);
    }


}