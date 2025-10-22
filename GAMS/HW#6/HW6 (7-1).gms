$ontext
CEE 6410 Fall 2025 HW #6
A farmer plans to develop water for irrigation. He is considering two possible sources of
water: a gravity diversion from a possible reservoir with two alternative capacities and/or a
pump from a lower river diversion (refer to Figure 7.3). Between the reservoir and pump
site the river base flow increases by 2 acft/day due to groundwater drainage into the river.
Ignore losses from the reservoir. The river flow into the reservoir and the farmer's demand
during each of two six-month seasons of the year are given in Table 7.5. Revenue is estimated
at $300 per year per acre irrigated.
    
    Season      River Inflow (acft)     Irrigation Deamand (acft/acre)
    1           600                     1
    2           200                     3
    
Assume that there are only two possible sizes of reservoir: a high dam that has capacity of
700 acft or a low dam with capacity of 300 acft. The capital costs are $10,000/year and
$6,000/year for the high and low dams, respectively (no operating cost). The pump capacity
is fixed at 2.2 acft/day with a capital cost (if it is built) of $8,000/year and operating cost
of $20/acft.
$offtext

* 1. DEFINE the SETS
SETS
    src water supply sources
        /res "from reservoir", ps "pump station"/
    time time in which things happen
        /t1 "season 1",t2 "season 2"/
    size source size
        /L0 "none",L1 "small", L2 "large"/;

* 2. DEFINE input data
PARAMETERS
    OpCost(src) operating cost ($ per ac-ft)
        /res 0,
         ps  20/
    TotDemand  Total Demand (ac-ft per acre)
        /t1 1,
         t2 3/
    RiverInflow River Inflow (acft)
        /t1 600,
         t2 200/
    GrndWater Groundwater flow into river DS of the reservoir
        /2/
    IntStor starting reservoir storage
        /0/
    Rev Revenue from ac irrigated
        /300/;

TABLE
    CapCost(src,size) the cost to build ($)
                L1      L2
        res     6000    10000
        ps      8000            ;
TABLE
    MaxCap(src,size) capacity of source after built in acre-ft
                L1      L2
        res     300     700;

* 3. DEFINE the variables
VARIABLES
    I(src,size)      Binary decision to build or do prject from source src (1=yes 0=no)
    X(src,time)      Volume of water provided by source src (ac-ft per year)
    REL(time)       Release of the reservoir per season
    STOR(time)      Amount stored in Reservoir per season
    TBEN            Total net benefits Revenue minus Capital and Operating costs
    Acres           The amount of acres planted;

BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X,REL,STOR;

* 4. COMBINE variables and data in equations
EQUATIONS
    NetBen              Revenue minus the capital and operating cost and objective function value
    AreaToSupply(time)  Area to supply irrigation too (ac)
    PumpCap(time)       Pumping capacity in each time step (ac-ft per season)
    ResCap(time)        Reservoir storage within the capacity per time step (ac-ft)
    MutualExcl(src)     Can only use one size of Reservoir
    RivMassBal(time)    River mass balance downstream of reservoir per time step (ac-ft)
    ResMassBal(time)    Reservoir mass balance per time step (ac-ft)
    ;
    
NetBen..                TBEN =E= Rev * Acres - SUM(src,SUM(size,CapCost(src,size)*I(src,size)) + SUM(time,OpCost(src)*X(src,time)));
AreaToSupply(time)..    Acres =L= SUM(src,X(src,time))/TotDemand(time);
PumpCap(time)..         X('ps',time) =L= SUM(size,MaxCap('ps',size)*I('ps',size));
ResCap(time)..          STOR(time) =L= SUM(size,MaxCap('res',size)*I('res',size));
RivMassBal(time)..      X('ps',time) =L= REL(time) + GrndWater;
MutualExcl(src)..       SUM(size,I(src,size)) =L= 1;
ResMassBal(time)..      STOR(time) =E= RiverInflow(time) - REL(time) - X('res',time) +
                                        IntStor * SUM(size,MaxCap('res',size)*I('res',size))$(ord(time) eq 1) +
                                        STOR(time-1)$(ord(time) gt 1);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL ReservoirDesign /ALL/;

* 6. Solve the Model as an LP (relaxed IP)
SOLVE ReservoirDesign USING MIP MAXIMIZING TBEN;

DISPLAY X.L, I.L, TBEN.L,Acres.L;

$onText
* Dump all input data and results to a GAMS gdx file
Execute_Unload "Ex6-3-integer.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Ex6-3-integer.gdx"
$offText