$ontext
CEE 6410 Fall 2015
Example 8-4-1 in the Bishop et al text

Solve the non-linear programming programming problem

Max Z = X1 (5 - (X1)^2) + X2 (14 - 6 X2)
s.t.
        X1 + 4 X2 <= 18
        6 X1 + 2 X2 <= 26
        (X2)^2 <= 5

Where X1 and X2 are the two decision variables and limited to the range 0 and 3

NEW GAMS TERMS
** = Exponential operator: 3**2 = 3^2
NLP = Nonlinear program: SOLVE MODELX USING NLP MAXIMIZING Z
X("i2") = i2-th element of set i
X.LO = Lower limit for variable X: X.LO = 1;  (set lower limit to 1.0)
X.UP = Upper limit for variable X: X.UP = 3;  (set lower limit to 3.0)
X.L = Level for variable X: X.L = 2.5; (set level to 2.5. When this statement appears before
                         SOLVE statement, this sets the variable initial value).


David E Rosenberg
david.rosenberg@usu.edu
September 23, 2018
$offtext

* 1. DEFINE the SETS
SETS i decision variables /i1*i2/
     j linear constraints /j1*j2/;

* 2. DEFINE the variables
VARIABLES X(i) decision variable values
          PROFIT profit and objective function value;

* Non-negativity constraints
POSITIVE VARIABLES X;

* 3. DEFINE input data
TABLE A(j,i) linear constraint coefficients
           i1    i2
    j1     1     4
    j2     6     2;

PARAMETER b(j) linear right hand side constraint bounds
     /j1    18,
      j2    26/ ;

* 4. COMBINE variables and data in equations
EQUATIONS
   NetBen          Total profit from actions
   ResReq(j)       Linear constraint requirements on resource use
   NonLinReq       Nonlinear requirement on resource use;

*                Quotes " " refer to an individual set element. Double asterics (**)is GAMS exponentiation operator
NetBen..          PROFIT =E= X("i1")*(5 - X("i1")**2) + X("i2")*(14 - 6*X("i2"));
ResReq(j)..       sum(i,A(j,i)*X(i)) =L= b(j);
NonLinReq..       X("i2")**2 =L= 5;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL NonLinModel /ALL/;

*Directions to the solver to set lower and upper bounds (without equations)
*for all decision variables to zero and 3
X.LO(i) = 0;
X.UP(i) = 3;
*Direction to the solver to specify the initial variable value levels (initial start point)
X.L("i1") = 0;
X.L("i2") = 3;
*This next statement overwrites the prior initialization statements.
*Starting point is now {0.0}
*X.L(i) = 0;

* 6. Solve the Model as an LP (relaxed IP)
SOLVE NonLinModel USING NLP Maximizing PROFIT;

DISPLAY X.L, Profit.L;
