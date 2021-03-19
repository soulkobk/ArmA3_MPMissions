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
	
	Name: fn_spawnDogs.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:

	Parameter(s):
	
	[
		"EAST",
		"STEALTH",
		"LIMITED",
		20,
		"OWP_mkr_enemyArea",
		[true,100]
	] spawn OWP_fnc_spawnDogs;

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

params [["_dogeGroupStr","EAST"],["_dogeBehaviour","CARELESS"],["_dogeSpeed","NORMAL"],["_dogeClassNumber",1],["_dogeMarker",""],["_dogePatrol",[false,0]]];

for [{_i=0},{_i<_dogeClassNumber},{_i=_i+1}] do
{
	_dogeGroup = grpNull;
	switch _dogeGroupStr do
	{
		case "WEST": {_dogeGroup = createGroup [WEST,true]; createCenter WEST;};
		case "EAST": {_dogeGroup = createGroup [EAST,true]; createCenter EAST;};
		case "CIV": {_dogeGroup = createGroup [CIVILIAN,true]; createCenter CIVILIAN;};
		case "GUER": {_dogeGroup = createGroup [RESISTANCE,true]; createCenter RESISTANCE;};
	};
	
	_dogeGroupName = format ["Doge %1-%2",_dogeClassNumber,_i];
	_dogeGroup setBehaviour _dogeBehaviour;
	_dogeGroup setGroupID [_dogeGroupName];
	_dogeGroup setSpeedMode _dogeSpeed;

	_dogeMarkerCenter = getMarkerPos _dogeMarker;
	_dogeMarkerSize = selectMax (getMarkerSize _dogeMarker);
	_dogePosition = ([_dogeMarkerCenter,(_dogeMarkerSize/6),_dogeMarkerSize,2,0,0.25,0,[],_dogeMarkerCenter] call BIS_fnc_findSafePos) + [0];
	_dogeObject = _dogeGroup createUnit ['Alsatian_Random_F',_dogePosition,[],10,'FORM'];
	_dogeObject setPosATL _dogePosition;
	_dogeObject setDir round(random 360);
	
	_dogeName = selectRandom ["Charlie","Max","Buddy","Oscar","Milo","Archie","Ollie","Toby","Jack","Teddy","Bella","Molly","Coco","Ruby","Lucy","Bailey","Daisy","Rosie","Lola","Frankie"];
	_dogeObject setName [ format ["Doge %1",_dogeName],"Doge",_dogeName];
	
	[_dogeGroup,true] remoteExec ["enableDynamicSimulation",0]; // add group to simulation system via dedicated/server (global effect)

	_dogePatrolDistance = _dogePatrol select 1;
	_dogePatrolInit = _dogePatrol select 0;
	
	if (_dogePatrolInit isEqualTo true) then
	{
		// _dogePatrolTask = [_dogeGroup,_dogePosition,_dogePatrolDistance] call BIS_fnc_taskPatrol; // bis function
		_dogePatrolTask = [_dogeGroup,_dogePosition,_dogePatrolDistance,5,"MOVE",_dogeBehaviour,"STEALTH",_dogeSpeed,"","",[1,2,3]] call CBA_fnc_taskPatrol; // cba function
	}
	else
	{
		_dogeObject disableAI "PATH";
	};
	{
		_curator = _x;
		_curator addCuratorEditableObjects [[_dogeObject],true];
		if !(vehicle _dogeObject isEqualTo _dogeObject) then
		{
			_curator addCuratorEditableObjects [[vehicle _dogeObject],true];
		};
	} forEach allCurators;
};

// Sheep_random_F
// Goat_random_F
// Fin_random_F
// Cock_random_F
// Hen_random_F
// Snake_vipera_random_F
// Snake_random_F