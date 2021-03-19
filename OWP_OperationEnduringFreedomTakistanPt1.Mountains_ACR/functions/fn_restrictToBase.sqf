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
	
	Name: fn_restrictToBase.sqf
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

_restrictedMarkerName = "OWP_mkr_restrictedArea";
_restrictedRespawnName = "British Armed Forces FOB";

// DONT EDIT BELOW HERE!

_restrictedRespawnPosition = getMarkerPos _restrictedMarkerName;
_restrictedVehicles = (entities [["ALLVEHICLES"], [], true, true]) select {_x inArea _restrictedMarkerName};

// lock all vehicles, disable damage
{
	_vehicle = _x;
	_vehicle setVehicleLock "LOCKED";
	_vehicle allowDamage false;
} forEach _restrictedVehicles;

// restrict players to the base area
OWP_var_restrictToBase = true;
while {OWP_var_restrictToBase isEqualTo true} do
{
	_playersOutsideArea = (allPlayers select {!(_x inArea _restrictedMarkerName) && (alive _x)});
	if !(_playersOutsideArea isEqualTo []) then
	{
		{
			_player = _x;
			_player setPos _restrictedRespawnPosition;
			_playerClientOwner = _player getVariable ["clientOwner",""];
			if !(_playerClientOwner isEqualTo "") then
			{
				format ["[RESTRICTED AREA] %1, please stay within the area of '%2' until mission start!",name _player,_restrictedRespawnName] remoteExec ["systemChat",_playerClientOwner];
			};
		} forEach _playersOutsideArea;
	};
	sleep ((count _playersOutsideArea) + 1);
};

// unlock all vehicles, enable damage
{
	_vehicle = _x;
	_vehicle setVehicleLock "UNLOCKED";
	_vehicle allowDamage true;
} forEach _restrictedVehicles;
