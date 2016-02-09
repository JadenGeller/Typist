//
//  AugmentedExpression.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public protocol AugmentedExpressionType: ExpressionType {
    typealias Associated
    init(expression: Expressable<Self>, associatedValue: Associated)
    var associatedValue: Associated { get set }
}

extension AugmentedExpressionType {
    public init(_ expression: Expression, repeatedValue: Associated) {
        self.init(
            expression: expression.expression.map{ Self($0, repeatedValue: repeatedValue) },
            associatedValue: repeatedValue
        )
    }
    
    public init(_ expression: Expression, computedValue: Expressable<Self> throws -> Associated) rethrows {
        let expression = try expression.expression.map{ try Self($0, computedValue: computedValue) }
        self.init(
            expression: expression,
            associatedValue: try computedValue(expression)
        )
    }
}

extension AugmentedExpressionType {
    public init<A: AugmentedExpressionType>(_ expression: A, transform: A.Associated throws -> Associated) rethrows {
        self.init(
            expression: try expression.expression.map { try Self($0, transform: transform) },
            associatedValue: try transform(expression.associatedValue)
        )
    }
}
