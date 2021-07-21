/*
	Harvestable Hemp Farms for DayZ Epoch 1.0.6+ by JasonTM
	Credit to original author Halv: https://pastebin.com/juMsuJ1r
	Updated for use with the new client side marker manager by JasonTM: 06-26-2021.
*/

#define LOCATIONS	5			// number of concurrent farm locations
#define NUM_PLANTS	[5,10]		// random number of plants per location [minimum,maximum]
#define SPACING		5			// number of meters between plant groupings, no not use less than 5
#define ALLOW_NEW	true		// allow new farms to spawn when existing ones are cleared
#define DEBUG		true		// turning this to true will turn on rpt entries
#define SHOWMARKERS true		// show the locations of the weed farms with markers?
#define MARKER		"Select"	// list of different marker types: https://community.bistudio.com/wiki/cfgMarkers
#define COLOR		"ColorGreen"// list of marker colors: https://community.bistudio.com/wiki/CfgMarkerColors_Arma_3

Weed_Farm_Positions = [];		// DO NOT CHANGE THIS LINE

local _spawnNewFarm = {
	local _pos = [getMarkerPos "center",0,(((getMarkerSize "center") select 1)*0.75),10,0,.3,0] call BIS_fnc_findSafePos;
	local _amnt = round(random((NUM_PLANTS select 1) - (NUM_PLANTS select 0)) + (NUM_PLANTS select 0));
    local _positions = [];
    local _buildDir = 0;
    local _buildRow = 0;
    local _Row = 0;
    local _build = 0;
	local _newPos = [];
	local _markers = [];
    _positions set [count _positions,[_pos select 0,_pos select 1,0]];
	_amnt = _amnt - 1;
	
	while {_amnt > 0} do {
		for "_i" from 0 to _buildRow do {
				_newPos = call {
					if (_buildDir == 0) exitWith {[(_pos select 0),(_pos select 1) + SPACING];};
					if (_buildDir == 1) exitWith {[(_pos select 0) + SPACING,(_pos select 1)];};
					if (_buildDir == 2) exitWith {[(_pos select 0),(_pos select 1) - SPACING];};
					if (_buildDir == 3) exitWith {[(_pos select 0) - SPACING,(_pos select 1)];};
				};
				_positions set [count _positions,[_newPos select 0,_newPos select 1,0]];
				_pos = _newPos;
				_amnt = _amnt - 1;
				if (_amnt < 1) exitWith {};
		};
		_buildDir = _buildDir + 1;
		_Row = _Row + 1;
		if (_Row > 1) then {_buildRow = _buildRow + 1;_Row = 0;};
        if (_buildDir > 3) then {_buildDir = 0;};
	};
	
	{
		local _plant = "Fiberplant" createVehicle _x;
		_plant setPosATL _x;
	} count _positions;
	
	if (DEBUG) then {diag_log format["Spawning Weed Farm at %1",_pos];};

	if (SHOWMARKERS) then {
		//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
		_markers set [0, [_pos, format ["WeedMarker_%1",_pos], COLOR, MARKER, "", "", [], ["STR_CL_HEMP_FARM"], 0]];
		DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
		local _markerIndex = count DZE_ServerMarkerArray - 1;
		Weed_Farm_Positions set [count Weed_Farm_Positions, [_pos,(_markers select 0),_markerIndex]];
		PVDZ_ServerMarkerSend = ["createSingle",(_markers select 0)];
		publicVariable "PVDZ_ServerMarkerSend";
	} else {
		Weed_Farm_Positions set [count Weed_Farm_Positions, [_pos,[],-1]];
	};
};

// Spawn initial weed farms
for "_i" from 1 to LOCATIONS do {
	call _spawnNewFarm;
};

while {count Weed_Farm_Positions > 0} do {
	uiSleep 10; // make the loop sleep for 10 seconds
	
	{
		local _pos = _x select 0;
		if (count (_pos nearObjects ["Fiberplant", 50]) < 1) then {
			if (DEBUG) then {diag_log format["Weed Farm at %1 Cleared",_pos];};
			
			if (SHOWMARKERS) then {
				local _marker = _x select 1;
				local _markerIndex = _x select 2;
				PVDZ_ServerMarkerSend = ["removeSingle", (_marker select 1)];
				publicVariable "PVDZ_ServerMarkerSend";
				DZE_ServerMarkerArray set [_markerIndex, -1];
			};
			
			Weed_Farm_Positions = [Weed_Farm_Positions,_forEachIndex] call fnc_deleteAt;
		};
	} forEach Weed_Farm_Positions;

	if (ALLOW_NEW) then {
		if (count Weed_Farm_Positions < LOCATIONS) then {
			call _spawnNewFarm;
		};
	};
};

if (DEBUG) then {diag_log "All Weed Farms Cleared";};

// Destroy global variable if script ends
Weed_Farm_Positions = nil;
