/*********************************************
 * OPL 12.8.0.0 Model
 * Creation Date: Dec 1, 2018 at 10:14:38 AM
 *********************************************/

using CP;

// Index, Sets

int nbDemandZones = 6;
range DemandZones = 1..nbDemandZones;
int nbWarehouseLocations = 5;
range WarehouseLocations = 1..nbWarehouseLocations;

// Paramenters

int Demand[DemandZones] = [1866240, 1166400, 933120, 1283040, 2041200, 1020600];
int LargeFixedCost[WarehouseLocations] = [500000, 420000, 375000, 375000, 405000];
int SmallFixedCost[WarehouseLocations] = [300000, 250000, 220000, 220000, 240000];
float TransportCost[WarehouseLocations][DemandZones] = [[2, 2.5, 3.5, 4, 5, 5.5], [2.5, 2.5, 2.5, 3, 4, 4.5], [3.5, 3.5, 2.5, 2.5, 3, 3.5], [4, 4, 3, 2.5, 3, 2.5], [4.5, 5, 3, 3.5, 2.5, 4]];
int SmallCapacity = 2000000;
int LargeCapacity = 4000000;

// Decision Vars

dvar int SmallWarehouse[WarehouseLocations] in 0..1;
dvar int LargeWarehouse[WarehouseLocations] in 0..1;
dvar int scaleDemandProportion[DemandZones][WarehouseLocations] in 0..100;

// Algebraic expressions

dexpr int SmallCost = sum(j in WarehouseLocations) SmallFixedCost[j] * SmallWarehouse[j];
dexpr int LargeCost = sum(j in WarehouseLocations) LargeFixedCost[j] * LargeWarehouse[j];
dexpr float VarCost = sum(i in DemandZones, j in WarehouseLocations) 0.2 * Demand[i] * (scaleDemandProportion[i][j]/100);
dexpr float TrCost = sum(i in DemandZones, j in WarehouseLocations) (Demand[i]/4) * (scaleDemandProportion[i][j]/100) * TransportCost[j][i];
dexpr float InvCost1 = 600 * sqrt(sum(i in DemandZones) Demand[i] * (scaleDemandProportion[i][1]/100));
dexpr float InvCost2 = 600 * sqrt(sum(i in DemandZones) Demand[i] * (scaleDemandProportion[i][2]/100));
dexpr float InvCost3 = 600 * sqrt(sum(i in DemandZones) Demand[i] * (scaleDemandProportion[i][3]/100));
dexpr float InvCost4 = 600 * sqrt(sum(i in DemandZones) Demand[i] * (scaleDemandProportion[i][4]/100));
dexpr float InvCost5 = 600 * sqrt(sum(i in DemandZones) Demand[i] * (scaleDemandProportion[i][5]/100));
dexpr float TotalCost = SmallCost + LargeCost + VarCost + TrCost;

dexpr int SmlWh = sum(j in WarehouseLocations) SmallWarehouse[j];
dexpr int LrgWh = sum(j in WarehouseLocations) LargeWarehouse[j];

// CP Optimizer parmeters

execute {
   cp.param.timeLimit = 60000;
}

// Constraints

subject to
{
	forall(i in DemandZones)
		sum(j in WarehouseLocations) scaleDemandProportion[i][j] == 100;
	
	forall(i in DemandZones, j in WarehouseLocations)
		scaleDemandProportion[i][j] <= 100 * SmallWarehouse[j] + 100 * LargeWarehouse[j];
	
	forall(j in WarehouseLocations)
		sum(i in DemandZones) Demand[i] * scaleDemandProportion[i][j] <= 100 * SmallCapacity * SmallWarehouse[j] + 100 * LargeCapacity * LargeWarehouse[j];
	
	SmallWarehouse[3] == 1;
	
	SmlWh + LrgWh <= 3;
		
	TotalCost <= 9500000;
	}

// main function

main {
	thisOplModel.generate();
	cp.startNewSearch();
	while (cp.next()) {
		if (thisOplModel.TotalCost + thisOplModel.InvCost1 + thisOplModel.InvCost2 + thisOplModel.InvCost3 + thisOplModel.InvCost4 + thisOplModel.InvCost5 < 10900000) {
			writeln("Small Facilities = ", thisOplModel.SmallWarehouse, " and Large Facilities = ", thisOplModel.LargeWarehouse);
			writeln(thisOplModel.scaleDemandProportion)
			writeln(thisOplModel.TotalCost + thisOplModel.InvCost1 + thisOplModel.InvCost2 + thisOplModel.InvCost3 + thisOplModel.InvCost4 + thisOplModel.InvCost5);
		}	
	}
	cp.endSearch();
}
