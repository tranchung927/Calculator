//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chung Sama on 8/5/17.
//  Copyright © 2017 ChungSama. All rights reserved.
//

import Foundation

private func changeSign(_ operand: Double) -> Double{
    return operand * -1
}

struct CalculatorBrain {
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "⁺∕₋": Operation.unaryOperation({ -$0 }),
        "x": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "=": Operation.equals
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var result: Double? {
        return accumulator
    }
    
    mutating func performOperation(_ symbol: String) {
        guard let operation = operations[symbol] else { return }
        switch operation {
        case .constant(let value):
            accumulator = value
        case .unaryOperation(let f):
            if let operand = accumulator {
                accumulator = f(operand)
            }
        case .binaryOperation(let f):
            if accumulator != nil {
                pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                accumulator = nil
            }
        case .equals:
            performBinaryOperation()
        }
    }
    
    private mutating func performBinaryOperation() {
        guard pendingBinaryOperation != nil && accumulator != nil else { return }
        accumulator = pendingBinaryOperation!.perform(with: accumulator!)
        pendingBinaryOperation = nil
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
