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

	Name: fn_ambientLightSource.sqf
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

params [["_object",objNull],["_color","COOLWHITE"],["_flash",false]];

if (_object isEqualTo objNull) exitWith {};

_ambient = "COOLWHITE";
switch (_color) do
{
	case "COOLWHITE": {_ambient = [0.2,0.3,0.7]};
	case "WARMWHITE": {_ambient = [1,0.3,0]};
	case "RED": {_ambient = [1,0.05,0]};
	case "ORANGE": {_ambient = [1,0.1,0]};
	case "PINK": {_ambient = [0.5,0.1,1]};
	case "GREEN": {_ambient = [0.5,1,0]};
	case "BLUE": {_ambient = [0.1,0.1,1]};

};

params ["_object"];

_light = "#lightpoint" createVehicle (getPos _object);
_light attachTo [_object, [0, 0, 0]];

if (_flash isEqualTo true) then
{
	[_light,_ambient] remoteExec ["KOBK_fnc_ambientLightSourceFlash",[0,-2] select isDedicated,true]; // JIP, control flash client side
}
else
{
	[_light,2] remoteExec ["setLightBrightness",[0,-2] select isDedicated,true]; // JIP
	[_light,_ambient] remoteExec ["setLightColor",[0,-2] select isDedicated,true]; // JIP
	[_light,_ambient] remoteExec ["setLightAmbient",[0,-2] select isDedicated,true]; // JIP
	[_light,true] remoteExec ["setLightUseFlare",[0,-2] select isDedicated,true]; // JIP
	[_light,2] remoteExec ["setLightFlareSize",[0,-2] select isDedicated,true]; // JIP
};

_light
