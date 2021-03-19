/*
	----------------------------------------------------------------------------------------------

	Copyright © 2020 soulkobk (soulkobk.blogspot.com)

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

	Name: fn_prisonerLockUp.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 25/Mar/2020 13:05
	Modification Date: 25/Mar/2020 13:05

	Description: none

	Parameter(s): none

	Example:
	place...
	[] execVM "fn_prisonerLockup.sqf";
	or
	[] call KOBK_fnc_prisonerLockup;

	in...
	initServer.sqf

	brief how-to...
	[1] create an ellipse/rectangle map marker, name it 'prisonerLockUp'.
	[2] edit the configuration below.
	[3] go play, detain an AI object, escort to within the 'prisonerDropOffZone' marker, release AI... repeat.

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

_prisonerArea = "KOBK_mkr_prisonerLockUp"; // name of the map marker (ellipse/rectangle)
_prisonerNumMax = 999999; // the number of objects until overall success of task

/* -----------------------------------------------------------------------------------------------
 DON'T EDIT ANYTHING BELOW HERE!
----------------------------------------------------------------------------------------------- */

if !(isServer) exitWith {};

KOBK_var_prisonerNumber = 0; // global var due to spawning new threads and updating count within them!

_prisonerDropOffLoop = true;
while {_prisonerDropOffLoop isEqualTo true} do
{
	_playersInZone = (nearestObjects [getMarkerPos _prisonerArea,[],100] select {(_x inArea _prisonerArea) && (isPlayer _x) && (_x getVariable ["KOBK_var_prisonerArea",false] isEqualTo false) && (_x getVariable ["ace_captives_isescorting",false] isEqualTo true) || (_x getVariable ["ace_dragging_iscarrying",false] isEqualTo true) || (_x getVariable ["ace_dragging_isdragging",false] isEqualTo true) && !(_x getVariable ["ace_captives_escortedunit",objNull] isEqualTo objNull) || !(_x getVariable ["ace_dragging_carriedobject",objNull] isEqualTo objNull) || !(_x getVariable ["ace_dragging_draggedobject",objNull] isEqualTo objNull)});
	if !(_playersInZone isEqualTo []) then
	{
		{
			[_x,_prisonerArea] spawn
			{
				params ["_escort","_prisonerArea"];
				_escort setVariable ["KOBK_var_prisonerArea",true,true];
				_prisoner = objNull;
				_prisonerCondition = "";
				_isEscorting = _escort getVariable ["ace_captives_isescorting",false];
				if (_isEscorting) then {_prisoner = _escort getVariable ["ace_captives_escortedunit",objNull]; _prisonerCondition = "ace_captives_isescorting";};
				_isCarrying = _escort getVariable ["ace_dragging_iscarrying",false];
				if (_isCarrying) then {_prisoner = _escort getVariable ["ace_dragging_carriedobject",objNull]; _prisonerCondition = "ace_dragging_iscarrying";};
				_isDragging = _escort getVariable ["ace_dragging_isdragging",false];
				if (_isDragging) then {_prisoner = _escort getVariable ["ace_dragging_draggedobject",objNull]; _prisonerCondition = "ace_dragging_isdragging";};
				if (_prisoner isEqualTo objNull) exitWith {};
				if (_prisonerCondition isEqualTo "") exitWith {};
				waitUntil {_escort getVariable [_prisonerCondition,false] isEqualTo false}; 
				if (_prisoner inArea _prisonerArea) then 
				{ 
					_prisoner setUnitLoadout [[],[],[],["U_C_Driver_1_orange",[]],[],[],"","",[],["","","","","",""]];
					[["TaskSucceeded",["","Prisoner Detention Successful"]], BIS_fnc_showNotification] remoteExec ["call"];
					_ambientAnim = selectRandom [
						"STAND_U1",
						"STAND_U2",
						"STAND_U3",
						"KNEEL",
						"BRIEFING",
						"LISTEN_BRIEFING"
					];
					[[_prisoner, _ambientAnim, "NONE"], BIS_fnc_ambientAnim] remoteExec ["call"];
					KOBK_var_prisonerNumber = KOBK_var_prisonerNumber + 1;
				};
				_escort setVariable ["KOBK_var_prisonerArea",false,true];
			};
		} forEach _playersInZone;
	};
	sleep 1;
	if (KOBK_var_prisonerNumber isEqualTo _prisonerNumMax) exitWith
	{
		[["TaskSucceeded",["","All prisoners Dropped Off!"]], BIS_fnc_showNotification] remoteExec ["call"];
		[_prisonerTaskName, "SUCCEEDED", true] call BIS_fnc_taskSetState;
		_prisonerDropOffLoop = false;
	};
};
