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
	
	Name: fn_taskSeekAndDestroy.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:
	
	[
		<group>,
		<start position>,
		<seek position>
	] call KOBK_fnc_taskSeekAndDestroy;
	
	[
		_group,
		[123,8765,0],
		[9456,1244,0]
	] call KOBK_fnc_taskSeekAndDestroy;

	Parameter(s):
	
	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

params ["_group","_startPos","_seekPos"];

// delete all current waypoints for group
while {(count (waypoints _group)) > 0} do
{
	deleteWaypoint ((waypoints _group) select 0);
};

// measure distance from start to seek position
_seekDistance = _startPos distance2D _seekPos;

// pre set steps to 2 (2 waypoint position)
_seekSteps = 2;
// change number of steps (waypoint positions) depending on distance
switch (true) do
{
	case (_seekDistance > 0 && _seekDistance <= 100) : { _seekSteps = 2 };
	case (_seekDistance > 100 && _seekDistance <= 200) : { _seekSteps = 3 };
	case (_seekDistance > 200 && _seekDistance <= 300) : { _seekSteps = 4 };
	case (_seekDistance > 300 && _seekDistance <= 400) : { _seekSteps = 5 };
	case (_seekDistance > 400 && _seekDistance <= 500) : { _seekSteps = 6 };
	case (_seekDistance > 500 && _seekDistance <= 600) : { _seekSteps = 7 };
	case (_seekDistance > 600 && _seekDistance <= 700) : { _seekSteps = 8 };
	case (_seekDistance > 700 && _seekDistance <= 800) : { _seekSteps = 9 };
	case (_seekDistance > 800 && _seekDistance <= 900) : { _seekSteps = 10 };
	case (_seekDistance > 900 && _seekDistance <= 1000) : { _seekSteps = 11 };
	case (_seekDistance > 1000) : { _seekSteps = 12 };
};

// calculate each step distance
_seekDistanceStep = _seekDistance / _seekSteps;

// add first waypoint where the group is currently positioned
_currentWaypoint = _group addWaypoint [_startPos,0];
_currentWaypoint setWaypointCompletionRadius 5;
_currentWaypoint setWaypointBehaviour "STEALTH";
_currentWaypoint setWaypointCombatMode "RED";
_currentWaypoint setWaypointSpeed "FULL";

// loop to calculate the inbetween steps (waypoint positions)
_j = _seekDistanceStep;
while {_j < _seekDistance} do
{
	_directionStraight = _startPos getDir _seekPos;
	_directionOffset = round(random 90);
	_directionStraight = ((_directionStraight - (90/2)) + _directionOffset);
	_startPos = _startPos getPos [_seekDistanceStep,_directionStraight];
	_currentWaypoint = _group addWaypoint [_startPos,0];
	_currentWaypoint setWaypointCompletionRadius 5;
	_currentWaypoint setWaypointBehaviour "STEALTH";
	_currentWaypoint setWaypointCombatMode "RED";
	_currentWaypoint setWaypointSpeed "FULL";
	_j = _j + _seekDistanceStep;
};

// add last waypoint where the group is to seek and destroy
_currentWaypoint = _group addWaypoint [_seekPos,0];
_currentWaypoint setWaypointCompletionRadius 5;
_currentWaypoint setWaypointBehaviour "STEALTH";
_currentWaypoint setWaypointCombatMode "RED";
_currentWaypoint setWaypointSpeed "FULL";

// once the unit reaches the seek and destroy position, return to a task patrol with radius 50 meters.
_currentWaypoint setWaypointStatements ["true","[group this, getPos this, 50] call CBA_fnc_taskPatrol;"];
