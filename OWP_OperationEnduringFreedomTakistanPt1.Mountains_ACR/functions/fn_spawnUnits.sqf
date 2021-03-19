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
		["UK3CB_TKC_C_CIV","UK3CB_TKC_C_DOC","UK3CB_TKC_C_PILOT","UK3CB_TKC_C_SPOT","UK3CB_TKC_C_WORKER"],
		"EAST",
		"STEALTH",
		"LIMITED",
		20,
		"OWP_mkr_enemyArea",
		[true,100],
		"BIS",
		true
	] spawn OWP_fnc_spawnUnits;

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

params [["_unitClassArray",objNull],["_unitGroupStr","EAST"],["_unitBehaviour","CARELESS"],["_unitSpeed","LIMITED"],["_unitClassNumber",1],["_unitMarker",""],["_unitPatrol",[false,0]],["_unitPatrolVersion","bis"],["_unitBuilding",false]];

_positionArr = [];

if (_unitBuilding isEqualTo true) then
{
	_positionArr = [_unitMarker,_unitClassNumber] call OWP_fnc_buildingPositions; // custom function
}
else
{
	_positionMarkerCenter = getMarkerPos _unitMarker;
	_positionMarkerSize = selectMax (getMarkerSize _unitMarker);
	_i = 0;
	while {_i < _unitClassNumber} do
	{
		_i = _i + 1;
		_positionSafe = ([_positionMarkerCenter,(_positionMarkerSize/4),_positionMarkerSize,2,0,0.25,0,[],_positionMarkerCenter] call BIS_fnc_findSafePos) + [0];
		_positionArr pushBack _positionSafe;
	};
};

_i = 0;
{
	_unitPosition = _x;
	
	_i = _i + 1;
	
	_unitGroup = grpNull;
	switch _unitGroupStr do
	{
		case "WEST": {_unitGroup = createGroup [WEST,true]; createCenter WEST;};
		case "EAST": {_unitGroup = createGroup [EAST,true]; createCenter EAST;};
		case "CIV": {_unitGroup = createGroup [CIVILIAN,true]; createCenter CIVILIAN;};
		case "GUER": {_unitGroup = createGroup [RESISTANCE,true]; createCenter RESISTANCE;};
	};
	
	_unitGroupName = format ["Sierra %1-%2",_unitClassNumber,_i];
	_unitGroup setBehaviour _unitBehaviour;
	_unitGroup setGroupID [_unitGroupName];
	_unitGroup setSpeedMode _unitSpeed;

	_unitClass = selectRandom _unitClassArray;
	
	_unitObject = _unitGroup createUnit [_unitClass, [0,0,0], [], 0, "CAN_COLLIDE"];
	_unitObject setPosATL _unitPosition;
	_unitObject setDir round(random 360);
	
	[_unitGroup,true] remoteExec ["enableDynamicSimulation",0];
	
	_unitSkill = selectRandom ["VERY LOW","LOW","REGULAR","MEDIUM","HIGH","ELITE","VIPER"];
	[_unitObject,_unitSkill] spawn OWP_fnc_aiSetSkill; // custom function
	
	_unitPatrolDistance = _unitPatrol select 1;
	_unitPatrolInit = _unitPatrol select 0;
	
	if (_unitPatrolInit isEqualTo true) then
	{
		if ((toUpper _unitPatrolVersion) isEqualTo "BIS") then
		{
			_unitPatrolTask = [_unitGroup,_unitPosition,_unitPatrolDistance] call BIS_fnc_taskPatrol; // bis function
		}
		else
		{
			_unitPatrolTask = [_unitGroup,_unitPosition,_unitPatrolDistance,5,"MOVE",_unitBehaviour,"STEALTH",_unitSpeed,"","",[1,2,3]] call CBA_fnc_taskPatrol; // cba function
		};
	}
	else
	{
		_unitObject disableAI "PATH"; // makes ai stand where they are placed and not move away
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
