//
//  Functional.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence, LogicalConjunctionPrecedence
}
precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}
precedencegroup BackwardsComposition {
    associativity: left
    higherThan: ForwardApplication
}


infix operator |> : ForwardApplication
func |> <A,B> (a:A, f:(A)->B) -> B {
    return f(a)
}

infix operator >>> : ForwardComposition
func >>> <A,B,C> (f:@escaping (A)->B, g:@escaping (B)->C) -> (A)->C {
    return { a in
        return g(f(a))
    }
}

infix operator <<<: BackwardsComposition
func <<< <A, B, C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> (A) -> C {
    return { x in
        g(f(x))
    }
}
