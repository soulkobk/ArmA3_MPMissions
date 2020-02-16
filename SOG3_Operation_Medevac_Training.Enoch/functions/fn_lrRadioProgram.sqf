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

	Name: fn_lrRadioProgram.sqf
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

KOBK_arr_lrRadioFrequencies = [
	[1,45.5],
	[2,55.5],
	[3,65.5],
	[4,75.5],
	[5,85.5],
	[6,86.5],
	[7,85.5],
	[8,84.5],
	[9,83.5]
];

if (call TFAR_fnc_haveLRRadio) then
{
	if (_version isEqualTo "QUICK") then
	{
		{
			_radioChannel = _x select 0;
			_radioFrequency = _x select 1;
			[(call TFAR_fnc_activeLRRadio), _radioChannel, str _radioFrequency] call TFAR_fnc_SetChannelFrequency;
		} forEach KOBK_arr_LRRadioFrequencies;
		[(call TFAR_fnc_activeLRRadio),6] call TFAR_fnc_setAdditionalLRChannel;
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
					[(call TFAR_fnc_activeLRRadio), _radioChannel, str _radioFrequency] call TFAR_fnc_SetChannelFrequency;
				} forEach KOBK_arr_LRRadioFrequencies;
				[(call TFAR_fnc_activeLRRadio),6] call TFAR_fnc_setAdditionalLRChannel;
				// systemChat "[LR Radio] Programming Successful.";
			},
			{
				// systemChat "[LR Radio] Programming Interrupted.";
			},
			"Programming LR Radio..."
		] spawn ace_common_fnc_progressBar;
	};
// }
// else
// {
	// systemChat "[LR Radio] Programming Error! No Device Found.";
};
