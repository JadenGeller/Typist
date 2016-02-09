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

/*

public struct AugmentedExpression<Associated>: ExpressionType {
    public let expression: Expressable<AugmentedExpression<Associated>>
    public let metadata: Associated
}

extension AugmentedExpression {
    public init(_ expression: Expression, computedValue: Expressable<AugmentedExpression> throws -> Associated) rethrows {
        self.expression = try expression.expression.map{ try AugmentedExpression($0, computedValue: computedValue) }
        self.metadata = try computedValue(self.expression)
    }
    
    public init(_ expression: Expression, repeatedValue: Associated) {
        self.metadata = repeatedValue
        self.expression = expression.expression.map{ AugmentedExpression($0, repeatedValue: repeatedValue) }
    }
}

*/