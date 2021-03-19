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
	
	Name: fn_initVehicleTurretAmmo.sqf
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

params ["_markerName"];

_initVehicles = vehicles inAreaArray _markerName;
{
	_vehicle = _x;
	{
		_turret = _x;
		_magazines = _vehicle magazinesTurret _turret;
		{
			_magazine = _x;
			_i = 0;
			while {_i < 10} do
			{
				_vehicle addMagazineTurret [_magazine,_turret];
				_i = _i + 1;
			};
		} forEach _magazines;
	} forEach allTurrets _vehicle;
} forEach _initVehicles;
