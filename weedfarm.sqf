/*
	Harvestable Hemp Farms for DayZ Epoch 1.0.6+ by JasonTM
	Credit to original author Halv: https://pastebin.com/juMsuJ1r
*/

#define LOCATIONS	5			// number of concurrent farm locations
#define NUM_PLANTS	[5,10]		// random number of plants per location [minimum,maximum]
#define SPACING		5			// number of meters between plant groupings, no not use less than 5
#define ALLOW_NEW	true		// allow new farms to spawn when existing ones are cleared
#define DEBUG		true		// turning this to true will turn on rpt entries
#define MARKER		"Select"	// list of different marker types: https://community.bistudio.com/wiki/cfgMarkers
#define COLOR		"ColorGreen"// list of marker colors: https://community.bistudio.com/wiki/CfgMarkerColors_Arma_3

Weed_Farm_Positions = [];		// DO NOT CHANGE THIS LINE
Weed_Farm_Markers = [];			// DO NOT CHANGE THIS LINE

_spawnNewFarm = {
	_pos = [getMarkerPos "center",0,(((getMarkerSize "center") select 1)*0.75),10,0,.3,0] call BIS_fnc_findSafePos;
	Weed_Farm_Positions set [count Weed_Farm_Positions, _pos];
	_numPlants = round(random((NUM_PLANTS select 1) - (NUM_PLANTS select 0)) + (NUM_PLANTS select 0));
	_plantPositions = [[(_pos select 0),(_pos select 1),0],_numPlants,SPACING] call fnc_arrangeweed;
	
	{
		_plant = "Fiberplant" createVehicle _x;
		_plant setPos _x;
	} count _plantPositions;
	
	if (DEBUG) then {diag_log format["Spawning Weed Farm at %1",_pos];};
};

FNC_ArrangeWeed = {
    private ["_posi"];
    _pos = _this select 0;
    _amnt = _this select 1;
    _adjust = _this select 2;
    _positions = [];
    _buildDir = 0;
    _buildRow = 0;
    _Row = 0;
    _build = 0;
    _positions set [count _positions,[_pos select 0,_pos select 1,0]];
	_amnt = _amnt - 1;
    for "_i" from 0 to (_amnt-1) do {
            if(_Row > 1)then{_buildRow = _buildRow + 1;_Row = 0;};
            if(_buildDir > 3)then{_buildDir = 0;};
            for "_i" from 0 to _buildRow do {
                    switch (_buildDir) do{
                            case 0:{
                                    _posi = [(_pos select 0),(_pos select 1) + _adjust];
                                    _positions set [count _positions,[_posi select 0,_posi select 1,0]];
                            };
                            case 1:{
                                    _posi = [(_pos select 0) + _adjust,(_pos select 1)];
                                    _positions set [count _positions,[_posi select 0,_posi select 1,0]];
                            };
                            case 2:{
                                    _posi = [(_pos select 0),(_pos select 1) - _adjust];
                                    _positions set [count _positions,[_posi select 0,_posi select 1,0]];
                            };
                            case 3:{
                                    _posi = [(_pos select 0) - _adjust,(_pos select 1)];
                                    _positions set [count _positions,[_posi select 0,_posi select 1,0]];
                            };
                    };
                    _pos = _posi;
                    _build = _build + 1;
                    if(_build >= _amnt)exitWith{};
            };
            _buildDir = _buildDir + 1;
            _Row = _Row + 1;
            if(_build >= _amnt)exitWith{};
    };
    _positions
};

// Spawn initial weed farms
for "_i" from 1 to LOCATIONS do {
	call _spawnNewFarm;
};

while {count Weed_Farm_Positions > 0} do {
	
	{
		//if (count (_x nearEntities ["Fiberplant", 30]) < 1) then { // Does not work. Says _x is undefined.
		if (count(nearestObjects [_x,["Fiberplant"],35]) < 1) then {
			if (DEBUG) then {diag_log format["Weed Farm at %1 Cleared",_x];};
			Weed_Farm_Positions set [_forEachIndex, "delete"];
			Weed_Farm_Positions = Weed_Farm_Positions - ["delete"];
		};

		_marker = createMarker [format ["WeedMarker_%1",_x], _x];
		_marker setMarkerType MARKER;
		_marker setMarkerText "Weed Farm";
		_marker setMarkerColor COLOR;
		Weed_Farm_Markers set [count Weed_Farm_Markers, _marker];
	} forEach Weed_Farm_Positions;

	uiSleep 5; // make the loop sleep for 5 seconds

	if (ALLOW_NEW) then {
		if (count Weed_Farm_Positions < LOCATIONS) then {
			call _spawnNewFarm;
		};
	};

	{
		deleteMarker _x;
		Weed_Farm_Markers = Weed_Farm_Markers - [_x];
	} count Weed_Farm_Markers;
};

if (DEBUG) then {diag_log "All Weed Farms Cleared";};

// Destroy global variables if script ends
Weed_Farm_Positions = nil;
Weed_Farm_Markers = nil;
FNC_ArrangeWeed = nil;
