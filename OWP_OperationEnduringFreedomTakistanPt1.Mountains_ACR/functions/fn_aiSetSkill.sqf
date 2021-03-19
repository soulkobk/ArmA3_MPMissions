/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2017 soulkobk (soulkobk.blogspot.com)

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
	
	Name: fn_aiSetSkill.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017
	
	Description:

	Parameter(s): none

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

_unit = param [0, objNull];
_skillSetForced = param [1, ""];
_skillSet = "";

if (isNull _unit) exitWith
{
	_skillSet = "ERROR";
	_skillSet
};

switch (_skillSetForced) do
{
	case "VERY LOW": {_skillSet = "VERY LOW";};
	case "LOW": {_skillSet = "LOW";};
	case "REGULAR": {_skillSet = "REGULAR";};
	case "MEDIUM": {_skillSet = "MEDIUM";};
	case "HIGH": {_skillSet = "HIGH";};
	case "ELITE": {_skillSet = "ELITE";};
	case "VIPER": {_skillSet = "VIPER";};
	default {_skillSet = selectRandom ["VERY LOW","LOW","REGULAR","MEDIUM","HIGH","ELITE","VIPER"];};
};

_unit setVariable ["aiSetSkill",_skillSet,true];

// general
    // Raw "Skill", value is distributed to sub-skills unless defined otherwise. Affects the AI's decision making.

// aimingAccuracy

    // Affects how well the AI can lead a target
    // Affects how accurately the AI estimate range and calculates bullet drop
    // Affects how well the AI compensates for weapon dispersion
    // Affects how much the AI will know to compensate for recoil (Higher value = more controlled fire)
    // Affects how certain the AI must be about its aim on target before opening fire

// aimingShake
    // Affects how steadily the AI can hold a weapon (Higher value = less weapon sway)

// aimingSpeed
    // Affects how quickly the AI can rotate and stabilize its aim (Higher value = faster, less error)

// commanding
    // Affects how quickly recognized targets are shared with the group (Higher value = faster reporting)

// courage
    // Affects unit's subordinates' morale (Higher value = more courage)

// endurance
// Disabled in Arma3

// reloadSpeed
    // Affects the delay between switching or reloading a weapon (Higher value = less delay)

// spotDistance
    // Affects the AI ability to spot targets within it's visual or audible range (Higher value = more likely to spot)
    // Affects the accuracy of the information (Higher value = more accurate information)

// spotTime
    // Affects how quick the AI react to death, damage or observing an enemy (Higher value = quicker reaction)

switch (_skillSet) do
{
	case "VERY LOW":
	{
		_unitBase = 20; // 20% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; //  20%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 20%
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 20% (80% SWAY)
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 16%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 20%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 20%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)]; // 14%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 8%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 18%
	};
	case "LOW":
	{
		_unitBase = 30; // 30% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; // 30%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 30%
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 30% (70% SWAY)
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 24%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 30%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 30%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)]; // 21%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 12%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 27%
	};
	case "REGULAR":
	{
		_unitBase = 40; // 40% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; // 40%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 40%
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 40% (60% SWAY)
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 32%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 40%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 40%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)]; // 28%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 16%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 36%
	};
	case "MEDIUM":
	{
		_unitBase = 50; // 50% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; // 50%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 50%
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 50% (50% SWAY)
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 40%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 50%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 50%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)]; // 35%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 20%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 45%
	};
	case "HIGH":
	{
		_unitBase = 60; // 60% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; // 60%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 60%
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 60% (40% SWAY)
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 48%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 60%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 60%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)];  // 42%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 24%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 54%
	};
	case "ELITE":
	{
		_unitBase = 70; // 70% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; // 70%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 70% (30% SWAY)
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 70%
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 56%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 70%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 70%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)]; // 49%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 28%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 63%
	};
	case "VIPER":
	{
		_unitBase = 80; // 80% skill level
		_unit setSkill ["general", (_unitBase * 0.01)]; // 80%
		_unit setSkill ["aimingAccuracy", (_unitBase * 0.01)]; // 80% (20% SWAY)
		_unit setSkill ["aimingShake", (_unitBase * 0.01)]; // 80%
		_unit setSkill ["aimingSpeed", (_unitBase * 0.008)]; // 64%
		_unit setSkill ["commanding", (_unitBase * 0.01)]; // 80%
		_unit setSkill ["courage", (_unitBase * 0.01)]; // 80%
		_unit setSkill ["reloadSpeed", (_unitBase * 0.007)]; // 56%
		_unit setSkill ["spotDistance", (_unitBase * 0.004)]; // 32%
		_unit setSkill ["spotTime", (_unitBase * 0.009)]; // 72%
	};
};

_skillSet
