//
//  Checker.swift
//  Typist
//
//  Created by Jaden Geller on 1/31/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/*
import Axiomatic

protocol LogicType {
    var mangledName: String { get }
}

struct Type: LogicType {
    var name: String
    
    var mangledName: String {
        return name
    }
}

struct Function<T> {
    var name: String
    var argumentType: T
    var returnType: T
    
//    var mangledName: String {
//        return name + "_" + argumentType.mangledName + "_" + returnType.mangledName
//    }
}

struct Trait {
    enum TType {
        case Concrete(Type)
        case SelfType
    }
    
    var name: String
    var requirements: [Function<TType>]
}

struct TypeSystem {
    var clauses: [Clause<String>]
    
    mutating func declareType(type: Type) {
        // what about duplicates?
        clauses.append(Clause(fact: Predicate(name: "type", arguments: [
            .Constant(Predicate(atom: type.mangledName))
        ])))
    }
    
//    mutating func declareTrait(name: String, requirements: ()) {
//        clauses.append(Clause{ type in (
//            rule: Predicate(name: name, arguments: [.Variable(type)]),
//            conditions: 
//                Predicate(name: "function", arguments: [
//                     .Constant(Predicate(atom: /* */)
//                ))
//        ]})
//    }
    
    mutating func declareFunction(function: Function<Type>) {
        clauses.append(Clause(fact: Predicate(name: "function", arguments: [
            .Constant(Predicate(atom: function.name)),
            .Constant(Predicate(atom: function.argumentType.mangledName)),
            .Constant(Predicate(atom: function.returnType.mangledName))
        ])))
    }
}

// specifications
// implementaion

*/