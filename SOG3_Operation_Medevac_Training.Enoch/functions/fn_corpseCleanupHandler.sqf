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
	
	Name: fn_corpseCleanupHandler.sqf
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

_corpseArea = 5; // 5m around the corpse

_corpseObjectsToDelete =
[
	"groundWeaponHolder",
	"WeaponHolderSimulated"
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

_corpse = param [0, ""];
_corpse setVariable ["corpseCleanup",true,false];
_corpseType = typeOf _corpse;
_corpseInitialWait = getNumber (missionConfigFile >> "corpseRemovalMinTime");
_corpseTimeWait = (_corpseInitialWait / 2);

sleep _corpseInitialWait;

_corpsePosition = getPos _corpse;

_anyPlayersAround = {alive _x && isPlayer _x} count (nearestObjects [_corpsePosition, ["CAMANBASE"], _corpseArea]);
while {sleep 1; (_anyPlayersAround > 0)} do
{
	_anyPlayersAround = {alive _x && isPlayer _x} count (nearestObjects [_corpsePosition, ["CAMANBASE"], _corpseArea]);
	sleep _corpseTimeWait;
};

removeAllActions _corpse;
deleteVehicle objectFromNetId (netID _corpse);

_anyObjectsAround = nearestObjects [_corpsePosition, ["ALL"], _corpseArea];
_anyObjectsAroundCount = (count _anyObjectsAround);
if (_anyObjectsAroundCount > 0) then
{
	_anyObjectsAroundDeleted = 0;
	{
		_object = _x;
		_typeOfObject = typeOf _object;
		if (_typeOfObject in _corpseObjectsToDelete) then
		{
			removeAllActions _object;
			deleteVehicle objectFromNetId (netID _object);
			_anyObjectsAroundDeleted = _anyObjectsAroundDeleted + 1;
		};
	} forEach _anyObjectsAround;
};
