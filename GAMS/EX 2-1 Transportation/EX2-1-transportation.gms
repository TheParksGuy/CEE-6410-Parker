$ontext
CEE 6410 - Metal Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

How many coups and minivans should a car manufacturer produce in a year?
The data are as follows:
• The car manufacturer profits by $6,000 per coup produced and $7,000 per
minivan produced.
• Each coup requires 1,000 pounds of metal to produce while each minivan requires
2,000 pounds of metal.
• The manufacturer has 4,000,000 pounds of metal available for the year.
• Coups have more electronics and features. Thus, each coup requires 4 circuit
boards per vehicle while each minivan requires 3 circuit boards per vehicle.
• The manufacturer has purchased 12,000 circuit boards for the year.
• One coup takes one worker 5 days to produce while one worker takes 2.5 days to
produce a minivan.
• The manufacturer has 67 workers and runs their factory for 261 days per year
(i.e., the manufacturer has 17,500 worker-days per year).

maximize profit

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

David E Rosenberg
david.rosenberg@usu.edu
September 15, 2015
$offtext

* 1. DEFINE the SETS
SETS vhec vehicles manufactured /Coup, Minivan/
     res resources /Metal, Circuits, Labor/;

* 2. DEFINE input data
PARAMETERS
   c(vhec) Objective function coefficients ($ per vehicle)
         /Coup 6000,
         Minivan 7000/
   b(res) Right hand constraint values (per resource)
          /Metal        4000000,
           Circuits     12000,
           Labor        17500/;

TABLE A(vhec,res) Left hand side constraint coefficients
                Metal    Circuits   Labor
 Coup           1000      4         5
 Minivan        2000      3         2.5;


* 3. DEFINE the variables
VARIABLES X(vhec) Vehicles made (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(vhec, c(vhec)*X(vhec));
RES_CONSTRAIN(res) ..    SUM(vhec, A(vhec,res)*X(vhec)) =L= b(res);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL MANUFACTURING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL MANUFACTURING /ALL/;


* 6. SOLVE the MODEL
* Solve the MANUFACTURING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE MANUFACTURING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file