//
//  Literal.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Literal {
    case Int(Swift.Int)
    case String(Swift.String)
}

extension Literal {
    public var name: Swift.String {
        switch self {
        case .Int:    return "IntLiteral"
        case .String: return "StringLiteral"
        }
    }
}