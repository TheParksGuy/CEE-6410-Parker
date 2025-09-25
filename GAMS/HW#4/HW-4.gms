  
$onText  
  
 THE PROBLEM:
 A motor vehicle company is planning production for the coming year. The company makes
 Trucks and Sedans. The company will produce 10,000 vehicles total for the year. Vehicles
 have the following components:
 The company has purchased 14,000 fuel tanks. Trucks are made with 2 fuel tanks per
 vehicle; sedans have just one tank.
 The company has purchased 18,000 rows of seats. Trucks have 1 row of seats per vehicle;
 sedans have two rows per vehicles.
 The company has purchased 6,000 four-wheel drive systems. Trucks are built with 1 four-
 wheel drive system per vehicle. Sedans have none.
 Trucks generate $100/vehicle while Sedans generate $110/vehicle.
  
$offtext  
  
  
* 1. DEFINE the SETS
 SETS vhec vehicles manufactured /Truck, Sedans/
      res resources /Tanks, Seats, Transmissions,Vehicles/;
  
* 2. DEFINE input data
 PARAMETERS
    c(vhec) Objective function coefficients ($ per vehicle)
          /Truck  100,
          Sedans   110/
    b(res) Right hand constraint values (per resource)
           /Tanks            14000,
            Seats            18000,
            Transmissions    6000,
            Vehicles         10000/;
  
 TABLE A(vhec,res) Left hand side constraint coefficients
                 Tanks   Seats   Transmissions   Vehicles
  Truck          2       1       1               1
  Sedans         1       2       0               1;
  
  
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