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
	
	Name: fn_initArsenalRestriction.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 11:55 AM 22/08/2019
	Modification Date: 11:55 AM 22/08/2019
	
	Description: none

	Parameter(s): none

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

OWP_arr_allowedHeadgear =
[
	"UK3CB_BAF_H_Boonie_DDPM_PRR", // Boonie DDPM PRR (Under) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Boonie_DDPM", // Boonie DDPM [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Mk6_DDPM_A", // Helmet Mk6 DDPM (A) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Mk6_DDPM_B", // Helmet Mk6 DDPM (B) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Mk6_DDPM_C", // Helmet Mk6 DDPM Net (A) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Mk6_DDPM_D", // Helmet Mk6 DDPM Net ESS (A) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Mk6_DDPM_E", // Helmet Mk6 DDPM Net ESS (B) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_Mk6_DDPM_F", // Helmet Mk6 DDPM Net ESS (C) [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_CrewHelmet_DDPM_A", // Crew Helmet DDPM [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_H_CrewHelmet_DDPM_ESS_A" // Crew Helmet DDPM ESS [BAF] - HEADGEAR - UK3CB_BAF_EQUIPMENT
];
OWP_arr_allowedUniforms =
[
	"UK3CB_BAF_U_CombatUniform_DDPM", // Combat Uniform DDPM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_U_CombatUniform_DDPM_ShortSleeve", // Combat Uniform DDPM Rolled [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_U_CombatUniform_DDPM_RM", // Combat Uniform DDPM RM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_U_CombatUniform_DDPM_ShortSleeve_RM", // Combat Uniform DDPM Rolled RM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	// "UK3CB_BAF_U_Smock_MTP_DDPM", // Smock MTP / Trousers DDPM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_U_Smock_DDPM", // Smock DDPM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	// "UK3CB_BAF_U_Smock_DPMW_DDPM", // Smock DPM Wdl / Trousers DDPM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_U_CombatUniform_DDPM_Ghillie_RM" // Combat Uniform DDPM Ghillie RM [BAF] - UNIFORM - UK3CB_BAF_EQUIPMENT
];
OWP_arr_allowedVests =
[
	"UK3CB_BAF_V_Osprey_DDPM1", // Osprey Mk2 DDPM (A) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM2", // Osprey Mk2 DDPM (B) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM3", // Osprey Mk2 DDPM (C) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM4", // Osprey Mk2 DDPM (D) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM5", // Osprey Mk2 DDPM (E) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM6", // Osprey Mk2 DDPM (F) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM7", // Osprey Mk2 DDPM (G) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM8", // Osprey Mk2 DDPM (H) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_V_Osprey_DDPM9" // Osprey Mk2 DDPM (I) [BAF] - VEST - UK3CB_BAF_EQUIPMENT
];
OWP_arr_allowedBackpacks =
[
	"UK3CB_BAF_B_Bergen_DDPM_Rifleman_A", // Bergen DDPM Rifleman A [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_B_Bergen_DDPM_Rifleman_B", // Bergen DDPM Rifleman B [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_B_Bergen_DDPM_SL_A", // Bergen DDPM SL [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_B_Bergen_DDPM_JTAC_A", // Bergen DDPM JTAC/FAC [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_B_Bergen_DDPM_JTAC_H_A", // Bergen DDPM JTAC/FAC H [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_B_Kitbag_DDPM", // Kitbag DDPM [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
	"UK3CB_BAF_B_Carryall_DDPM" // Carryall DDPM [BAF] - BACKPACK - UK3CB_BAF_EQUIPMENT
];

///////////////////////////////////////////////////////////////////////////////
// DON'T EDIT BELOW HERE!

