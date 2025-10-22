$ontext
CEE 6410 Fall 2015
Example 7.1 in the Bishop et al text
 
Develop a mixed integer programming model for the following reservoir design problem and solve.
 
A farmer plans to develop water for irrigation.
He is considering two possible sources of water:
 
   - a gravity diversion from a possible reservoir with two alternative capacities and/or
   - a pump from a lower river diversion (refer to Figure 7.3 in the text).
 
Between the reservoir and pump site the river base flow increases by 2 acft/day
due to groundwater drainage into the river.  Ignore losses from the reservoir.
The river flow into the reservoir and the farmer's demand during each of two six-month seasons
of the year are given in Table 7.5.  Revenue is esti-mated at $300 per year per acre irrigated.
 
Table 7.5:  Seasonal Flow and Demand
Season, t        River Inflow, Qt (acft)        Irrigation Demand (acft/acre)
1                       600                                 1.0
2                       200                                 3.0
 
 
Assume that there are only two possible sizes of reservoir:
a high dam that has capacity of 700 acft or a low dam with capacity of 300 acft.
The capital costs are $10,000/year and $6,000/year for the high and low dams,
respectively (no operating cost).  The pump capac-ity is fixed at 2.2 acft/day
with a capital cost (if it is built) of $8,000/year and operating cost of $20/acft.
 
David E Rosenberg
david.rosenberg@usu.edu
September 28, 2015

$offtext

* 1. DEFINE the SETS
SETS src water supply sources /res "diversion from reservoir", pum "pump from river"/
     lev   source size /lev0 "none", lev1 "small", lev2 "big"/
     t   time in seasons /s1*s2/;
 
 
* 2. DEFINE the variables
VARIABLES I(src,lev) binary decision to build or do prject from source src(1=yes 0=no)
          X(src,t) volume of water provided by source src in time t (ac-ft per season)
          REL(t)   Reservoir release to river in time t (ac-ft per season)
          STOR(t)     Reservoir storage volume in time t (ac-ft)
          AREA     Area irrigated (ac)
          TBEN  Total net benefits that are revenus minus capital and operating costs ($);
 
BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X, REL, STOR;
 
 
* 3. DEFINE input data
TABLE CapCost(src,lev) capital cost ($ to build)
           lev1  lev2
    res    6000  10000
    pum    8000        ;
*leaving out r0 keeps the default entry of zero
 
PARAMETER OpCost(src) operating cost ($ per ac-ft)
     /res    0,
      pum    20/ ;
 
TABLE MaxCapacity(src,lev) Maximum capacity of source when built (ac-ft per season)
           lev1  lev2
    res    300   700;
 
*Define the maximum capacity programatically for the pump (covert from daily to seasonal)
* card(t) counts the number of elements in set to MaxCapacity("pum","lev1") = 2.2*365/card(t);
 
PARAMETERS RiverInflow(t) River inflow in time t (ac-ft)
                 /s1 600, s2 200/
           Demand(t) Irrigation demand in time t (ac-ft per acre)
                 /s1 1.0, s2 3.0/
           InitStor Initial reservoir storage (fraction of full capacity) 
                /0/
           BaseFlow River baseflow below the reservoir (ac-ft)
                /2/
           Revenue  Revenue from irrigation ($ per year per acre)
                /300/;
 
*Convert daily baseflow to seasonal baseflow BaseFlow = BaseFlow*365/card(t);
 
 
* 4. COMBINE variables and data in equations
EQUATIONS
   NetBen          Revenues minus capital and operating costs ($) and objective function value
   AreaToSupply(t) Area to supply with deliveries (ac)
   PumpCapacity(t) Pumping within capacity in each time step (ac-ft per season)
   ResCapacity(t)  Reservoir storage within capacity in each time step (ac-ft)
   MutExclus(src)  Can only implement one project size (#)
   RivMassBal(t)   River mass balance downstream of reservoir in each timestep (ac-ft)
   ResMassBal(t)   Reservoir mass balance in each time step (ac-ft);
 
 
NetBen..                 TBEN =E= Revenue * AREA - SUM(src,SUM(lev,CapCost(src,lev)*I(src,lev)) + SUM(t,OpCost(src)*X(src,t)));
AreaToSupply(t)..        AREA =L= SUM(src,X(src,t))/Demand(t);
PumpCapacity(t)..        X("pum",t) =L= sum(lev,MaxCapacity("pum",lev)*I("pum",lev));
ResCapacity(t)..            STOR(t) =L= sum(lev,MaxCapacity("res",lev)*I("res",lev));
RivMassBal(t)..          X("pum",t) =L= REL(t) + BaseFlow;
MutExclus(src)..         sum(lev,I(src,lev)) =L= 1;
 
*Reservoir mass balance
*In first time step, previous storage is the initial storage (a fraction of the capacity).
*In subsequent time steps, prevous storage is the prior storage variable (t-1).
*Differentiate the cases using the $ operator $(ord(t) eq 1) => first timestep
*                                             $(ord(t) gt 1) => subsequenttime steps
ResMassBal(t)..   STOR(t) =E= RiverInflow(t) - REL(t) - X("res",t) +
*                    Initial storage = fraction of reservoir capacity to include for equation for first time step
InitStor*sum(lev,MaxCapacity("res",lev)*I("res",lev))$(ord(t) eq 1)  +
*                    Prior storage to include for equations for subsequenttime steps (t-1)
STOR(t-1)$(ord(t) gt 1);
 
* 5. DEFINE the MODEL from the EQUATIONS
MODEL ResDesign /ALL/;
 
* 6. Solve the Model as an LP (relaxed IP)
SOLVE ResDesign USING MIP Maximizing TBEN;
 
DISPLAY X.L, I.L, TBEN.L;
 
* Dump all input data and results to a GAMS gdx file
*Execute_Unload "Ex7-1.gdx";
* Dump the gdx file to an Excel workbook
*Execute "gdx2xls Ex7-1.gdx"