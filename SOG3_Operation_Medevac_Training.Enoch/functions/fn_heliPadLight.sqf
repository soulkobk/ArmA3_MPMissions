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

	Name: fn_helipadLight.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:30 PM 2/01/2020
	Modification Date: 4:30 PM 2/01/2020

	Description: none

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {};

params [["_object",objNull],["_marker",""]];

if (_object isEqualTo objNull) exitWith {};
if (_marker isEqualTo "") exitWith {};

params ["_object"];

_light = "#lightpoint" createVehicle (getPos _object);
_light attachTo [_object, [0, 0, 0]];

// set up lightpoint
[_light,2] remoteExec ["setLightBrightness",[0,-2] select isDedicated,true]; // JIP
[_light,true] remoteExec ["setLightUseFlare",[0,-2] select isDedicated,true]; // JIP
[_light,1] remoteExec ["setLightFlareSize",[0,-2] select isDedicated,true]; // JIP

// green
_color = "green";
[_light,[0.5,1,0]] remoteExec ["setLightColor",[0,-2] select isDedicated,true]; // JIP
[_light,[0.5,1,0]] remoteExec ["setLightAmbient",[0,-2] select isDedicated,true]; // JIP

while {true} do
{
	_heliCount = {alive _x && _x inArea _marker && getPosATL _x select 2 < 50} count (nearestObjects [position _object, ["HELICOPTER"], 100]);
	if (_heliCount > 0) then
	{
		if (_color isEqualTo "green") then
		{
			// orange
			_color = "orange";
			[_light,2] remoteExec ["setLightBrightness",[0,-2] select isDedicated,false];
			[_light,[1,0.1,0]] remoteExec ["setLightColor",[0,-2] select isDedicated,false];
			[_light,[1,0.1,0]] remoteExec ["setLightAmbient",[0,-2] select isDedicated,false];
		};
	}
	else
	{
		if (_color isEqualTo "orange") then
		{
			// green
			_color = "green";
			[_light,2] remoteExec ["setLightBrightness",[0,-2] select isDedicated,false];
			[_light,[0.5,1,0]] remoteExec ["setLightColor",[0,-2] select isDedicated,false];
			[_light,[0.5,1,0]] remoteExec ["setLightAmbient",[0,-2] select isDedicated,false];
		};
	};
	sleep 0.5;
};