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
	
	Name: fn_zeusAddObject.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017
	
	Description:
	
	Parameter(s): 

	Example: 
	
	Change Log:
	1.0 - original base script for object delete.
	
	----------------------------------------------------------------------------------------------
*/

// if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

params ["_curator","_placed"];

_nameOfCurator = _curator getVariable ["name","UNKNOWN"];

{
	diag_log format ["[ZEUS DEBUG] %1 placed object %2",_nameOfCurator,_placed];
	_x addCuratorEditableObjects [[_placed],true];
	_placed setVariable ["zeusSpawnedBy",_nameOfCurator,true];
	if (_placed isKindOf "CAMANBASE") then
	{
		[_placed] call SGC_fnc_aiSetSkill;
	};
	if ((_placed isKindOf "CAR") || (_placed isKindOf "HELICOPTER") || (_placed isKindOf "PLANE") || (_placed isKindOf "TANK")) then
	{
		_placedCrew = crew _placed;
		if !(_placedCrew isEqualTo []) then
		{
			{
				[_placed] call SGC_fnc_aiSetSkill;
			} forEach _placedCrew;
		};
	};
} forEach (allCurators - [_curator]);
