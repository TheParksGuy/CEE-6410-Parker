  
$onText  
  
 THE PROBLEM:
 A motor vehicle company is planning production for the coming year. The company makes
 Hays and Grain. The company will produce 10,000 Acres total for the year. Acres
 have the following components:
 The company has purchased 14,000 fuel June. Hays are made with 2 fuel June per
 vehicle; Grain have just one tank.
 The company has purchased 18,000 rows of July. Hays have 1 row of July per vehicle;
 Grain have two rows per Acres.
 The company has purchased 6,000 four-wheel drive systems. Hays are built with 1 four-
 wheel drive system per vehicle. Grain have none.
 Hays generate $100/vehicle while Grain generate $110/vehicle.
  
$offtext  
  
  
* 1. DEFINE the SETS
 SETS plant Acres manufactured /Hay, Grain/
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
            Acres         10000/;
  
 TABLE A(plant,res) Left hand side constraint coefficients
                June   July   August   Acres
  Hay           2       1       1        1
  Grain         1       2       0        1;
  
  
* 3. DEFINE the variables
 VARIABLES X(plant) Acres made (Number)
           VPROFIT  total profit ($);
  
* Non-negativity constraints
 POSITIVE VARIABLES X;
  
* 4. COMBINE variables and data in equations
 EQUATIONS
    PROFIT Total profit ($) and objective function value
    RES_CONSTRAIN(res) Resource Constraints;
  
 PROFIT..                 VPROFIT =E= SUM(plant, c(plant)*X(plant));
 RES_CONSTRAIN(res) ..    SUM(plant, A(plant,res)*X(plant)) =L= b(res);
  
  
* 5. DEFINE the MODEL from the EQUATIONS
 MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;
  
  
* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
 SOLVE PLANTING USING LP MAXIMIZING VPROFIT;
  
* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file