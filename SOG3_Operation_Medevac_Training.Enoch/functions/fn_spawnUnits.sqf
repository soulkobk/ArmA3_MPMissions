/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2019 soulkobk (soulkobk.blogspot.com)

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
	
	Name: fn_spawnUnits.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:

	Parameter(s):
	
	[
		"grabinInitSpawn", // unique label/string to spawned ai
		["O_R_Patrol_Soldier_A_F","O_R_Patrol_Soldier_AR2_F","O_R_Patrol_Soldier_AR_F"], // array of ai classes
		"CIV", // side of ai units
		"STEALTH", // behaviour of ai units
		"NORMAL", // speed of ai units
		12, // amount of ai units to spawn
		"KOBK_mkr_grabinTown", // map marker name to spawn ai units at
		"PATROL", // "PATROL", "SEEK", "STAND" are the current options.
		100, // if patrol set as distance, if seek set as marker name, if stand set as nil
		false, // spawn ai in cover? if true, will spawn ai in/next to a tree or bush
		true, // enable dynamic simulation for ai units?
		true // find a building position to spawn the ai units at instead?
	] spawn KOBK_fnc_spawnUnits;

	SIDE...
		"WEST"
		"EAST"
		"IND"
		"CIV"

	BEHAVIOUR...
		"CARELESS"
		"SAFE"
		"AWARE"
		"COMBAT"
		"STEALTH".

	SPEED MODE...
		"UNCHANGED" (unchanged)
		"LIMITED" (half speed)
		"NORMAL" (full speed, maintain formation)
		"FULL" (do not wait for any other units in formation)

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

params [
	["_spawnIdentifier",""], // Unique string (description), eg "trigger_1", "firstWaveEnemy_0" to identify already spawned AI.
	["_unitClassArray",[]], // AI class array
	["_unitGroupStr","EAST"], // AI side
	["_unitBehaviour","CARELESS"], // AI behaviour
	["_unitSpeed","LIMITED"], // AI speed
	["_unitClassNumber",1], // how many AI to spawn?
	["_unitMarkerSpawnName",""], // marker name of spawn position
	["_unitControl","PATROL"], // "PATROL","SEEK","NONE"
	["_unitControlInfo",100], // 100,[0,0,0],"KOBK_mkr_enemyArea",nil
	["_unitControlCover",true], // true spawns in cover under a tree/bush, false spawn wherever there is a safe position
	["_unitDynamicSimulation",false], // Enable dynamic simulation for unit?
	["_unitBuilding",false] // start in a building?
];

_positionArr = [];

if (_unitBuilding isEqualTo true) then
{
	_positionArr = [_unitMarkerSpawnName,_unitClassNumber] call KOBK_fnc_buildingPositions; // custom function
}
else
{
	_positionMarkerCenter = getMarkerPos _unitMarkerSpawnName;
	_positionMarkerSizeMin = 12.5;
	_positionMarkerSizeMax = selectMax getMarkerSize _unitMarkerSpawnName;
	if (_positionMarkerSizeMax isEqualTo 0) then
	{
		_positionMarkerSizeMax = 125;
	};
	while {(count _positionArr) < _unitClassNumber} do
	{
		_positionSafe = ([_positionMarkerCenter,_positionMarkerSizeMin,_positionMarkerSizeMax,2,0,0.25,0,[],_positionMarkerCenter] call BIS_fnc_findSafePos) + [0];
		if ((count _positionSafe) isEqualTo 3) then
		{
			_positionArr pushBack _positionSafe;
		}
		else 
		{
			_positionMarkerSize = _positionMarkerSize + _positionMarkerSize;
		};
	};
};

_i = 0;
{
	_unitPosition = _x;
	_i = _i + 1;

	_unitGroup = grpNull;
	switch (_unitGroupStr) do
	{
		case "WEST": {_unitGroup = createGroup [WEST,true]; createCenter WEST;};
		case "EAST": {_unitGroup = createGroup [EAST,true]; createCenter EAST;};
		case "CIV": {_unitGroup = createGroup [CIVILIAN,true]; createCenter CIVILIAN;};
		case "GUER": {_unitGroup = createGroup [RESISTANCE,true]; createCenter RESISTANCE;};
	};

	_unitGroupName = format ["%1 %2-%3",_spawnIdentifier,_unitClassNumber,_i];
	_unitGroup setBehaviour _unitBehaviour;
	_unitGroup setGroupID [_unitGroupName];
	_unitGroup setSpeedMode _unitSpeed;
	_unitClass = selectRandom _unitClassArray;
	_unitObject = _unitGroup createUnit [_unitClass, [0,0,0], [], 0, "CAN_COLLIDE"];
	waitUntil {alive _unitObject};
	if (_unitControlCover isEqualTo true) then
	{
		_unitPositionSize = 12.5;
		_unitPositionCover = (nearestTerrainObjects [_unitPosition, ["BUSH","TREE"], _unitPositionSize]);
		while {_unitPositionCover isEqualTo []} do
		{
			_unitPositionSize = _unitPositionSize + _unitPositionSize;
			_unitPositionCover = (nearestTerrainObjects [_unitPosition, ["BUSH","TREE"], _unitPositionSize]);
		};
		_unitObject setPosATL (getPosATL (selectRandom _unitPositionCover));
	}
	else
	{
		_unitObject setPosATL _unitPosition;
	};
	_unitObject setDir round(random 360);
	_unitObject setVariable ["spawnIdentifier",_spawnIdentifier,true];
	
	_unitObject triggerDynamicSimulation false;

	if (_unitDynamicSimulation isEqualTo true) then
	{
		[_unitGroup,true] remoteExec ["enableDynamicSimulation",0];
	};

	_unitSkill = selectRandom ["VERY LOW","LOW","REGULAR","MEDIUM","HIGH","ELITE","VIPER"];
	[_unitObject,_unitSkill] spawn KOBK_fnc_aiSetSkill; // custom function
	[_unitObject] spawn KOBK_fnc_unitEventHandler;
	
	_unitObject addEventHandler ["KILLED", {(_this select 0) spawn KOBK_fnc_corpseCleanupHandler}]; // custom function

	switch (_unitControl) do
	{
		case "PATROL": {
			if !(_unitControlInfo isEqualType 0) exitWith {[_unitControlInfo,"isEqualType",0] call BIS_fnc_errorParamsType}; // scalar only (distance to patrol)
			_unitTask = [_unitGroup,_unitPosition,_unitControlInfo,5,"MOVE",_unitBehaviour,selectRandom ["GREEN","WHITE","YELLOW","RED"],_unitSpeed,selectRandom ["COLUMN","STAG COLUMN","WEDGE","VEE","LINE"],"",[3,6,9]] call CBA_fnc_taskPatrol;
		};
		case "SEEK": {
			if !(_unitControlInfo isEqualTypeAny [[],""]) exitWith {[_unitControlInfo,"isEqualTypeAny",[[],""]] call BIS_fnc_errorParamsType}; // array (position) or string (map marker name)
			_unitTask = [_unitGroup,_unitPosition,(getMarkerPos _unitControlInfo)] call KOBK_fnc_taskSeekAndDestroy;
		};
		case "STAND": {
			_unitObject disableAI "PATH";
		};
	};

	{
		_curator = _x;
		_curator addCuratorEditableObjects [[_unitObject],true];
		if !(vehicle _unitObject isEqualTo _unitObject) then
		{
			_curator addCuratorEditableObjects [[vehicle _unitObject],true];
		};
	} forEach allCurators;
} forEach _positionArr;
