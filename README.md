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

Now we're going to get our hands a little dirty and talk about the implementation. When we initialize an `TypeBoundExpression`, we create logic rules for each of the different AST cases.
```swift
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
```

There are a few interesting things to point out here.

First of all, we're not yet handling procedural (multi-statement) code, just functional (single-statement) code. Handling the former will not be a huge change, but I've not yet decided how identifier scoping will work, so I need to think about the algorithm a bit more. We will also want to make sure that types can only be inferred forwards, not backwards, so that'll play into the design of the algorithm as well.

The second interesting thing to note is that this initializer is making stateful changes and even has an `inout` parameter, ew! It might be reasonable to rethink the structure here, but I'm not sure what might be more reasonable yet. This works, it just isn't as pretty as I'd like.

Anyway though, we create our `TypeBoundExpression`, and then it's super simple from there! We literally just enumerate over the matches for the terms provided by the `inout` argument.
```swift
    var terms: [Term<TypeName>] = []
    let typed = try! TypeBoundExpression(typing: expression, withTerms: &terms)
        var count = 0
        try! system.enumerateMatches(terms) {
            XCTAssertEqual(Term(name: "function", arguments: [
                .Constant(Term(atom: "Int")), 
                .Constant(Term(atom: "Int"))
            ]), typed.binding.value)
            count++
            print(try! TypedExpression(typed))
        }
    XCTAssertEqual(1, count)
```

In our test, we'll check to make sure we only enumerate over one set of matches thus ensuring that we found a unique unification solution. Great! Inside `enumerateMatches`, we can create a `TypedExpression` from our gross `TypeBoundExpression` giving us this beautifully typed AST (instead of the gross but oddly charming unification AST).

Let's see what our tree looks like!
```
((
    ((
        (compose :: function<function<Int, Int>, function<function<Int, Int>, function<Int, Int>>>)
        (sqrt :: function<Int, Int>)
    ) :: function<function<Int, Int>, function<Int, Int>>)
    (square :: function<Int, Int>)
) :: function<Int, Int>)
```

Kinda hard to see, but that's exactly what we want! We now have the types of every expression and every subexpression, so something like name mangling based on type should be easy-peasy!
