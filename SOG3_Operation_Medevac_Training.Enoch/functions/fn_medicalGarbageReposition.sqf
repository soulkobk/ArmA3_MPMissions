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

	Name: fn_medicalGarbagePosition.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:46 PM 31/12/2019
	Modification Date: 5:46 PM 31/12/2019

	Description: resets all ace medical garbage back to ground level, not left floating in mid air. eh.

	Parameter(s): spawn, not call.

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

// this needs to run globally (every client + server, initPlayerLocal and initServer)

params ["_thisMarker"];

while {true} do
{
	_medicalGarbageArr = (nearestObjects [(getMarkerPos _thisMarker), [], 100]) select {_x inArea _thisMarker && ("medical_treatment" in (getModelInfo _x select 1))};
	if !(isNil "_medicalGarbageArr") then
	{
		if !(_medicalGarbageArr isEqualTo []) then
		{
			{
				_medicalGarbage = _x;
				_medicalGarbagePos = getPosATL _medicalGarbage;
				_medicalGarbagePos set [2,0]; // reset to ground height (not floating).
				_medicalGarbage setPosATL _medicalGarbagePos;
			} forEach _medicalGarbageArr;
			sleep 0.5;
		};
	};
};
