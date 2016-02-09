//
//  Expression.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Expression: ExpressionType {
    public var expression: Expressable<Expression>
    
    public init(_ expression: Expressable<Expression>) {
        self.expression = expression
    }
}

extension Expression: CustomStringConvertible {
    public var description: String {
        switch expression {
        case let .Application(function, argument):
            return "(" + function.description + " " + argument.description + ")"
        case let .Bare(word):
     
            return word
        case let .Value(literal):
            return "\(literal)"
        }
    }
}

extension Expression {
    init<E: ExpressionType>(_ expression: E) {
        self.expression = expression.expression.map(Expression.init)
    }
}