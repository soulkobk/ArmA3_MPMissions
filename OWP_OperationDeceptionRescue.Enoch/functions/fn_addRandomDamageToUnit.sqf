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

	Name: fn_addRandomDamageToUnit.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:46 PM 31/12/2019
	Modification Date: 5:46 PM 31/12/2019

	Description: none

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params [["_unit",objNull]];

if (_unit isEqualTo objNull) exitWith {};

_bodyParts = ["head", "body", "hand_l", "hand_r", "leg_l", "leg_r"];
_amountBodyParts = (count _bodyParts - ceil (random (count _bodyParts)));

_damageTypes = ["backblast", "bite", "bullet", "explosive", "falling", "grenade", "punch", "ropeburn", "shell", "stab", "unknown", "vehiclecrash"];

[_unit,true,350,false] call ace_medical_fnc_setUnconscious;

[_unit, selectRandom [-0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]] call ace_medical_fnc_adjustPainLevel;

for [{_i = 0},{_amountBodyParts >= _i},{_i = _i + 1}] do
{
	_bodyPart = selectRandom _bodyParts;
	_bodyParts = _bodyParts - [_bodyPart]; // so we don't select it twice.
	[_unit, selectRandom [0.2,0.3,0.4,0.5,0.6,0.7,0.8], _bodyPart, selectRandom _damageTypes] call ace_medical_fnc_addDamageToUnit;
};

[_unit] spawn // spawn this so whether the original function is via call or spawn (or execVM), it will work correctly.
{
	params ["_unit"];
	sleep selectRandom [60,120,180];
	_unit setVariable ["ace_medical_woundbleeding",0]; // stop bleeding after duration.
};
