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
	
	Name: fn_suicideBomber.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:18 PM 12/09/2019
	Modification Date: 5:18 PM 12/09/2019
	
	Description:

	Parameter(s):

	Example:
	
	For triggers...
	
	Condition...
		(count (allPlayers select {alive _x && _x inArea thisTrigger}) > 0);

	On Activation...
		_alivePlayersInArea = (allPlayers select {alive _x && _x inArea thisTrigger});
		_suicideBomberTarget = selectRandom _alivePlayersInArea;
		[_suicideBomberTarget] spawn OWP_fnc_suicideBomber;
		
	This will then spawn a suicide bomber and have it chase the player until it is dead.
	
	This script will work on ANY object. Buildings, Vehicles, Trees, etc.

	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

params [["_unitTarget",objNull]];

if (_unitTarget isEqualTo objNull) exitWith {};

_unitsCivilian =
[
	"UK3CB_TKC_C_CIV",
	"UK3CB_TKC_C_DOC",
	"UK3CB_TKC_C_PILOT",
	"UK3CB_TKC_C_SPOT",
	"UK3CB_TKC_C_WORKER"
];

_unitSuicideBomberDistance = 100;
_unitSuicideBomberDirection = random 360;

_unitDeployPosRandom = [position _unitTarget, _unitSuicideBomberDistance, _unitSuicideBomberDirection] call BIS_fnc_relPos;
_unitDeployRadius = 12.5;

_unitGroup = createGroup CIVILIAN;
_unitGroupID = groupID _unitGroup;
_unitGroup setGroupIdGlobal [format ["Suicide Bomber - %1",_unitGroupID]];

_unitPosStart = [0,0,0];
_j = 0;
while {sleep 0.5; _j < 100} do
{
	_nearTerrainObjects = (nearestTerrainObjects [_unitDeployPosRandom, ["BUSH"], _unitDeployRadius]);
	if (_nearTerrainObjects isEqualTo []) then
	{
		_unitDeployRadius = _unitDeployRadius + _unitDeployRadius;
	}
	else
	{
		_unitDeployPosRandom = getPosATL (selectRandom _nearTerrainObjects);
		_anyPlayersAround = {alive _x && isPlayer _x} count (nearestObjects [_unitDeployPosRandom, ["MAN"], _unitDeployRadius]);
		if (_anyPlayersAround isEqualTo 0) then
		{
			_unitPosStart = _unitDeployPosRandom;
			_j = 101;
		}
		else
		{
			_unitDeployRadius = _unitDeployRadius + 12.5;
		};
	};
	_j = _j + 1;
};

_unitSuicideBomber = objNull;
if !(_unitPosStart isEqualTo [0,0,0]) then
{
	_unitsCivilian = selectRandom _unitsCivilian;
	if (typeName _unitsCivilian == "ARRAY") then
	{
		_unitsCivilian = selectRandom _unitsCivilian;
	};
	_unitSuicideBomber = _unitGroup createUnit [_unitsCivilian, _unitPosStart, [], 0, "NONE"];
	waitUntil {!isNull _unitSuicideBomber};

	{
		_x addCuratorEditableObjects [[_unitSuicideBomber],false];
	} forEach allCurators;

	_unitSuicideBomber allowDamage true;
	_unitSuicideBomber setDamage 0;
	_unitPosStart set [2,0];
	_unitSuicideBomber setPosATL _unitPosStart;
	_unitSuicideBomber switchMove "AmovPpneMstpSrasWrflDnon"; // makes unit go prone.
	_unitGroup setCombatMode "YELLOW";
	_unitGroup setBehaviour "AWARE";
	_unitGroup setSpeedMode "FULL";
	_unitGroup allowFleeing 0;
	
	removeVest _unitSuicideBomber;
	_unitSuicideBomber addVest "rhsgref_chicom";

	_unitExplosive1 = "DemoCharge_Remote_Ammo" createVehicle (position _unitSuicideBomber);
	_unitExplosive1 attachTo [_unitSuicideBomber, [-0.1,0.1,0.15],"Pelvis"];
	[_unitExplosive1,[[0.5,0.5,0],[-0.5,0.5,0]]] remoteExec ["setVectorDirAndUp",[0,-2] select isDedicated];
	_unitExplosive2 = "DemoCharge_Remote_Ammo" createVehicle (position _unitSuicideBomber);
	_unitExplosive2 attachTo [_unitSuicideBomber, [0,0.15,0.15],"Pelvis"];
	[_unitExplosive2,[[1,0,0],[0,1,0]]] remoteExec ["setVectorDirAndUp",[0,-2] select isDedicated];
	_unitExplosive3 = "DemoCharge_Remote_Ammo" createVehicle (position _unitSuicideBomber);
	_unitExplosive3 attachTo [_unitSuicideBomber, [0.1,0.1,0.15],"Pelvis"];
	[_unitExplosive3,[[0.5,-0.5,0],[0.5,0.5,0]]] remoteExec ["setVectorDirAndUp",[0,-2] select isDedicated];

	sleep 5;
	_unitSuicideBomber switchMove "AmovPpneMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon"; // makes unit stand up.

	_i = 0;
	while {(alive _unitSuicideBomber) && ((_unitSuicideBomber distance _unitTarget) > 10)} do
	{
		if (_i % 10 isEqualTo 0) then
		{
			_unitWaypoint = _unitGroup addWaypoint [position _unitTarget, 0];
			_unitWaypoint setWaypointBehaviour "AWARE";
			_unitWaypoint setWaypointType "MOVE";
			_unitWaypoint setWaypointSpeed "FULL";
		};
		if (_i % 20 isEqualTo 0) then
		{
			deleteWaypoint [_unitGroup, 0];
		};
		sleep 1;
		_i = _i + 1;
	};

	if (alive _unitSuicideBomber) then
	{
		doStop _unitSuicideBomber;
		sleep 1;
		_sound = missionPath + "media\sounds\suicideBomber.ogg";
		_position = getPosASL _unitSuicideBomber;
		_position set [2,((_position select 2) + 1.8)];
		playSound3D [_sound,_unitSuicideBomber,false,_position,5,1,100];
		sleep 1;
		_unitExplosive1 setDamage 1;
		_unitExplosive2 setDamage 1;
		_unitExplosive3 setDamage 1;
		removeVest _unitSuicideBomber;
	}
	else
	{
		deleteVehicle _unitExplosive1;
		deleteVehicle _unitExplosive2;
		deleteVehicle _unitExplosive3;
		removeVest _unitSuicideBomber;
	};
};
