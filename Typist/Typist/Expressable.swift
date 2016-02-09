//
//  Expressable.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

// TODO: Support non-functional expressions
public enum Expressable<Recursive> {
    indirect case Application(function: Recursive, argument: Recursive)
//    indirect case Sequence([Recursive])
//    indirect case Assign(name: String, value: Recursive)
    case Bare(String)
    case Value(Literal)
}

extension Expressable {
    public func map<V>(transform: Recursive throws -> V) rethrows -> Expressable<V> {
        switch self {
        case let .Application(function, argument):
            return Expressable<V>.Application(function: try transform(function), argument: try transform(argument))
//        case let .Sequence(actions):
//            return try .Sequence(actions.map(transform))
//        case let .Assign(name, value):
//            return .Assign(name: name, value: try transform(value))
        case let .Bare(word):
            return Expressable<V>.Bare(word)
        case let .Value(literal):
            return Expressable<V>.Value(literal)
        }
    }
}
