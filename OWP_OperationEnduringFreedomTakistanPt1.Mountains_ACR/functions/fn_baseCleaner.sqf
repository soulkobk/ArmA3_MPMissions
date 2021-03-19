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
	
	Name: fn_baseCleaner.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017
	
	Description: Constantly clean up dropped items within base area.

	Parameter(s): none

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

_cleanUpPos = getMarkerPos "OWP_mkr_friendlyArea";
_cleanUpRadius = selectMax (getMarkerSize "OWP_mkr_friendlyArea"); // maximum radius in meters.
_cleanUpDuration = 120; // maximum duration time in seconds that items are left on the ground for.
_cleanUpSleep = 10; // sleep time in seconds per object loop check.

_cleanUpObjects =
[
	"GroundWeaponHolder", // static weapon holder, all weapons, weapon attachments, magazines, throwables, backpacks, vests, uniforms, helments, etc
	"WeaponHolderSimulated" // simulated weapon holder, all weapons, weapon attachments, magazines, throwables, backpacks, vests, uniforms, helments, etc
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

while {true} do
{
	_nearestObjects = nearestObjects [_cleanUpPos, _cleanUpObjects, _cleanUpRadius];
	if (count _nearestObjects != 0) then
	{
		{
			_cleanUpTime = _x getVariable ["cleanUpTimer", 0];
			if (_cleanUpTime == 0) then
			{
				_x setVariable ["cleanUpTimer", diag_tickTime, false];
			}
			else
			{
				if (diag_tickTime > (_cleanUpTime + _cleanUpDuration)) then
				{
					if (local _x) then
					{
						deleteVehicle _x;
					}
					else
					{
						deleteVehicle objectFromNetId (netID _x);
					};
				};
			};
		} forEach _nearestObjects;
	};
	uiSleep _cleanUpSleep;
};
