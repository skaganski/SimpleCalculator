//
//  CalculatorBrain.swift
//  SimpleCalculator
//
//  Created by Sergei Kaganski on 08/01/2017.
//  Copyright © 2017 Sergei Kaganski. All rights reserved.
//

import Foundation

class CalculatorBrain{

    
    private var accumulator = 0.0 // internal accumulating result
    private var internalProgram = [AnyObject]()
 
    //setting operations
    func setOperand (operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    // genaring type, table with parameters
    //if dollar mark, then no need of in return and etc.
    //dollar mark-default argument
    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "±" : Operation.UnaryOperation({ -$0 }), //sqrt,
        "√" : Operation.UnaryOperation(sqrt), //sqrt,
        "cos" : Operation.UnaryOperation(cos), // cos
        "×" : Operation.BinaryOperation({ $0*$1 }),
        "+" : Operation.BinaryOperation({ $0+$1 }),
        "÷" : Operation.BinaryOperation({ $0/$1 }),
        "−" : Operation.BinaryOperation({ $0-$1 }),
        "=" : Operation.Equals,
        "AC": Operation.Clear
    
    ]
    //discrete value, may be constant, or operation, bionary operation
    //simulates class
    //enums are allowed to have methods inside
    private enum Operation {
        case Constant (Double)
        case UnaryOperation ((Double)->Double) // function
        case BinaryOperation ((Double, Double)->Double)
        case Equals
        case Clear
    }
    //performing operations, which are setted
    //no need for default, as there are only 4 cases, check enum
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        //looking in dictionary
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()
            }
        }
    }
    
    //to execute the binary operation
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    
    }

    //its only if pending Binary operation
    private var pending: PendingBinaryOperationInfo?
    
    // very like class, but structs are passed by value, classes by refferences
    // passed by refferences-passing a pointer to method
    // passing by value means, that its copying it
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject // let create type exatly the same at created type
    
    var program: PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
           clear()
            if let arrayOfOps=newValue as? [AnyObject]{
                for op in arrayOfOps{ // check in array
                    if let operand = op as? Double{ // if anyObject
                        setOperand(operand: operand)
                    }else if let operation =  op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    //clearing function
    func clear(){
        accumulator = 0.0
        pending=nil
        internalProgram.removeAll()
        
    }
    //result of the operation
    var result: Double{
        get{
            return accumulator
            }
    }
}
