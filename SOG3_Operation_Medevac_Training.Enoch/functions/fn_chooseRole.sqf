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

	Name: fn_chooseRole.sqf
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

params [["_player",objNull],["_role",""]];

if (_player isEqualTo objNull) exitWith {};
if (_role isEqualTo objNull) exitWith {};

switch (_role) do
{
	case "TEAMLEADER": {_player setUnitLoadout [["SMA_M4_GL","sma_gemtech_one_blk","SMA_SFPEQ_M4TOP_BLK","SMA_ELCAN_SPECTER_ARDRDS",["rhs_mag_30Rnd_556x45_Mk262_PMAG",30],["1Rnd_HE_Grenade_shell",1],""],[],[],["U_B_CombatUniform_mcam_wdl_f",[["SmokeShell",6,1]]],["V_PlateCarrier2_wdl",[["ACE_EarPlugs",1],["ACE_EntrenchingTool",1],["ACE_CableTie",4],["ACE_Flashlight_XL50",1],["ACE_MapTools",1],["ACE_epinephrine",6],["ACE_morphine",6],["ACE_personalAidKit",1],["ACE_elasticBandage",12],["ACE_fieldDressing",12],["MiniGrenade",6,1]]],["B_RadioBag_01_wdl_F",[["rhs_mag_30Rnd_556x45_Mk262_PMAG",6,30],["1Rnd_HE_Grenade_shell",4,1]]],"H_HelmetB_light_wdl","VSM_Facemask_OD_Goggles",["Laserdesignator_01_khk_F","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","tf_anprc152_9","ItemCompass","tf_microdagr","NVGogglesB_grn_F"]]};
	case "ROTARYPILOT": {_player setUnitLoadout [["SMA_M4afg_SM","sma_gemtech_one_blk","SMA_SFPEQ_M4TOP_BLK","SMA_ELCAN_SPECTER_ARDRDS",["rhs_mag_30Rnd_556x45_Mk262_PMAG",30],[],""],[],[],["U_B_CombatUniform_mcam_wdl_f",[["SmokeShell",6,1]]],["V_PlateCarrier1_wdl",[["ACE_EarPlugs",1],["ACE_EntrenchingTool",1],["ACE_CableTie",2],["ACE_Flashlight_XL50",1],["ACE_MapTools",1],["MiniGrenade",6,1]]],["B_Carryall_wdl_F",[["ACE_epinephrine",12],["ACE_morphine",12],["ACE_fieldDressing",12],["ACE_elasticBandage",12],["ACE_tourniquet",4],["ACE_splint",4],["ACE_bloodIV_500",2],["ACE_bloodIV_250",2],["ACE_personalAidKit",1],["rhs_mag_30Rnd_556x45_Mk262_PMAG",6,30]]],"H_PilotHelmetFighter_I_E","VSM_Facemask_OD_Goggles",["Laserdesignator_01_khk_F","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","tf_anprc152_8","ItemCompass","tf_microdagr",""]]};
	case "ADVENGINEER": {_player setUnitLoadout [["SMA_M4_GL","sma_gemtech_one_blk","SMA_SFPEQ_M4TOP_BLK","SMA_ELCAN_SPECTER_ARDRDS",["rhs_mag_30Rnd_556x45_Mk262_PMAG",30],["1Rnd_HE_Grenade_shell",1],""],[],[],["U_B_CombatUniform_mcam_wdl_f",[["SmokeShell",6,1]]],["V_PlateCarrier2_wdl",[["ACE_EarPlugs",1],["ACE_EntrenchingTool",1],["ACE_Flashlight_XL50",1],["ACE_MapTools",1],["ACE_epinephrine",6],["ACE_morphine",6],["ACE_personalAidKit",1],["ACE_elasticBandage",12],["ACE_fieldDressing",12],["MineDetector",1],["MiniGrenade",6,1]]],["B_Carryall_wdl_F",[["ToolKit",1],["ACE_wirecutter",1],["ACE_DefusalKit",1],["rhs_mag_30Rnd_556x45_Mk262_PMAG",6,30],["1Rnd_HE_Grenade_shell",4,1],["MiniGrenade",6,1]]],"H_HelmetB_light_wdl","VSM_Facemask_OD_Goggles",["Laserdesignator_01_khk_F","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","tf_anprc152_10","ItemCompass","tf_microdagr","NVGogglesB_grn_F"]]};
	case "COMBATMEDIC": {_player setUnitLoadout [["SMA_M4afg_SM","sma_gemtech_one_blk","SMA_SFPEQ_M4TOP_BLK","SMA_ELCAN_SPECTER_ARDRDS",["rhs_mag_30Rnd_556x45_Mk262_PMAG",30],[],""],[],[],["U_B_CombatUniform_mcam_wdl_f",[["SmokeShell",6,1]]],["V_PlateCarrier2_wdl",[["ACE_EarPlugs",1],["ACE_EntrenchingTool",1],["ACE_CableTie",4],["ACE_bodyBag",2],["ACE_Flashlight_XL50",1],["ACE_MapTools",1],["ACE_epinephrine",12],["ACE_morphine",12],["ACE_splint",12],["MiniGrenade",6,1]]],["B_Carryall_wdl_F",[["ACE_bloodIV_250",6],["ACE_bloodIV_500",6],["ACE_epinephrine",12],["ACE_morphine",12],["ACE_tourniquet",4],["ACE_fieldDressing",24],["ACE_elasticBandage",24],["ACE_packingBandage",12],["ACE_quikclot",12],["ACE_personalAidKit",1],["ACE_bloodIV",6],["rhs_mag_30Rnd_556x45_Mk262_PMAG",6,30]]],"H_HelmetB_light_wdl","VSM_Facemask_OD_Goggles",["Laserdesignator_01_khk_F","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","tf_anprc152_11","ItemCompass","tf_microdagr","NVGogglesB_grn_F"]]};
	case "COMBATDOCTOR": {_player setUnitLoadout [[],[],[],["U_B_CBRN_Suit_01_Wdl_F",[["ACE_EarPlugs",1],["ACE_Flashlight_XL50",1],["SmokeShell",5,1]]],[],["B_Carryall_wdl_F",[["ACE_bloodIV_250",6],["ACE_bloodIV_500",7],["ACE_epinephrine",24],["ACE_morphine",24],["ACE_splint",8],["ACE_tourniquet",4],["ACE_fieldDressing",24],["ACE_elasticBandage",24],["ACE_packingBandage",24],["ACE_quikclot",24],["ACE_personalAidKit",1],["ACE_bloodIV",8],["ACE_surgicalKit",1]]],"H_MilCap_wdl","G_Respirator_yellow_F",["Laserdesignator_01_khk_F","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","tf_anprc152","ItemCompass","tf_microdagr",""]]};
};

// this addAction ["Team Leader Role",{[player,"TEAMLEADER"] call KOBK_fnc_chooseRole},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Rotary Pilot Role",{[player,"ROTARYPILOT"] call KOBK_fnc_chooseRole},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Advanced Engineer Role",{[player,"ADVENGINEER"] call KOBK_fnc_chooseRole},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Combat Medic Role",{[player,"COMBATMEDIC"] call KOBK_fnc_chooseRole},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Combat Doctor Role",{[player,"COMBATDOCTOR"] call KOBK_fnc_chooseRole},[],9,true,true,"","true",5,false,"",""];
