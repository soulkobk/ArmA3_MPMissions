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
	
	Name: fn_unitEventHandlers.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:

	Parameter(s):
	
	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

{
	_unitObject = _x;
	_unitEventHandlerAlreadySet = _unitObject getVariable ["OWP_var_unitEventHandlers",false];
	if (_unitEventHandlerAlreadySet isEqualTo false) then
	{
		_unitObject setVariable ["OWP_var_unitEventHandlers",true,true]; // so we dont double up on event handlers if already set
		
		// used for ace unconscious
		_unitObject addEventHandler ["Hit", {
			params ["_unit", "_source", "_damage", "_instigator"];
			_unit setVariable ["OWP_var_hit",_instigator,true];
		}];
		
		// used for bis killed
		_unitObject addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			if (isNull _instigator) then {_instigator = UAVControl vehicle _killer select 0}; // UAV/UGV player operated road kill
			if (isNull _instigator) then {_instigator = _unit getVariable ["OWP_var_hit",objNull]};
			if (_instigator isEqualTo objNull) then {_instigator = _killer};
			_side = str (group _unit) splitString " " select 0;
			if (_side isEqualTo "C") then // civilian
			{
				_deathCount = missionNamespace getVariable ["OWP_var_unitsDeadCivilian",0];
				missionNamespace setVariable ["OWP_var_unitsDeadCivilian",(_deathCount + 1),true];
				if (_unit isEqualTo _instigator) then
				{
					_killedText = selectRandom ["was killed","is now dead","no longer has a pulse","had heart failure","dropped dead","expired"];
					[format ["%1 %2",name _unit,_killedText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
				}
				else
				{
					_killedText = selectRandom ["was slaughtered by","was killed by","was murdered by"];
					[format ["%1 %2 %3",name _unit,_killedText,name _instigator]] remoteExec ["SystemChat",[0,-2] select isDedicated];
				};
			};
			if (_side isEqualTo "O") then // opfor
			{
				_deathCount = missionNamespace getVariable ["OWP_var_unitsDeadEnemy",0];
				missionNamespace setVariable ["OWP_var_unitsDeadEnemy",(_deathCount + 1),true];
			};
		}];
	};
} forEach (allUnits - allPlayers);
