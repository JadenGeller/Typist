//
//  TypedExpression.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct TypedExpression {
    public var expression: Expressable<TypedExpression>
    public var type: ConcreteType
}

extension TypedExpression: AugmentedExpressionType {
    public init(expression: Expressable<TypedExpression>, associatedValue: ConcreteType) {
        self.expression = expression
        self.type = associatedValue
    }
    
    public var associatedValue: ConcreteType {
        get {
            return type
        }
        set {
            type = newValue
        }
    }
}

extension TypedExpression {
    public init(_ expression: TypeBoundExpression) throws {
        try self.init(expression) { binding in
            ConcreteType(term: binding.value!) // TODO: MAKE THIS NIL SAFE
        }
    }
}

extension TypedExpression: CustomStringConvertible {
    public var description: String {
        switch expression {
        case let .Application(function, argument):
            return "((" + function.description + " " + argument.description + ") :: " + type.description + ")"
        case let .Bare(word):
            return "(" + word + " :: " + type.description + ")"
        case let .Value(literal):
            return "(" + "\(literal)" + " :: " + type.description + ")"
        }
    }
}
