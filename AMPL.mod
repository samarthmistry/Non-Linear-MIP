### Sets

set ZONES;
set LOCATIONS;

### Paramenters

param demand {ZONES} >= 0;
param large_fixed_cost {LOCATIONS} >= 0;
param small_fixed_cost {LOCATIONS} >= 0;
param transport_cost {ZONES,LOCATIONS} >= 0;
param small_capacity;
param large_capacity;

### Decision Vars

var small_warehouse {j in LOCATIONS} integer >= 0;
var large_warehouse {j in LOCATIONS} integer >= 0;
var demand_proportion {ZONES,LOCATIONS} >= 0;

### Objective function

minimize Total_Cost:
	sum {j in LOCATIONS} small_fixed_cost[j] * small_warehouse[j]
  + sum {j in LOCATIONS} large_fixed_cost[j] * large_warehouse[j]
  + sum {i in ZONES, j in LOCATIONS} 0.2 * demand[i] * demand_proportion[i,j]
  + sum {i in ZONES, j in LOCATIONS} 600 * sqrt(demand[i] * demand_proportion[i,j])  
  + sum {i in ZONES, j in LOCATIONS} 0.25 * demand[i] * demand_proportion[i,j] * transport_cost[i,j];

### Constraints

subject to A {i in ZONES}:
   sum {j in LOCATIONS} demand_proportion[i,j] = 1;

subject to B {i in ZONES, j in LOCATIONS}:
   demand_proportion[i,j] <= small_warehouse[j] + large_warehouse[j];

subject to C {j in LOCATIONS}:
   sum {i in ZONES} demand[i] * demand_proportion[i,j] <= small_capacity * small_warehouse[j] + large_capacity * large_warehouse[j];

subject to D:
   small_warehouse['StLouis'] >= 1;
