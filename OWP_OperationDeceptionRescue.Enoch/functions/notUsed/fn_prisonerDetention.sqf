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

	Name: fn_prisonerDetention.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:46 PM 31/12/2019
	Modification Date: 5:46 PM 31/12/2019

	Description: none

	Parameter(s): none

	Example: use a trigger for this script...
	
	condition = this
	on activation = [this,thisTrigger] call KOBK_fnc_prisonerDetention;
	or
	on activation = [this,thisTrigger] execVM "fn_prisonerDetention.sqf";
	
	once the player stops escorting/carrying/dragging an ai unit and is within the trigger area,
	the ai unit will be placed into an orange uniform  with blindfold.

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params ["_thisList","_thisTrigger"];

_carrier = _thisList select {(isPlayer _x) && (_x getVariable ["prisonerDetention",false] isEqualTo false) && (_x getVariable ["ace_captives_isescorting",false] isEqualTo true) || (_x getVariable ["ace_dragging_iscarrying",false] isEqualTo true) || (_x getVariable ["ace_dragging_isdragging",false] isEqualTo true) && !(_x getVariable ["ace_captives_escortedunit",objNull] isEqualTo objNull) || !(_x getVariable ["ace_dragging_carriedobject",objNull] isEqualTo objNull) || !(_x getVariable ["ace_dragging_draggedobject",objNull] isEqualTo objNull)};
{
	[_x,_thisTrigger] spawn 
	{
		params ["_carrier","_evacuatedArea"];
		_carrier setVariable ["prisonerDetention",true,true];
		_evacuated = objNull;
		_evacuatedCondition = "";
		_isEscorting = _carrier getVariable ["ace_captives_isescorting",false];
		if (_isEscorting) then {_evacuated = _carrier getVariable ["ace_captives_escortedunit",objNull]; _evacuatedCondition = "ace_captives_isescorting";};
		_isCarrying = _carrier getVariable ["ace_dragging_iscarrying",false];
		if (_isCarrying) then {_evacuated = _carrier getVariable ["ace_dragging_carriedobject",objNull]; _evacuatedCondition = "ace_dragging_iscarrying";};
		_isDragging = _carrier getVariable ["ace_dragging_isdragging",false];
		if (_isDragging) then {_evacuated = _carrier getVariable ["ace_dragging_draggedobject",objNull]; _evacuatedCondition = "ace_dragging_isdragging";};
		if (_evacuated isEqualTo objNull) exitWith {};
		if (_evacuatedCondition isEqualTo "") exitWith {};
		waitUntil {_carrier getVariable [_evacuatedCondition,false] isEqualTo false}; 
		if (_evacuated inArea _evacuatedArea) then 
		{ 
			["TaskSucceeded",["","Prisoner Detention Successful"]] call BIS_fnc_showNotification;
			_evacuated setUnitLoadout [[],[],[],["U_C_Driver_1_orange",[]],[],[],"","G_Blindfold_01_white_F",[],["","","","","",""]];
			_randomStretcher = selectRandom (nearestObjects [getPos _evacuatedArea, ["Land_Stretcher_01_F"],100] select {_x getVariable ["isOccupied",false] isEqualTo false && _x inArea _evacuatedArea});
			_ambientAnim = selectRandom ["STAND1","STAND2","STAND_U1","STAND_U2","STAND_U3","WATCH","WATCH2"];
			[_evacuated, _ambientAnim, "MEDIUM"] call BIS_fnc_ambientAnim;
		};
		_carrier setVariable ["prisonerDetention",false,true];
	}; 
} forEach _carrier;
