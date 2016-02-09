//
//  ConcreteType.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Axiomatic

public struct ConcreteType {
    public var name: String
    public var arguments: [ConcreteType]
}

extension ConcreteType: CustomStringConvertible {
    public var description: String {
        var result = name
        if arguments.count > 0 {
            result += "<"
            for (i, arg) in arguments.enumerate() {
                if i != 0 { result += ", " }
                result += arg.description
            }
            result += ">"
        }
        return result
    }
}

extension ConcreteType {
    public init(term: Term<String>) {
        name = term.name
        arguments = term.arguments.map { ConcreteType(term: $0.value!) } // TODO: MAKE THIS NIL SAFE
    }
}