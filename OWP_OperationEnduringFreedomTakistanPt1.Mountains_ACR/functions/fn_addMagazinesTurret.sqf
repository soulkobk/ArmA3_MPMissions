/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2017 soulkobk (soulkobk.blogspot.com)

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
	
	Name: fn_addMagazinesTurret.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017
	
	Description:

	Parameter(s): none

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

params [["_object",objNull],["_amount",1]];

// diag_log format ["[TURRET AMMO] _object = %1, _amount = %2",_object,_amount];

waitUntil {!isNil "_object"};
waitUntil {!isNil "BIS_fnc_init"};
waitUntil {time > 1};

// _object = objectFromNetId (netID _object);

{
	_turret = _x;
	_magazines = _object magazinesTurret _turret;
	{
		_magazine = _x;
		_i = 0;
		while {_i < _amount} do
		{
			_object addMagazineTurret [_magazine,_turret];
			_i = _i + 1;
		};
		diag_log format ["[SERVER] turret ammo added %1 magazine %2 to %3",_amount,_magazine,_object];
	} forEach _magazines;
} forEach allTurrets _object;
