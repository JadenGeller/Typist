//
//  TypistTests.swift
//  TypistTests
//
//  Created by Jaden Geller on 1/31/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
import Typist
import Axiomatic
import Gluey

class TypistTests: XCTestCase {
    
    func testTypechecking() {
        // compose sqrt square
        // (compose sqrt) square
        let expression = Expression(.Application(function: Expression(.Application(function: Expression(.Bare("compose")), argument: Expression(.Bare("sqrt")))), argument: Expression(.Bare("square"))))
        
        let system = System(clauses: [
            // square :: Int -> Int
            Clause(fact: Term(name: "bound", arguments: [
                .Constant(Term(atom: "square")),
                .Constant(Term(name: "function", arguments: [
                    .Constant(Term(atom: "Int")),
                    .Constant(Term(atom: "Int"))
                ]))
            ])),
            // sqrt :: Int -> Int
            Clause(fact: Term(name: "bound", arguments: [
                .Constant(Term(atom: "sqrt")),
                .Constant(Term(name: "function", arguments: [
                    .Constant(Term(atom: "Int")),
                    .Constant(Term(atom: "Int"))
                ]))
            ])),
            // compose = f -> g -> x -> f (g x)
            Clause { A, B, C in (
                fact: Term(name: "bound", arguments: [
                    .Constant(Term(atom: "compose")),
                    .Constant(Term(name: "function", arguments: [
                        .Constant(Term(name: "function", arguments: [.Variable(B), .Variable(C)])),
                        .Constant(Term(name: "function", arguments: [
                            .Constant(Term(name: "function", arguments: [.Variable(A), .Variable(B)])),
                            .Constant(Term(name: "function", arguments: [.Variable(A), .Variable(C)]))
                        ]))
                    ]))
                ])
            )},
        ])
        
        var terms: [Term<TypeName>] = []
        let typed = try! TypeBoundExpression(typing: expression, withTerms: &terms)
        var count = 0
        try! system.enumerateMatches(terms) {
            XCTAssertEqual(Term(name: "function", arguments: [.Constant(Term(atom: "Int")), .Constant(Term(atom: "Int"))]), typed.binding.value)
            count++
            print(try! TypedExpression(typed))
        }
        XCTAssertEqual(1, count)
    }
}
