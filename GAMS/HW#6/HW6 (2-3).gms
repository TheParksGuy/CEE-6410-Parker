  
$onText  
 CEE 6410 Fall 2025 HW #6 
 THE PROBLEM:
 A farmer is planning production for the coming year. They produces
 Hays and Grain. The farmer will produce 10,000 Acres of crops for the year.
 Each month recieves a total amount of water and each crop has a different water requirement per month

                  June    July    August
        Hay       2       1       1
      Grain       1       2       0
Total Water       14000   18000   6000


 Hays generates $100/crop acre while Grain generate $110/crop acre.
  
$offtext  
  
  
* 1. DEFINE the SETS
 SETS plant Acres produced /Hay, Grain/
      res resources /June, July, August,Acres/;
  
* 2. DEFINE input data
 PARAMETERS
    c(plant) Objective function coefficients ($ per vehicle)
          /Hay  100,
          Grain   120/
    b(res) Right hand constraint values (per resource)
           /June            14000,
            July            18000,
            August          6000,
            Acres           10000/
; 
 
 TABLE A(plant,res) Left hand side constraint coefficients
                June   July   August   Acres
  Hay           2       1       1        1
  Grain         1       2       0        1;
  
  
* 3. DEFINE the variables
 VARIABLES X(plant) Acres made (Number)
           VPROFIT  total profit ($)
           Y(res)   dual resoures 
           DualCOST;
  
* Non-negativity constraints
 POSITIVE VARIABLES X,Y;
  
* 4. COMBINE variables and data in equations
 EQUATIONS
    PROFIT                  Total profit ($) and objective function value
    RES_CONSTRAIN(res)      Resource Constraints
    DualExpense             Total usage of each resource
    Plnt_Constrain(plant)   plant 
;
  
 PROFIT..                 VPROFIT =E= SUM(plant, c(plant)*X(plant));
 RES_CONSTRAIN(res) ..    SUM(plant, A(plant,res)*X(plant)) =L= b(res);
 DualExpense ..           DualCOST =E= SUM(res,b(res)*Y(res));
 Plnt_Constrain(plant)..  SUM(res,A(plant,res)*Y(res)) =G= c(plant);
  
  
* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
MODEL DualPLANTING /DualExpense, Plnt_Constrain/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;
  
  
* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
 SOLVE PLANTING USING LP MAXIMIZING VPROFIT;
 SOLVE DualPLANTING USING LP MINIMIZING DualCOST;
 
DISPLAY VPROFIT.L, DUALCOST.L;