//BIS ARSENAL
[missionNamespace, "arsenalClosed", {

	player unlinkItem (hmd player);

	_headgear = headgear player;
	_uniform = uniform player;
	_vest = vest player;
	_backpack = backpack player;
	_outputText = "";
	
	if !(OWP_arr_allowedHeadgear isEqualTo []) then
	{
		if !(_headgear in OWP_arr_allowedHeadgear) then
		{
			removeHeadgear player;
			player addHeadgear selectRandom OWP_arr_allowedHeadgear;
			_outputText = _outputText + "headgear ";
		};
	};
	if !(OWP_arr_allowedUniforms isEqualTo []) then
	{
		if !(_uniform in OWP_arr_allowedUniforms) then
		{
			_uniformItems = uniformItems player;
			removeUniform player;
			player forceAddUniform selectRandom OWP_arr_allowedUniforms;
			{player addItemToUniform _x} forEach _uniformItems;
			_outputText = _outputText + "uniform ";
		};
	};

	if !(OWP_arr_allowedVests isEqualTo []) then
	{
		if !(_vest in OWP_arr_allowedVests) then
		{
			_vestItems = vestItems player;
			removeVest player;
			player addVest selectRandom OWP_arr_allowedVests;
			{player addItemToVest _x} forEach _vestItems;
			_outputText = _outputText + "vest ";
		};
	};

	if !(OWP_arr_allowedBackpacks isEqualTo []) then
	{
		if !(_backpack in OWP_arr_allowedBackpacks) then
		{
			_backpackItems = backpackItems player;
			removeBackpack player;
			player addBackPack selectRandom OWP_arr_allowedBackpacks;
			{player addItemToBackpack _x} forEach _backpackItems;
			_outputText = _outputText + "backpack ";
		};
	};
	
	if !(_outputText isEqualTo "") then
	{
		systemChat format["[RESTRICTED ARSENAL] invalid items were -> %1",_outputText];
	};

}] call BIS_fnc_addScriptedEventHandler;

// ACE ARSENAL
["ace_arsenal_displayClosed", {

	player unlinkItem (hmd player);
	
	_headgear = headgear player;
	_uniform = uniform player;
	_vest = vest player;
	_backpack = backpack player;
	_outputText = "";
	
	if !(OWP_arr_allowedHeadgear isEqualTo []) then
	{
		if !(_headgear in OWP_arr_allowedHeadgear) then
		{
			removeHeadgear player;
			player addHeadgear selectRandom OWP_arr_allowedHeadgear;
			_outputText = _outputText + "headgear ";
		};
	};
	if !(OWP_arr_allowedUniforms isEqualTo []) then
	{
		if !(_uniform in OWP_arr_allowedUniforms) then
		{
			_uniformItems = uniformItems player;
			removeUniform player;
			player forceAddUniform selectRandom OWP_arr_allowedUniforms;
			{player addItemToUniform _x} forEach _uniformItems;
			_outputText = _outputText + "uniform ";
		};
	};

	if !(OWP_arr_allowedVests isEqualTo []) then
	{
		if !(_vest in OWP_arr_allowedVests) then
		{
			_vestItems = vestItems player;
			removeVest player;
			player addVest selectRandom OWP_arr_allowedVests;
			{player addItemToVest _x} forEach _vestItems;
			_outputText = _outputText + "vest ";
		};
	};

	if !(OWP_arr_allowedBackpacks isEqualTo []) then
	{
		if !(_backpack in OWP_arr_allowedBackpacks) then
		{
			_backpackItems = backpackItems player;
			removeBackpack player;
			player addBackPack selectRandom OWP_arr_allowedBackpacks;
			{player addItemToBackpack _x} forEach _backpackItems;
			_outputText = _outputText + "backpack ";
		};
	};

	if !(_outputText isEqualTo "") then
	{
		systemChat format["[RESTRICTED ARSENAL] invalid items were -> %1",_outputText];
	};

}] call CBA_fnc_addEventHandler;

[] spawn
{
	waitUntil {!isNull (findDisplay 46)};
	_arsenalConfirm = ["This mission has RESTRICTIONS on Night/Thermal Vision, Headgear, Uniform, Vest and Backpack, please wear what you spawned in with or the same BAF Desert Camouflage (DDPM) variants via arsenal, otherwise it will be replaced after exiting arsenal!", "ARSENAL RESTRICTIONS", "I ACCEPT", "I DECLINE"] call BIS_fnc_guiMessage;
	if (!_arsenalConfirm) exitWith
	{
		endMission "LOSER";
	};
	systemChat "[ARSENAL] To do a quick loadout... load your favourite arsenal loadout, then exit arsenal, you will then be automatically supplied with the required Headgear, Uniform, Vest, Backback (a random Desert DDPM variant) with the same contents. Want to update/save it? Re-load arsenal and do so.";
};
