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
	
	Name: fn_autoChute.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:58 PM 9/09/2019
	Modification Date: 4:58 PM 9/09/2019
	
	Description:

	Parameter(s):
	
	place this in the init of the players/units you want to have auto chute...
	[this] execVM "fn_autoChute.sqf";
	
	or place this in your initPlayerLocal.sqf to enable all players auto chute...
	[player] execVM "fn_autoChute.sqf";

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

params [["_unit",objNull]];

if (_unit isEqualTo objNull) exitWith {};

[_unit] spawn
{
	params ["_unit"];
	while {true} do
	{
		waitUntil {
			uiSleep 0.5;
			((position _unit select 2) >= 100) && (vehicle _unit isEqualto _unit) && (alive _unit);
		};
		_deployChute = false;
		while {_deployChute isEqualto false} do
		{
			uiSleep 0.5;
			if !(vehicle _unit isEqualto _unit) exitWith {_deployChute = false};
			if !(alive _unit) exitWith {_deployChute = false};
			if ((position _unit select 2) <= 100) then {_deployChute = true};
		};
		if (_deployChute isEqualto true) then
		{
			addCamShake [8, 2, 20];
			_chute = createVehicle ["Steerable_Parachute_F", position _unit, [], 0, "FLY"];
			_chute setPos (position _unit);
			_unit moveIndriver _chute;
			_chute allowDamage false;
		};
	};
};
