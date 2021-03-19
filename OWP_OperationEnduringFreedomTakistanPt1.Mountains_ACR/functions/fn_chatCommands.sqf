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
	
	Name: fn_chatCommands.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 11:55 AM 22/08/2019
	Modification Date: 11:55 AM 22/08/2019
	
	Description: none

	Parameter(s): 
	
	place in playerInit.sqf...
	
	player setVariable ["clientOwner",clientOwner,true];
	["owp", {[[(_this select 0),player]] remoteExec ["OWP_fnc_chatCommands",2]}, "admin"] call CBA_fnc_registerChatCommand;

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

params ["_commandArr"];

_commandStr = _commandArr select 0;
_playerOwner = _commandArr select 1;
_otherStr = _commandArr select 2;

_playerOwnerUID = getPlayerUID _playerOwner;
if !(_playerOwnerUID in OWP_var_whiteListedChatCommands) exitWith {}; // allow access only to those that are in the white list.

_command = _commandStr splitString " " select 0;
_commandVar = _commandStr splitString " " select 1;

if (isNil "_commandVar") then
{
	_commandVar = "0";
};

switch _command do
{
	case "skiptime": {
		[_commandVar] spawn
		{
			params ["_commandVar"];
			missionNamespace setVariable ["OWP_var_skiptime",_commandVar,true];
			[[],{titleText [format ["<t color='#ffffff' size='4'>SKIPPING TIME %1 HOUR(S)</t>",missionNamespace getVariable ["OWP_var_skiptime","NIL"]], "BLACK OUT", 2, true, true]}] remoteExec ["call",0];
			sleep 2;
			[(parseNumber _commandVar)] remoteExec ["skipTime"];
			sleep 2;
			[[],{titleText [format ["<t color='#ffffff' size='4'>SKIPPING TIME %1 HOUR(S)</t>",missionNamespace getVariable ["OWP_var_skiptime","NIL"]], "BLACK IN", 2, true, true]}] remoteExec ["call",0];
		};
	};
	case "warn": {
		_playerArr = allPlayers select {(name _x) isEqualTo _commandVar};		
		if !(_playerArr isEqualTo []) then
		{
			_player = _playerArr select 0;
			if (name _player isEqualTo _commandVar) then
			{
				_clientOwner = _player getVariable ["clientOwner",""];
				if !(_clientOwner isEqualTo "") then
				{
					[format ["%1 THIS IS YOUR LAST WARNING!",toUpper _commandVar]] remoteExec ["BIS_fnc_dynamicText",_clientOwner];
					[format ["%1 THIS IS YOUR LAST WARNING!",toUpper _commandVar]] remoteExec ["SystemChat",_clientOwner];
				};
			};
		};		
	};
	case "kill": {
		_playerArr = allPlayers select {(name _x) isEqualTo _commandVar};
		if !(_playerArr isEqualTo []) then
		{
			_player = _playerArr select 0;
			_clientOwner = _player getVariable ["clientOwner",""];
			if !(_clientOwner isEqualTo "") then
			{
				[_player,1] remoteExec ["setDamage",_clientOwner];
			};
		};
	};
	case "launch": {
		_playerArr = allPlayers select {(name _x) isEqualTo _commandVar};
		if !(_playerArr isEqualTo []) then
		{
			_player = _playerArr select 0;
			if !(vehicle _player isEqualTo _player) then
			{
				moveOut _player;
			};
			_velocity = velocity _player; 
			_direction = direction _player; 
			_speed = 500;
			_velocityNew = [(_velocity select 0) + (sin _direction),(_velocity select 1) + (cos _direction),(_velocity select 2) + _speed];
			_clientOwner = _player getVariable ["clientOwner",""];
			if !(_clientOwner isEqualTo "") then
			{
				[_player,_velocityNew] remoteExec ["setVelocity",_clientOwner];
			};
		};
	};
	case "stats": {
		_spawnedRunning = diag_activeScripts select 0;
		_execVMRunning = diag_activeScripts select 1;
		_execRunning = diag_activeScripts select 2;
		_execFSMRunning = diag_activeScripts select 3;
		_total = _spawnedRunning + _execVMRunning + _execRunning + _execFSMRunning;
		format ["[STATS] processes -> spawned %1 - execVM %2 - execs %3 - execFSM %4 - total %5",_spawnedRunning,_execVMRunning,_execRunning,_execFSMRunning,_total] remoteExec ["systemChat",[0,-2] select isDedicated];
		_unitsAlivePlayer = count (allPlayers select {(alive _x) && (simulationEnabled _x)});
		_unitsDeadPlayer = missionNamespace getVariable ["OWP_var_unitsDeadPlayer",0];
		_unitsAliveEnemy = count ((allUnits - allPlayers) select {(alive _x) && (simulationEnabled _x) && (side _x isEqualTo EAST)});
		_unitsDeadEnemy = missionNamespace getVariable ["OWP_var_unitsDeadEnemy",0];
		_unitsAliveCivilian = count ((allUnits - allPlayers) select {(alive _x) && (simulationEnabled _x) && (side _x isEqualTo CIVILIAN)});
		_unitsDeadCivilian = missionNamespace getVariable ["OWP_var_unitsDeadCivilian",0];
		_unitsAliveAnimal = count ((allUnits - allPlayers) select {(alive _x) && (simulationEnabled _x) && ((_x isKindOf "Animal") isEqualTo true)});
		_unitsDeadAnimal = missionNamespace getVariable ["OWP_var_unitsDeadAnimal",0];
		format ["[STATS] active count -> player %1 - enemy %2 - civilian %3 - animal %4",_unitsAlivePlayer,_unitsAliveEnemy,_unitsAliveCivilian,_unitsAliveAnimal] remoteExec ["systemChat",[0,-2] select isDedicated];
		format ["[STATS] death count -> player %1 - enemy %2 - civilian %3 - animal %4",_unitsDeadPlayer,_unitsDeadEnemy,_unitsDeadCivilian,_unitsDeadAnimal] remoteExec ["systemChat",[0,-2] select isDedicated];
		format ["[STATS] server -> fps %1",diag_fps] remoteExec ["systemChat",[0,-2] select isDedicated];
	};
	case "debrief": {
		{
			_player = _x;
			_playerUniform = uniform _player;
			_playerVest = vest _player;
			_playerBackpack = backpack _player;
			_playerPrimaryWeapon = primaryWeapon _player;
			_playerPrimaryWeaponItems = primaryWeaponItems _player;
			_playerHandgunWeapon = handgunWeapon _player;
			_playerHandgunWeaponItems = handgunItems _player;
			_playerSecondaryWeapon = secondaryWeapon _player;
			_playerSecondaryWeaponItems = secondaryWeaponItems _player;
			
			_player unlinkItem (hmd player);
		
			if !(_playerUniform isEqualTo "") then
			{
				removeUniform _player;
				waitUntil {uniform _player isEqualTo ""};
				_player forceAddUniform _playerUniform;
			};
			if !(_playerVest isEqualTo "") then
			{
				removeVest _player;
				waitUntil {vest _player isEqualTo ""};
				_player addVest _playerVest;
			};
			if !(_playerBackpack isEqualTo "") then
			{
				removeBackpackGlobal _player;
				waitUntil {backpack _player isEqualTo ""};
				_player addBackpackGlobal _playerBackpack;
			};

			if !(_playerPrimaryWeapon isEqualTo "") then
			{
				_player removeWeaponGlobal _playerPrimaryWeapon;
				_player addWeaponGlobal _playerPrimaryWeapon;
				{
					_item = _x;
					if !(_item isEqualTo "") then
					{
						[_player,_item] remoteExec ["addPrimaryWeaponItem",[0,-2] select isDedicated]; // command doesnt work in dedicated, need remoteExec
					};
				} forEach _playerPrimaryWeaponItems;
			};
			if !(_playerHandgunWeapon isEqualTo "") then
			{
				_player removeWeaponGlobal _playerHandgunWeapon;
				_player addWeaponGlobal _playerHandgunWeapon;
				{
					_item = _x;
					if !(_item isEqualTo "") then
					{
						[_player,_item] remoteExec ["addHandgunItem",[0,-2] select isDedicated]; // command doesnt work in dedicated, need remoteExec
					};
				} forEach _playerHandgunWeaponItems;
			};
			if !(_playerSecondaryWeapon isEqualTo "") then
			{
				_player removeWeaponGlobal _playerSecondaryWeapon;
				_player addWeaponGlobal _playerSecondaryWeapon;
				{
					_item = _x;
					if !(_item isEqualTo "") then
					{
						[_player,_item] remoteExec ["addSecondaryWeaponItem",[0,-2] select isDedicated]; // command doesnt work in dedicated, need remoteExec
					};
				} forEach _playerSecondaryWeaponItems;
			};
		} forEach allPlayers;
		["[DEBRIEFING] all players have been disarmed, please group up, sit down and pay attention to your mission leader."] remoteExec ["systemChat",[0,-2] select isDedicated];
	};
};
