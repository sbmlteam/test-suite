(* 

category:      Test
synopsis:      Basic single forward reaction with three species in one
compartment using an assignmentRule to vary one species.
componentTags: Compartment, Species, Reaction, Parameter, AssignmentRule, EventWithDelay  
testTags:      InitialAmount, LocalParameters
testType:      TimeCourse
levels:        2.1, 2.2, 2.3
generatedBy:   Numeric

The model contains one compartment called C.  There are three
species called S1, S2 and S3 and one parameter called k.  The model
contains one reaction defined as:

[{width:30em,margin-left:5em}|  *Reaction*  |  *Rate*  |
| S1 -> S2 | $C * k2 * S1$  |]

Reaction S1 -> S2 defines one local parameter k which has a
scope local to the defining reaction and is different from the global parameter k
used in the assignmentRule.

The model contains one rule which assigns value to species S3:

[{width:30em,margin-left:5em}|  *Type*  |  *Variable*  |  *Formula*  |
 | Assignment | S3 | $k * S2$  |]

In this case the initial value declared for species S3 is inconsistent with
the value calculated by the assignmentRule.  Note that since this
assignmentRule must always remain true, it should be considered during
simulation.

The model contains one event that assigns a value to species S2:

[{width:30em,margin-left:5em}| | *Trigger*    | *Delay* | *Assignments* |
 | Event1 | $S1 < 0.1$ | $0.5$   | $S2 = 1$    |]

The initial conditions are as follows:

[{width:30em,margin-left:5em}|       |*Value*         |*Units*  |
|Initial amount of S1                |$            1$ |mole                      |
|Initial amount of S2                |$            0$ |mole                      |
|Initial amount of S3                |$        3.75$ |mole                      |
|Value of parameter k               |$         0.75$ |dimensionless |
|Value of local parameter k          |$            5$ |second^-1^ |
|Volume of compartment C |$            1$ |litre                     |]

The species values are given as amounts of substance to make it easier to
use the model in a discrete stochastic simulator, but (as per usual SBML
principles) their symbols represent their values in concentration units
where they appear in expressions.

*)

newcase[ "00708" ];

addCompartment[ C, size -> 1];
addSpecies[ S1, initialAmount->1 ];
addSpecies[ S2, initialAmount -> 0.5 ];
addSpecies[ S3, initialAmount -> 3.75];
addParameter[ k, value -> 0.75 ];
addRule[ type->AssignmentRule, variable -> S3, math ->k * S2];
addReaction[ S1 -> S2, reversible -> False,
	     kineticLaw -> C * k * S1, parameters -> {k -> 5}];
addEvent[ trigger -> S1 < 0.1, delay-> 0.5, eventAssignment -> S2->1 ];

makemodel[]