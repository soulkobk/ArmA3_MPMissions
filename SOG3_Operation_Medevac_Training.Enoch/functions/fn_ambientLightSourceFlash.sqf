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

	Name: fn_ambientLightSourceFlash.sqf
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

if !(hasInterface) exitWith {};

params ["_light","_ambient"];

[_light,_ambient] spawn
{
	params ["_light","_ambient"];
	while {!(_light isEqualTo objNull)} do
	{
		_light setLightBrightness 0;
		_light setLightColor _ambient;
		_light setLightAmbient _ambient;
		_light setLightUseFlare true;
		_light setLightFlareSize 1;
		uiSleep 0.1;
		_light setLightBrightness 2;
		uiSleep 0.1;
		_light setLightBrightness 0;
		uiSleep 0.1;
		_light setLightBrightness 2;
		uiSleep 0.1;
		_light setLightBrightness 0;
		uiSleep 2;
	};
};
