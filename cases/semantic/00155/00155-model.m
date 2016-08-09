(* 

category:      Test
synopsis:      Two reactions with four species in one 0-dimensional
compartment using an assignmentRule to vary one species.
componentTags: Compartment, Species, Reaction, Parameter, AssignmentRule 
testTags:      Amount, 0D-Compartment, InitialValueReassigned
testType:      TimeCourse
levels:        2.1, 2.2, 2.3, 2.4, 2.5, 3.1
generatedBy:   Numeric

The model contains one compartment called "compartment".  There are four
species named S1, S2, S3 and S4 and three parameters named k1, k2 and k3.
Compartment "compartment" is 0-dimensional.  The model contains two
reactions defined as:

[{width:30em,margin: 1em auto}|  *Reaction*  |  *Rate*  |
| S1 + S2 -> S3 | $k1 * S1 * S2$  |
| S3 -> S1 + S2 | $k2 * S3$  |]

The model contains one rule which assigns value to species S4:

[{width:30em,margin: 1em auto}|  *Type*  |  *Variable*  |  *Formula*  |
 | Assignment | S4 | $k3 * S2$  |]

In this case there is no initial value declared for species S4 and thus it
must be calculated by the assignmentRule.  Note that since this
assignmentRule must always remain true, it should be considered during
simulation.

The initial conditions are as follows:

[{width:30em,margin: 1em auto}|       |*Value*          |*Units*  |
|              Initial amount of S1:| $   1 \x 10^-3$ | mole                      |
|              Initial amount of S2:| $ 1.5 \x 10^-3$ | mole                      |
|              Initial amount of S3:| $   1 \x 10^-3$ | mole                      |
|              Initial amount of S4:| $   undeclared$ | mole                      |
|             Value of parameter k1:| $  1.5 \x 10^3$ | litre mole^-1^ second^-1^ |
|             Value of parameter k2:| $           50$ | second^-1^ |
|             Value of parameter k3:| $          1.5$ | dimensionless |]

In this example the compartment has its spatialDimensions attribute set to
zero; i.e., it represents a point and therefore cannot have size or units.
The species values must be treated as amounts and not concentrations.

*)

newcase[ "00155" ];

addCompartment[ compartment, spatialDimensions -> 0];
addSpecies[ S1, initialAmount->1 10^-3 ];
addSpecies[ S2, initialAmount -> 1.5 10^-3];
addSpecies[ S3, initialAmount -> 1 10^-3];
addSpecies[ S4];
addParameter[ k1, value -> 1.5 10^3];
addParameter[ k2, value -> 50 ];
addParameter[ k3, value -> 1.5 ];
addRule[ type->AssignmentRule, variable -> S4, math ->k3 * S2];
addReaction[ S1 + S2 -> S3, reversible -> False,
	     kineticLaw -> k1 * S1 * S2 ];
addReaction[ S3 -> S1 + S2, reversible -> False,
	     kineticLaw -> k2 * S3 ];

makemodel[]
