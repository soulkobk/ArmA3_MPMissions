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
	
	Name: fn_spawnAnimals.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:

	Parameter(s):
	
	[
		"grabinInitSpawn", // unique label/string to spawned ai
		["O_R_Patrol_Soldier_A_F","O_R_Patrol_Soldier_AR2_F","O_R_Patrol_Soldier_AR_F"], // array of ai classes
		"CIV", // side of ai animals
		"STEALTH", // behaviour of ai animals
		"LIMITED", // speed of ai animals
		12, // amount of ai animals to spawn
		"KOBK_mkr_grabinTown", // map marker name to spawn ai animals at
		"PATROL", // "PATROL", "SEEK", "STAND" are the current options.
		100, // if patrol set as distance, if seek set as marker name, if stand set as nil
		true, // spawn ai in cover? if true, will spawn ai in/next to a tree or bush
		true, // enable dynamic simulation for ai animals?
		false // find a building position to spawn the ai animals at instead?
	] spawn KOBK_fnc_spawnanimals;

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
		"STEALTH"

	SPEED MODE...
		"UNCHANGED" (unchanged)
		"LIMITED" (half speed)
		"NORMAL" (full speed, maintain formation)
		"FULL" (do not wait for any other animals in formation)

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

params [
	["_spawnIdentifier",""], // Unique string (description), eg "trigger_1", "firstWaveEnemy_0" to identify already spawned animal.
	["_animalClassArray",[]], // Animal class array
	["_animalGroupStr","EAST"], // Animal side
	["_animalBehaviour","CARELESS"], // Animal behaviour
	["_animalSpeed","LIMITED"], // Animal speed
	["_animalClassNumber",1], // how many Animal to spawn?
	["_animalMarkerSpawnName",""], // marker name of spawn position
	["_animalControl","PATROL"], // "PATROL","SEEK","NONE"
	["_animalControlInfo",100], // 100,[0,0,0],"KOBK_mkr_enemyArea",nil
	["_animalControlCover",true], // true spawns in cover under a tree/bush, false spawn wherever there is a safe position
	["_animalDynamicSimulation",false], // Enable dynamic simulation for animal?
	["_animalBuilding",false] // start in a building?
];

_positionArr = [];

if (_animalBuilding isEqualTo true) then
{
	_positionArr = [_animalMarkerSpawnName,_animalClassNumber] call KOBK_fnc_buildingPositions; // custom function
}
else
{
	_positionMarkerCenter = getMarkerPos _animalMarkerSpawnName;
	_positionMarkerSizeMin = 12.5;
	_positionMarkerSizeMax = selectMax getMarkerSize _animalMarkerSpawnName;
	if (_positionMarkerSizeMax isEqualTo 0) then
	{
		_positionMarkerSizeMax = 125;
	};
	while {(count _positionArr) < _animalClassNumber} do
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
	_animalPosition = _x;
	_i = _i + 1;

	_animalGroup = grpNull;
	switch (_animalGroupStr) do
	{
		case "WEST": {_animalGroup = createGroup [WEST,true]; createCenter WEST;};
		case "EAST": {_animalGroup = createGroup [EAST,true]; createCenter EAST;};
		case "CIV": {_animalGroup = createGroup [CIVILIAN,true]; createCenter CIVILIAN;};
		case "GUER": {_animalGroup = createGroup [RESISTANCE,true]; createCenter RESISTANCE;};
	};

	_animalGroupName = format ["Sierra %1-%2",_animalClassNumber,_i];
	_animalGroup setBehaviour _animalBehaviour;
	_animalGroup setGroupID [_animalGroupName];
	_animalGroup setSpeedMode _animalSpeed;
	_animalClass = selectRandom _animalClassArray;
	_animalObject = _animalGroup createUnit [_animalClass, [0,0,0], [], 0, "CAN_COLLIDE"];
	waitUntil {alive _animalObject};
		if (_animalControlCover isEqualTo true) then
	{
		_animalPositionSize = 12.5;
		_animalPositionCover = (nearestTerrainObjects [_animalPosition, ["BUSH","TREE"], _animalPositionSize]);
		while {_animalPositionCover isEqualTo []} do
		{
			_animalPositionSize = _animalPositionSize + _animalPositionSize;
			_animalPositionCover = (nearestTerrainObjects [_animalPosition, ["BUSH","TREE"], _animalPositionSize]);
		};
		_animalObject setPosATL (getPosATL (selectRandom _animalPositionCover));
	}
	else
	{
		_animalObject setPosATL _animalPosition;
	};
	_animalObject setDir round(random 360);
	_animalObject setVariable ["spawnIdentifier",_spawnIdentifier,true];

	_animalName = selectRandom ["Charlie","Max","Buddy","Oscar","Milo","Archie","Ollie","Toby","Jack","Teddy","Bella","Molly","Coco","Ruby","Lucy","Bailey","Daisy","Rosie","Lola","Frankie"];
	_animalObject setName [ format ["Animal %1",_animalName],"Animal",_animalName];

	if (_animalDynamicSimulation isEqualTo true) then
	{
		[_animalGroup,true] remoteExec ["enableDynamicSimulation",0];
	};

	_animalSkill = selectRandom ["VERY LOW","LOW","REGULAR","MEDIUM","HIGH","ELITE","VIPER"];
	[_animalObject,_animalSkill] spawn KOBK_fnc_aiSetSkill; // custom function

	switch (_animalControl) do
	{
		case "PATROL": {
			if !(_animalControlInfo isEqualType 0) exitWith {[_animalControlInfo,"isEqualType",0] call BIS_fnc_errorParamsType}; // scalar only (distance to patrol)
			_animalTask = [_animalGroup,_animalPosition,_animalControlInfo,5,"MOVE",_animalBehaviour,"STEALTH",_animalSpeed,"","",[1,2,3]] call CBA_fnc_taskPatrol;
		};
		case "SEEK": {
			if !(_animalControlInfo isEqualTypeAny [[],""]) exitWith {[_animalControlInfo,"isEqualTypeAny",[[],""]] call BIS_fnc_errorParamsType}; // array (position) or string (map marker name)
			_animalTask = [_animalGroup,_animalPosition,(getMarkerPos _animalControlInfo)] call KOBK_fnc_taskSeekAndDestroy;
		};
		case "STAND": {
			_animalObject disableAI "PATH";
		};
	};

	{
		_curator = _x;
		_curator addCuratorEditableObjects [[_animalObject],true];
		if !(vehicle _animalObject isEqualTo _animalObject) then
		{
			_curator addCuratorEditableObjects [[vehicle _animalObject],true];
		};
	} forEach allCurators;
} forEach _positionArr;

[] spawn KOBK_fnc_unitEventHandlers;
