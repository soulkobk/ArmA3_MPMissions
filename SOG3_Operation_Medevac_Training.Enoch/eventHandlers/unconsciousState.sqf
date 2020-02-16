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
	
	Name: unconsciousState.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:

	Parameter(s): none
	
	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

["ace_unconscious", {
	params ["_unit","_state"];
	[_unit,_state] spawn // spawn a new thread in order to be able to pause execution (sleep)
	{
		params ["_unit","_state"];
		
		sleep 1; // sleep 1 second in order to filter out lame 'new' ace3 'unconscious -> conscious -> dead' sequence which spams systemChat.
		
		_side = str (group _unit) splitString " " select 0;
		_unconsiousText = selectRandom ["was knocked unconscious"];
		_consciousText = selectRandom ["is alert again","is conscious again","is responsive again"];
		
		// if ((_side isEqualTo "B") && (isPlayer _unit)) then
		if (_side isEqualTo "B") then
		{
			if (alive _unit) then
			{
				if (_state isEqualTo true) then
				{
					[format ["%1 %2",name _unit,_unconsiousText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
				};
				if (_state isEqualTo false) then
				{
					[format ["%1 %2",name _unit,_consciousText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
				};
			};
		};
		if (_side isEqualTo "C") then
		{
			if (alive _unit) then
			{
				_instigator = _unit getVariable ["KOBK_var_hit",objNull];
				if !(_instigator isEqualTo objNull) then
				{
					if (_state isEqualTo true) then
					{
						[format ["%1 %2 by %3",name _unit,_unconsiousText,name _instigator]] remoteExec ["SystemChat",[0,-2] select isDedicated];
					};
					if (_state isEqualTo false) then
					{
						[format ["%1 %2",name _unit,_consciousText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
						_unit setVariable ["KOBK_var_hit",objNull,true];
						_unitSay = selectRandom [true,false];
						if (_unitSay) then
						{
							_speakActionText = selectRandom ["mumbles","yells","speaks","grumbles","says","screams"];
							_speakContextText = selectRandom ["fucking asshole","fuck that hurt","damnit","watch your fire, asshole","medic... I need a medic!","what a cunt","omg, that burned!","I need a gun","someone got a bandaid?"];
							[format ["%1 %2 %3",name _unit,_speakActionText,_speakContextText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
						};
					};
				};
			};
		};
	};
}] call CBA_fnc_addEventHandler;
