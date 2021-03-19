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

	Name: OWP_fnc_zeusInitServer.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 1/09/2019
	Modification Date: 12:00 PM 1/09/2019

	Description:

	Parameter(s):
	
	initPlayerLocal.sqf, add the below code to it.
		[] spawn
		{
			waitUntil {!isNil "OWP_var_whiteListedZeus"};
			waitUntil {!isNil "OWP_var_zeusInit"};
			waitUntil {!isNull findDisplay 46};
			_curatorArr = allCurators select {((_x getVariable ["UID","0"]) isEqualTo (getPlayerUID player))};
			if !(_curatorArr isEqualTo []) then
			{
				_curator = _curatorArr select 0;
				[_curator] remoteExec ["unassignCurator",[0,-2] select isDedicated];
				waitUntil {((getAssignedCuratorLogic player) isEqualTo objNull)};
				_curatorAllocated = false;
				while {!(_curatorAllocated)} do
				{
					[player,_curator] remoteExec ["assignCurator",[0,-2] select isDedicated];
					_curator setVariable ["name",name player,true];
					uiSleep 1;
					if !((getAssignedCuratorLogic player) isEqualTo objNull) then
					{
						_curatorAllocated = true;
					};
				};
				player onMapSingleClick "if (_alt) then {vehicle player setPos _pos}"; // for teleport
				systemChat format ["[MISSION] %1, zeus access granted (%2 keybind)",name player,((actionKeysNames "CuratorInterface") splitString """" select 0)];
			};
		};
	
	onPlayerRespawn.sqf, add the below code to it.
		[] spawn
		{
			if ((!isNil "OWP_var_whiteListedZeus") && (!isNil "OWP_var_zeusInit")) then
			{
				_curatorArr = allCurators select {((_x getVariable ["UID","0"]) isEqualTo (getPlayerUID player))};
				if !(_curatorArr isEqualTo []) then
				{
					_curator = _curatorArr select 0;
					[_curator] remoteExec ["unassignCurator",[0,-2] select isDedicated];
					waitUntil {((getAssignedCuratorLogic player) isEqualTo objNull)};
					_curatorAllocated = false;
					while {!(_curatorAllocated)} do
					{
						[player,_curator] remoteExec ["assignCurator",[0,-2] select isDedicated];
						_curator setVariable ["name",name player,true];
						uiSleep 1;
						if !((getAssignedCuratorLogic player) isEqualTo objNull) then
						{
							_curatorAllocated = true;
						};
					};
					player onMapSingleClick "if (_alt) then {vehicle player setPos _pos}"; // for teleport
				};
			};
		};
		
	Example:

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

waitUntil {!(OWP_var_whiteListedZeus isEqualTo [])};

_i = 0;
{
	_i = _i + 1;
	_playerUID = _x;

	_zeusLogicGroup = createGroup sideLogic;
	_zeusLogicObject = _zeusLogicGroup createUnit ["Logic",[0,0,0],[],0,"NONE"];
	waitUntil {!isNull _zeusLogicObject};

	_zeusCurator = _zeusLogicGroup createUnit ["ModuleCurator_F",[0,0,0],[],0,"NONE"];
	waitUntil {!isNull _zeusCurator};
	
	_zeusCurator addCuratorPoints 1;
	_zeusCurator addCuratorEditingArea [_i,[worldSize/2,worldSize/2,0],worldSize];
	_zeusCurator setCuratorEditingAreaType true;

	_zeusCurator setCuratorCoef ["place",0];
	_zeusCurator setCuratorCoef ["delete",0];
	_zeusCurator setCuratorCoef ["edit",0];
	_zeusCurator setCuratorCoef ["destroy",0];
	_zeusCurator setCuratorCoef ["group",0];
	_zeusCurator setCuratorCoef ["synchronize",0];

	_zeusCurator setVehicleVarName format ["%1",_playerUID];
	_zeusCurator setVariable ["UID",_playerUID,true];

	[_zeusCurator,[-1,-2,0,1]] call BIS_fnc_setCuratorVisionModes;

	_zeusCurator setVariable ["showNotification",false,true];
	_zeusCurator setVariable ["forced",0,true];
	_zeusCurator setVariable ["owner",_playerUID,true];

	_cfgPatches = (configFile >> "CfgPatches");
	_zeusCuratorAddons = [];
	for "_i" from 0 to ((count _cfgPatches) - 1) do
	{
		_cfgName = configName (_cfgPatches select _i);
		_zeusCuratorAddons pushBack _cfgName;
	};
	if (count _zeusCuratorAddons > 0) then
	{
		_zeusCurator addCuratorAddons _zeusCuratorAddons
	};

	_zeusCurator addEventHandler ["CuratorObjectPlaced",{_this remoteExecCall ["OWP_fnc_zeusAddObject"];}];
	_zeusCurator addEventHandler ["CuratorObjectDeleted",{_this remoteExecCall ["OWP_fnc_zeusDeleteObject"];}];

} forEach OWP_var_whiteListedZeus;

_zeusCuratorVehicles = (nearestObjects [[0,0,0], ["AllVehicles"], 10000]);
{
	_zeusCurator = _x;
	_zeusCurator addCuratorEditableObjects [_zeusCuratorVehicles,true];
} forEach allCurators;

OWP_var_zeusInit = true;
publicVariable "OWP_var_zeusInit";
