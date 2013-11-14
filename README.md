mc3
===

MC3: a steady-state Model and Constraint Consistency Checker for biochemical networks.

Stoichiometric models of genome-scale organisms are essential in performing steady-state 
analysis of cellular systems.

The code here, termed MC^3, Model and Constraint Consistency Checker, is a MATLAB 
based efficient computational tool.   

MC^3 can be used for two purposes: (a) identifying potential connectivity and topological
issues for a given stoichiometric matrix, S, and (b) flagging issues that arise during
constraint-based optimization. The MC3 tool includes three distinct checking components.
The first examines the results of computing the basis for the null space for S v =0; the second
uses connectivity analysis; and the third utilizes Flux Variability Analysis. MC^3 takes as input
a stoichiometric matrix and flux constraints, and generates a report summarizing issues.

Please reference the 2013 BMC Systems Biology paper, "MC3: a steady-state model and constraint
consistency Checker for biochemical networks", by Mona Yousofshahi, Ehsan Ullah, Russell Stern, and Soha Hassoun.
