//
//  ExpressionType.swift
//  Typist
//
//  Created by Jaden Geller on 2/9/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public protocol ExpressionType {
    var expression: Expressable<Self> { get set }
}