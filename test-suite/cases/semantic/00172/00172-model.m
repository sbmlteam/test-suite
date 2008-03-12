(*

category:      Test
synopsis:      Model using rules and parameters with an event.
componentTags: Parameter, RateRule, EventNoDelay 
testTags:      NonConstantParameter
testtype:      TimeCourse
levels:        2.1, 2.2, 2.3

The model contains three parameters named S1, S2 and k1.

  The model contains two rules:
[|| Type || Variable || Formula |
 || Rate || S1 || $-k1*S1$  |
 || Rate || S2 || $k1*S1$  |]


The model contains one event defined as:
[|| | Trigger      | Delay || Assignments |
 || Event1 | $S1 < 0.1$ | $-$ || $S1 = 1$ |]


The initial conditions are as follows:
[|                                  ||          Value  || Units                     |
|             Value of parameter S1:|| $          1.0$ || any |
|             Value of parameter S2:|| $          0.0$ || same as S1 |
|             Value of parameter k1:|| $            1$ || second^-1^ |]


*)

newcase[ "00172" ];

addParameter[ S1, value -> 1.0, constant -> False ];
addParameter[ S2, value -> 0.0, constant -> False ];
addParameter[ k1, value -> 1 ];
addRule[ type->RateRule, variable -> S1, math -> -k1*S1];
addRule[ type->RateRule, variable -> S2, math -> k1*S1];
addEvent[ trigger -> S1 < 0.1, eventAssignment -> S1->1];

makemodel[]
