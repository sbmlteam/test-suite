(*

category:        Test
synopsis:        Minimize single objective function, infinite bounds.
componentTags:   Compartment, Reaction, Species, fbc:FluxBound, fbc:FluxObjective, fbc:Objective
testTags:        BoundaryCondition, NonUnityStoichiometry, fbc:BoundGreaterEqual, fbc:BoundLessEqual, fbc:MinimizeObjective
testType:        FluxBalanceSteadyState
levels:          3.1
generatedBy:     Numeric
packagesPresent: fbc

 Minimize single objective function, infinite bounds.

The model contains:
* 23 species (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, X, Y)
* 1 compartment (Cell)
* 1 objective (OBJF)

The active objective is OBJF, which is to be minimized:
  + 1 R26

There are 26 reactions, and 52 flux bounds:

[{width:30em,margin: 1em auto}|  *Reaction*  |  *Rate*  |
| R01: X -> A | $R01 >= 0 && R01 <= 1$ |
| R02: A -> B | $R02 >= -INF && R02 <= INF$ |
| R03: A -> C | $R03 >= -INF && R03 <= INF$ |
| R04: C -> B | $R04 >= -INF && R04 <= INF$ |
| R05: B -> D | $R05 >= 0 && R05 <= INF$ |
| R06: D -> E | $R06 >= 0 && R06 <= INF$ |
| R07: E -> F | $R07 >= 0 && R07 <= INF$ |
| R08: F -> I | $R08 >= 0 && R08 <= INF$ |
| R09: D -> G | $R09 >= 0 && R09 <= INF$ |
| R10: G -> H | $R10 >= 0 && R10 <= INF$ |
| R11: H -> I | $R11 >= 0 && R11 <= INF$ |
| R12: I -> J | $R12 >= 0 && R12 <= INF$ |
| R13: J -> K | $R13 >= 0 && R13 <= INF$ |
| R14: K -> L | $R14 >= -INF && R14 <= INF$ |
| R15: L -> Q | $R15 >= 0 && R15 <= INF$ |
| R16: J -> M | $R16 >= 0 && R16 <= INF$ |
| R17: M -> N | $R17 >= 0 && R17 <= INF$ |
| R18: N -> Q | $R18 >= 0 && R18 <= INF$ |
| R19: K -> O | $R19 >= -INF && R19 <= INF$ |
| R20: O -> P | $R20 >= -INF && R20 <= INF$ |
| R21: P -> L | $R21 >= -INF && R21 <= INF$ |
| R22: Q -> R | $R22 >= 0 && R22 <= INF$ |
| R23: R -> S | $R23 >= -INF && R23 <= INF$ |
| R24: R -> S | $R24 >= 0 && R24 <= INF$ |
| R25: A + T -> 0.5S + U | $R25 >= 0 && R25 <= INF$ |
| R26: S -> Y | $R26 >= 0 && R26 <= INF$ |]

*)
