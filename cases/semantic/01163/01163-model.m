(*

category:        Test
synopsis:        A hierarchical model with a replaced rate rule and parameter.
componentTags:   Parameter, RateRule, comp:ModelDefinition, comp:Port, comp:ReplacedElement, comp:Submodel
testTags:        NonConstantParameter, comp:SubmodelOutput, comp:NotRequired
testType:        TimeCourse
levels:          3.1
generatedBy:     Analytic
packagesPresent: comp

 The submodel contains a parameter and rate rule, both of which are replaced by the parent model.  This means that it is not actually necessary to understand the 'comp' package to pass the test; a simulator should be able to note the 'required="false"' line and attempt to simulate anyway.

The 'flattened' version of this hierarchical model contains:
* 1 parameter (p8)

There is one rule:

[{width:30em,margin-left:5em}|  *Type*  |  *Variable*  |  *Formula*  |
| Rate | p8 | $3$ |]

The initial conditions are as follows:

[{width:35em,margin-left:5em}|       | *Value* | *Constant* |
| Initial value of parameter p8 | $3$ | variable |]

Note: The test data for this model was generated from an analytical
solution of the system of equations.

*)