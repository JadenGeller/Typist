# Typist

Typist is a framework that takes a partially type-annotated abstract syntax tree and will
- infer the missing types
- check that the existing types can be unified
- ensures that type unification is not ambiguous

Let's check out a quick example! Let's say we define an absolute value function by composing `square` and `sqrt`. We need to figure out what the type of this expression will end up being.
```swift
let expression = Expression(.Application(
  function: Expression(.Application(
    function: Expression(.Bare("compose")),
    argument: Expression(.Bare("sqrt"))
  )),
  argument: Expression(.Bare("square"))
))
```

So we define our expression, cool. But now, we can't figure out what expression is without already having some prior knowledge about other types (in this case, `compose`, `sqrt`, and `square`). Let's annotate their types. We can think of these as the *builtin* functions in our language.
```swift
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
```

Notice a big difference between the syntax used in the definition of our expression and our builtins? Well, this difference is due to the latter definitions being the raw logic rules that the existance of these types imply while the former is an abstract syntax tree in our language.

We're going to check that there's one unique type unification. We must first initialize a `TypeBoundExpression` from our `expression` above. This will be an equivalent abstract syntax tree but with type holes. Not just type holes in fact, these type holes are filled will type `Binding<Term<TypeName>>` meaning that they can be used for unification purposes! Check out [Axiomatic](https://github.com/jadengeller/axiomatic) if you have no idea what these are :P.
