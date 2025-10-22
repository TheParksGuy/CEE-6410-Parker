$ontext
CEE 6410 Fall 2020
Trying to find the global optimum with lots of local optimals
Example - the ChevyChev Function - https://www.chebfun.org/docs/guide/guide12.html

Solve the non-linear programming programming problem

Max Z =  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ...
   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ...
   - 1/3*exp(-(x+1).^2 - y.^2)
s.t.
        -3 <= x <= 3
        -3 <= y <= 3

Where x and y are the two decision variables and limited to the range -3 and 3

Students will explore solving the problem with different starting points

David E Rosenberg
david.rosenberg@usu.edu
October 4, 2020
$offtext

* 1. DEFINE the SETS
SETS i decision variables /x,y/;


* 2. DEFINE the variables
VARIABLES
        X(i) decision variable values
        Z objective function value (chevychev function);

* 3. Parameter to hold initial conditions.
PARAMETER
        XStart(i) Initial starting point - save

* 4. COMBINE variables and data in equations
EQUATIONS
        ObjFun          Objective function;

*                                power(x,2) is the same as x**2 (x^2) but works for negative values of x
ObjFun..          Z =E= 3*(1-power(X("x"),2))*exp(-power(X("x"),2) - power(X("y")+1, 2))
                        - 10*(X("x")/5 - power(X("x"),3) - power(X("y"),5))*exp(-power(X("x"),2)-power(X("y"),2))
                        - 1/3*exp(-power(X("x")+1, 2) - power(X("y"),2));

* 5. DEFINE the MODEL from the EQUATIONS
MODEL ChevyModel /ALL/;

*Directions to the solver to set lower and upper bounds (without equations)
*for all decision variables to -3 and 3
X.LO(i) = -3;
X.UP(i) = 3;

*Direction to the solver to specify the initial variable value levels (initial start point)
X.L("x") = .5;
X.L("y") = -.8;

*Save the starting point so we can see it at the end with the solution
XStart(i) = X.L(i)

* 6. Solve the Model as an LP (relaxed IP)
SOLVE ChevyModel USING NLP Maximizing Z;

DISPLAY X.L, Z.L, XStart;
