/*
	----------------------------------------------------------------------------------------------

	Copyright © 2020 soulkobk (soulkobk.blogspot.com)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.

	----------------------------------------------------------------------------------------------

	Name: fn_medevacSpawn.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 7:50 PM 6/01/2020
	Modification Date: 7:50 PM 6/01/2020

	Description: for use with ace medical system

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

_medevacUnits = [
	"B_W_Soldier_AR_F",
	"B_W_Medic_F",
	"B_W_Engineer_F",
	"B_W_Soldier_Exp_F",
	"B_W_soldier_M_F",
	"B_W_Soldier_F",
	"B_W_Soldier_LAT_F",
	"B_W_Soldier_TL_F",
	"B_W_Soldier_UAV_F"
];

_enemyUnits = [
	"O_R_Soldier_AR_F",
	"O_R_medic_F",
	"O_R_soldier_exp_F",
	"O_R_Soldier_GL_F",
	"O_R_JTAC_F",
	"O_R_soldier_M_F",
	"O_R_Soldier_LAT_F",
	"O_R_Soldier_TL_F",
	"O_R_Patrol_Soldier_AR2_F",
	"O_R_Patrol_Soldier_AR_F",
	"O_R_Patrol_Soldier_Engineer_F",
	"O_R_Patrol_Soldier_GL_F",
	"O_R_Patrol_Soldier_M2_F",
	"O_R_Patrol_Soldier_LAT_F",
	"O_R_Patrol_Soldier_M_F",
	"O_R_Patrol_Soldier_TL_F",
	"O_R_recon_AR_F",
	"O_R_recon_exp_F",
	"O_R_recon_GL_F",
	"O_R_recon_M_F",
	"O_R_recon_medic_F",
	"O_R_recon_LAT_F",
	"O_R_Patrol_Soldier_A_F",
	"O_R_Patrol_Soldier_Medic",
	"O_R_recon_JTAC_F",
	"O_R_recon_TL_F"
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

if !(isServer) exitWith {};

params [["_timeToComplete",600],["_dayOrNight","DAY"]];

if !(typeName _timeToComplete isEqualTo "SCALAR") exitWith {};
if !(typeName _dayOrNight isEqualTo "STRING") exitWith {};

if ((missionNamespace getVariable ["KOBK_var_medevacSpawnZone",false]) isEqualTo true) exitWith
{
	_medevacString = "[MEDEVAC] MEDEVAC ALREADY IN PROGRESS, EXITING.";
	diag_log _medevacString;
	[_medevacString] remoteExec ["SystemChat",[0,-2] select isDedicated];
};

switch (_dayOrNight) do
{
	case "DAY": {[[2020,01,01,selectRandom [09,10,11,12,13,14],00]] remoteExec ["setDate"];};
	case "NIGHT": {[[2020,01,01,selectRandom [21,22,23,00,01,02],00]] remoteExec ["setDate"];};
};

_medevacSpawnMarker = selectRandom (allMapMarkers select {((_x splitString "_") select 2) isEqualTo "medevacLocation"});
_medevacFriendlyAmount = selectRandom [2,4,6,8,10,12];

[
	_medevacSpawnMarker,
	_medevacUnits,
	"CIV",
	"STEALTH",
	"NORMAL",
	_medevacFriendlyAmount,
	_medevacSpawnMarker,
	"STAND",
	nil,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

_medevacEnemyAmount = selectRandom [2,4,6,8,10,12];

[
	_medevacSpawnMarker,
	_enemyUnits,
	"EAST",
	"STEALTH",
	"NORMAL",
	_medevacEnemyAmount,
	_medevacSpawnMarker,
	"PATROL",
	50,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

_medevacUnitObjectsAtBase = allUnits select {!(isPlayer _x) && _x inArea "KOBK_mkr_natoBaseMedicalTents" && str side _x in ["WEST","CIV"]};
{
	_evacuated = _x;
	_stretcher = _evacuated getVariable ["KOBK_var_medevacStretcher",objNull];
	if !(_stretcher isEqualTo objNull) then
	{
		_stretcher setVariable ["KOBK_var_medevacStretcherIsOccupied",false,true];
		_evacuated setDammage 1;
		deleteVehicle _evacuated;
	};
} forEach _medevacUnitObjectsAtBase;

missionNamespace setVariable ["KOBK_var_medevacSpawnZone",true,true];
_medevacSpawnMarker setMarkerAlpha 1;

// _medevacString = format ["[MEDEVAC] INITIATED, CHECK YOUR MAP SOLDIERS. YOU HAVE %1 MINUTES TO COMPLETE THE MISSION.",[((_timeToComplete)/60)+.01,"HH:MM"] call BIS_fnc_timeToString];
_medevacString = format ["[MEDEVAC] INITIATED, CHECK YOUR MAP SOLDIERS. YOU HAVE %1 TO COMPLETE THE MISSION.",[((_timeToComplete)/60)+.01,"HH:MM"] call BIS_fnc_timeToString];
[_medevacString] remoteExec ["SystemChat",[0,-2] select isDedicated];

sleep 10;

_medevacUnitObjects = allUnits select {!(isPlayer _x) && _x inArea _medevacSpawnMarker && str side _x in ["WEST","CIV"]};
{
	[_x,true,_timeToComplete,true] call ACE_medical_fnc_setUnconscious;
	_x call KOBK_fnc_addRandomDamageToUnit;
	_medevacMarker = createMarker ["KOBK_mkr_medevacMarker_" + str (getPosATL _x), getPosATL _x];
	_medevacMarker setMarkerType "n_med";
	_medevacMarker setMarkerAlpha 1;
	[_x,_medevacMarker] spawn
	{
		params ["_medevac","_medevacMarker"];
		_medevacMarkerUpdate = true;
		while {_medevacMarkerUpdate} do
		{
			if !(isNil "_medevac") then
			{
				if (_medevac isEqualTo objNull) then {_medevacMarkerUpdate = false};
				if !(alive _medevac) then {_medevacMarkerUpdate = false};
				if ((getMarkerType _medevacMarker) isEqualTo "") then {_medevacMarkerUpdate = false};
				_medevacMarker setMarkerPos (getPosATL _medevac);
				sleep 0.5;		
			};
		};
		deleteMarker _medevacMarker;
	};
} forEach _medevacUnitObjects;
	
_medevacSpawnTimer = missionNamespace setVariable ["KOBK_var_medevacSpawnTimer",_timeToComplete,true];
_osdMedevacTimer = [] remoteExec ["KOBK_fnc_medevacTimer",[0,-2] select isDedicated]; // spawn the on screen timer for all connected clients

_loopTimerWait = time;
while {missionNamespace getVariable ["KOBK_var_medevacSpawnZone",false] isEqualTo true} do // kept the timer server side due to JIP, easiest way to implement.
{
	_loopTimerStart = time;
	_medevacSpawnTimer = missionNamespace setVariable ["KOBK_var_medevacSpawnTimer",_timeToComplete,true];
	_loopTimerFinish = time;
	if ((_loopTimerFinish - _loopTimerStart) > 0) then // use this to keep accurate track of timing server side (just incase server stalls in scheduled environment).
	{
		_loopTimerWait = time + 1 + (_loopTimerFinish - _loopTimerStart);
		_timeToComplete = _timeToComplete - 1 - (_loopTimerFinish - _loopTimerStart);
	}
	else
	{
		_loopTimerWait = time + 1;
		_timeToComplete = _timeToComplete - 1;
	};
	waitUntil {time > _loopTimerWait};
	if ((_timeToComplete <= 0) || (({!(isPlayer _x) && _x inArea _medevacSpawnMarker && str side _x in ["WEST","CIV"]} count allUnits) isEqualTo 0)) exitWith
	{
		missionNamespace setVariable ["KOBK_var_medevacSpawnZone",false,true];
		missionNamespace setVariable ["KOBK_var_medevacSpawnTimer",-1,true];
	};
};
if (_timeToComplete <= 0) then
{
	[format ["[MEDEVAC] TIMEOUT, EVACUATION FAILED.",(_timeToComplete / 60)]] remoteExec ["SystemChat",[0,-2] select isDedicated];
}
else
{
	[format ["[MEDEVAC] COMPLETE, EVACUATION SUCCESS.",(_timeToComplete / 60)]] remoteExec ["SystemChat",[0,-2] select isDedicated];
};

_medevacUnitObjects = nearestObjects [getMarkerPos _medevacSpawnMarker,["CAMANBASE"],(selectMax (getMarkerSize _medevacSpawnMarker) * 3)] select {alive _x && !(isPlayer _x) && str side _x in ["WEST","CIV"]};

_waitTime = time + 10;
waitUntil {time > _waitTime};

{
	deleteVehicle _x;
} forEach _medevacUnitObjects;

{
	if ((getMarkerPos _x) inArea _medevacSpawnMarker) then
	{
		deleteMarker _x;
	};
} forEach (allMapMarkers select {((_x splitString "_") select 2) isEqualTo "medevacMarker"});

_enemyUnitObjects = nearestObjects [getMarkerPos _medevacSpawnMarker,["CAMANBASE"],(selectMax (getMarkerSize _medevacSpawnMarker) * 3)] select {alive _x && !(isPlayer _x) && str side _x in ["EAST","GUER"]};

_waitTime = time + 60;
waitUntil {time > _waitTime};

{
	deleteVehicle _x;
} forEach _enemyUnitObjects;

_medevacSpawnMarker setMarkerAlpha 0;

// this addAction ["Medevac Day 10min",{[600,"DAY"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Day 20min",{[1200,"DAY"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Day 30min",{[1800,"DAY"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Day 40min",{[2400,"DAY"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Day 50min",{[3000,"DAY"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Day 60min",{[3600,"DAY"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Night 10min",{[600,"NIGHT"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Night 20min",{[1200,"NIGHT"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""]; 
// this addAction ["Medevac Night 30min",{[1800,"NIGHT"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Medevac Night 40min",{[2400,"NIGHT"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Medevac Night 50min",{[3000,"NIGHT"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Medevac Night 60min",{[3600,"NIGHT"] remoteExec ["KOBK_fnc_medevacSpawn",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];