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

	Name: fn_swRadioProgram.sqf
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

params [["_version","QUICK"]]; // QUICK or PROGRESS

KOBK_arr_swRadioFrequencies = [
	[1,30.1],
	[2,30.2],
	[3,30.3],
	[4,33.1],
	[5,60.1],
	[6,70.1],
	[7,80.1],
	[8,90.1]
];

if (call TFAR_fnc_haveSWRadio) then
{
	if (_version isEqualTo "QUICK") then
	{
		{
			_radioChannel = _x select 0;
			_radioFrequency = _x select 1;
			[(call TFAR_fnc_activeSwRadio), _radioChannel, str _radioFrequency] call TFAR_fnc_SetChannelFrequency;
		} forEach KOBK_arr_swRadioFrequencies;
		[(call TFAR_fnc_activeSwRadio),6] call TFAR_fnc_setAdditionalSwChannel;
	};
	if (_version isEqualTo "PROGRESS") then
	{
		[
			5,
			[],
			{
				{
					_radioChannel = _x select 0;
					_radioFrequency = _x select 1;
					[(call TFAR_fnc_activeSwRadio), _radioChannel, str _radioFrequency] call TFAR_fnc_SetChannelFrequency;
				} forEach KOBK_arr_swRadioFrequencies;
				[(call TFAR_fnc_activeSwRadio),6] call TFAR_fnc_setAdditionalSwChannel;
				// systemChat "[SW Radio] Programming Successful.";
			},
			{
				// systemChat "[SW Radio] Programming Interrupted.";
			},
			"Programming SW Radio..."
		] spawn ace_common_fnc_progressBar;
	};
// }
// else
// {
	// systemChat "[SW Radio] Programming Error! No Device Found.";
};
