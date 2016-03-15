//
//  TypeBoundExpression.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Axiomatic
import Gluey

public typealias TypeName = String

public struct TypeBoundExpression {
    public var expression: Expressable<TypeBoundExpression>
    public var binding: Binding<Term<TypeName>>
}

extension TypeBoundExpression: AugmentedExpressionType {
    public init(expression: Expressable<TypeBoundExpression>, associatedValue: Binding<Term<TypeName>>) {
        self.expression = expression
        self.binding = associatedValue
    }
    
    public var associatedValue: Binding<Term<TypeName>> {
        get {
            return binding
        }
        set {
            binding = newValue
        }
    }
}

extension TypeBoundExpression {
    // SHOULD THIS BE AN INIT?
    public init(typing untyped: Expression, inout withTerms terms: [Term<TypeName>]) throws {
        try self.init(untyped) { untyped in
            let binding = Binding<Term<TypeName>>()
            switch untyped {
            case let .Application(function, argument):
                // `function.binding` = function(`argument.binding`, `binding`)
                try Unifiable.unify(
                    Unifiable.Variable(function.binding),
                    Unifiable.Constant(Term(name: "function", arguments: [
                        .Variable(argument.binding),
                        .Variable(binding)
                    ]))
                )
            case let .Bare(word):
                // bound(`word`, `binding`)
                terms.append(Term(name: "bound", arguments: [
                    .Constant(Term(atom: word)),
                    .Variable(binding)
                ]))
            case let .Value(literal):
                // convertible(`literal.name`, `binding`)
                terms.append(Term(name: "convertible", arguments: [
                    .Constant(Term(atom: literal.name)),
                    .Variable(binding)
                ]))
            }
            return binding
        }
    }
}

extension TypeBoundExpression: CustomStringConvertible {
    public var description: String {
        switch expression {
        case let .Application(function, argument):
            return "(" + function.description + " " + argument.description + ")[\(binding)]"
        case let .Bare(word):
            return word + "[\(binding)]"
        case let .Value(literal):
            return "\(literal)[\(binding)]"
        }
    }
}
