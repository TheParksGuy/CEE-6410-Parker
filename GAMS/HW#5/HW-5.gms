  
$onText  

HW#5
A reservoir is designed to provide hydropower and water for irrigation. The turbine releases may
also be used for irrigation as shown in Figure 1. At least one unit of water must be kept in the
river each month at point A. The hydropower turbines have a capacity of 4 units of water per
month (flows are constant during any single month), and any other releases must bypass the tur-
bines. The size of farmed area is very large relative to the amount of irrigation water available, so
there is no upper limit on usable irrigation water. The reservoir has a capacity of 9 units, and initial
storage is 5 units of water. The ending storage must be equal to or greater than the beginning
storage. The benefits per unit of water, and the estimated average inflows to the reservoir are given
in Table 1.

    Month   Inflow Units    Hydropower Benefits ($/unit)     Irrigation Benefits ($/unit)
    1        2              1.6                                 1.0
    2        2              1.7                                 1.2
    3        3              1.8                                 1.9
    4        4              1.9                                 2.0
    5        3              2.0                                 2.2
    6        2              2.0                                 2.2

A. Develop and solve an LP model for maximizing the economic benefits of reservoir opera-
tion.
B. How will net benefits change if the:
    i. Reservoir capacity is expanded one unit?
    ii. In-stream flow requirement is increased?
    iii. Farms are irrigated with one more unit of water in months 1, 2, and 3?
C. What increase in the in-stream flow requirement is allowed before the solution basis
changes?
D. What concerns would a water manager likely raise as the number of months in this model
increases?
  
$offtext  
  
  
* 1. DEFINE the SETS
 SETS   Spatial points of interest in the problem schematic  /Spill, ReservoirStorage, Turbine, Irrigation, FlowA, FlowC/
        Month    Time periods  /Month1, Month2, Month3, Month4, Month5, Month6/;

SCALAR  TurbineCapacity Maximum Flow Through Turbine in a Month /4/
        MinFlowAtA Minimum Flow at A /1/
        ResInitialStor Starting Reservoir Storage /5/
        MaximumReservoirStorage Maximum storage at the Reservoir /9/;

* 2. DEFINE input data
 PARAMETERS
    HydroBenefits(Month) hydropower benefits per Month /
        Month1      1.6
        Month2      1.7
        Month3      1.8
        Month4      1.9
        Month5      2.0
        Month6      2.0/
 
    IrrigationBenefits(Month) Irrigation Benefits per Month /
        Month1      1    
        Month2      1.2  
        Month3      1.9  
        Month4      2.0  
        Month5      2.2  
        Month6      2.2/
        
    ReservoirInflow(Month) Inflow to the system per Month /
        Month1      2
        Month2      2
        Month3      3
        Month4      4
        Month5      3
        Month6      2/
;


* 3. DEFINE the variables
 VARIABLES X(Spatial,Month) All of volume of water per location per Month [arbitrary] except for storage which is a volume
           VPROFIT  Objective Function Value ($)
           FinalStorage Final Storage of the Reservoir
           ;
  
* Non-negativity constraints
 POSITIVE VARIABLES X, FinalStorage;
  
* 4. COMBINE variables and data in equations
 EQUATIONS
    PROFIT Total profit ($) and objective function value
    TURBINE_CAP Upper limit of turbine releases
    MINIMUMFLOWATA Minimum flow at point A
    RESMASSBAL Reservoir Mass Balance in each time period 1 to 5
    FINALRESMASSBAL Final Mass Balance at time period 6
    MAXRESSTORAGE The maximum possible storage
    MASSBALATC The mass balance at point C
    LASTANDFIRSTRESBAL The final reservoir level must be greater then the initail
    FinalReservoirCAP Limit of the final reservoir level
    InitialReservoir The starting storage of the reservoir
    ;
 

PROFIT..                                VPROFIT =E= SUM(Month, HydroBenefits(Month) * X("Turbine",Month) + IrrigationBenefits(Month) * X("Irrigation",Month));

TURBINE_CAP(Month) ..                   X("Turbine",Month) =L= TurbineCapacity;

MINIMUMFLOWATA(Month) ..                X("FlowA",Month) =G= MinFlowAtA;

RESMASSBAL(Month)$(ord(Month) lt 6) ..  X("ReservoirStorage",Month) + ReservoirInflow(Month) - X("Turbine",Month) - X("Spill",Month) =E= X("ReservoirStorage",Month+1); 
  
FINALRESMASSBAL(month) ..               X("ReservoirStorage","Month6") + ReservoirInflow("Month6") - X("Turbine","Month6") - X("Spill","Month6") =E= FinalStorage;

MAXRESSTORAGE(Month) ..                 X("ReservoirStorage",Month) =L= MaximumReservoirStorage;

MASSBALATC(Month) ..                    X("Spill",Month) + X("Turbine",Month) =G= X("Irrigation",Month) + X("FlowA",Month);

LASTANDFIRSTRESBAL ..                   ResInitialStor =L= FinalStorage;

FinalReservoirCAP ..                    MaximumReservoirStorage =G= FinalStorage;

InitialReservoir ..                     X("ReservoirStorage","Month1") =E= ResInitialStor;


* 5. DEFINE the MODEL from the EQUATIONS
MODEL WATERDISTRIBUTION /ALL/;
  
  
* 6. SOLVE the MODEL
* Solve the WATERDISTRIBUTION model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
 SOLVE WATERDISTRIBUTION USING LP MAXIMIZING VPROFIT;
  
* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file