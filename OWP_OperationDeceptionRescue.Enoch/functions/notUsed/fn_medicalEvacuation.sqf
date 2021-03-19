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

	Name: fn_medicalEvacuation.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:46 PM 31/12/2019
	Modification Date: 5:46 PM 31/12/2019

	Description: none

	Parameter(s): none

	Example: use a trigger for this script...
	
	condition = this
	on activation = [this,thisTrigger] call KOBK_fnc_medicalEvacuation;
	or
	on activation = [this,thisTrigger] execVM "fn_medicalEvacuation.sqf";
	
	once the player stops escorting/carrying/dragging an ai unit and is within the trigger area, the ai unit will be stripped
	naked and placed on to a stretcher (be sure to have stretchers placed within the trigger area, eg Land_Stretcher_01_F).

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params ["_thisList","_thisTrigger"];

_carrier = _thisList select {(isPlayer _x) && (_x getVariable ["KOBK_var_medicalEvacuation",false] isEqualTo false) && (_x getVariable ["ace_captives_isescorting",false] isEqualTo true) || (_x getVariable ["ace_dragging_iscarrying",false] isEqualTo true) || (_x getVariable ["ace_dragging_isdragging",false] isEqualTo true) && !(_x getVariable ["ace_captives_escortedunit",objNull] isEqualTo objNull) || !(_x getVariable ["ace_dragging_carriedobject",objNull] isEqualTo objNull) || !(_x getVariable ["ace_dragging_draggedobject",objNull] isEqualTo objNull)};
{ 
	[_x,_thisTrigger] spawn 
	{ 
		params ["_carrier","_evacuatedArea"];
		_carrier setVariable ["KOBK_var_medicalEvacuation",true,true];
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
			// ["TaskSucceeded",["","Medical Evacuation Successful"]] call BIS_fnc_showNotification;
			_evacuated setVariable ["KOBK_var_savedLoadout",getUnitLoadout _evacuated];
			_evacuated setUnitLoadout [[],[],[],["",[]],[],[],"","",[],["","","","","",""]];
			_stretcher = selectRandom (nearestObjects [getPos _evacuatedArea, ["Land_Stretcher_01_F"],500] select {_x getVariable ["KOBK_var_stretcherIsOccupied",false] isEqualTo false && _x inArea _evacuatedArea});
			_ambientAnim = selectRandom ["PRONE_INJURED","PRONE_INJURED_U1","PRONE_INJURED_U2"];
			// [objNull,_evacuated] call ACE_medical_fnc_treatmentAdvanced_fullHealLocal;
			// [_evacuated,false] call ACE_medical_fnc_setUnconscious;
			// _evacuated disableAI "ANIM";
			[_evacuated, _ambientAnim, "MEDIUM"] call BIS_fnc_ambientAnim;
			if !(isNil "_stretcher") then
			{
				_evacuated setVariable ["KOBK_var_medicalStretcher",_stretcher,true];
				_stretcher setVariable ["KOBK_var_stretcherIsOccupied",true,true];
				_position = getPos _stretcher;
				_position set [2,0.5];
				_evacuated setPos _position;
				_direction = getDir _stretcher;
				_evacuated setDir _direction;
				[_evacuated] spawn
				{
					params ["_evacuated"];
					// _deathTime = time + (selectRandom [30,60]);
					_deathTime = time + (selectRandom [180,240,300]);
					waitUntil {time >= _deathTime || ((_evacuated getVariable ["ace_medical_pain",1]) isEqualTo 0) && ((_evacuated getVariable ["ace_medical_morphine",0]) isEqualTo 1) && ((_evacuated getVariable ["ace_medical_bloodVolume",20]) isEqualTo 100) && ((_evacuated getVariable ["ace_medical_bodyPartStatus",[1,1,1,1,1,1]]) isEqualTo [0,0,0,0,0,0])};
					_stretcher = _evacuated getVariable ["KOBK_var_medicalStretcher",objNull];
					_stretcher setVariable ["KOBK_var_stretcherIsOccupied",false,true];
					if (time >= _deathTime) then
					{
						// ["TaskFailed",["","Medical Treatment Failed, Unit Is Deceased"]] call BIS_fnc_showNotification;
						_evacuated setDammage 1;
						sleep 60;
						deleteVehicle _evacuated;
					}
					else
					{
						// ["TaskSucceeded",["","Medical Treatment Successful, Unit Is Stable"]] call BIS_fnc_showNotification;
						// [_evacuated,false] call ace_medical_fnc_setUnconscious;
						// _evacuated enableAI "ANIM";
						// _evacuated call BIS_fnc_ambientAnim__terminate;
						_evacuated setUnitLoadout (_evacuated getVariable ["KOBK_var_savedLoadout",[]]);
						// _evacuated moveTo (getMarkerPos "KOBK_mkr_medicalDischarge");
					};
				};
			};
		};
		_carrier setVariable ["KOBK_var_medicalEvacuation",false,true];
	}; 
} forEach _carrier;
