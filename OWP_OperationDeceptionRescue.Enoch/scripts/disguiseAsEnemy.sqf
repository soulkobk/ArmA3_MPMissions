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
	
	Name: disguiseAsEnemy.sqf
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

params [["_unitObject",objNull]];

_savedLoadout = _unitObject getVariable ["currentLoadout",[]];
if (_savedLoadout isEqualTo []) then
{
	_unitObject setVariable ["currentLoadout",getUnitLoadout _unitObject];
};

_unitObject setCaptive true;

removeAllWeapons _unitObject;
removeAllItems _unitObject;
removeAllAssignedItems _unitObject;
removeUniform _unitObject;
removeVest _unitObject;
removeBackpack _unitObject;
removeHeadgear _unitObject;
removeGoggles _unitObject;

_loadOut = selectRandom
[
	[["arifle_AK12U_lush_holo_pointer_F","","acc_pointer_IR","optic_Holosight_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_fieldDressing",14],["ACE_morphine",6],["30rnd_762x39_AK12_Lush_Mag_F",2,30]]],["V_SmershVest_01_F",[["ACE_morphine",5],["ACE_fieldDressing",8],["30rnd_762x39_AK12_Lush_Mag_F",3,30],["16Rnd_9x21_Mag",2,17],["SmokeShell",1,1],["SmokeShellRed",1,1],["SmokeShellOrange",1,1],["SmokeShellYellow",1,1],["Chemlight_red",2,1]]],["B_FieldPack_taiga_Medic_F",[["ACE_epinephrine",4],["ACE_bloodIV",2],["SmokeShellRed",1,1],["SmokeShellBlue",1,1],["SmokeShellOrange",1,1]]],"H_HelmetAggressor_cover_taiga_F","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12U_lush_holo_pointer_F","","acc_pointer_IR","optic_Holosight_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_fieldDressing",2],["ACE_morphine",1],["30rnd_762x39_AK12_Lush_Mag_F",2,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",3,30],["16Rnd_9x21_Mag",2,17],["APERSMine_Range_Mag",3,1],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],["B_Carryall_taiga_Exp_F",[["ToolKit",1],["MineDetector",1],["APERSBoundingMine_Range_Mag",3,1],["ClaymoreDirectionalMine_Remote_Mag",2,1],["SLAMDirectionalMine_Wire_Mag",2,1],["DemoCharge_Remote_Mag",1,1]]],"H_HelmetAggressor_cover_taiga_F","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_GL_lush_arco_pointer_F","","acc_pointer_IR","optic_Arco_AK_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_fieldDressing",2],["ACE_morphine",1],["30rnd_762x39_AK12_Lush_Mag_F",2,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",3,30],["16Rnd_9x21_Mag",2,17],["HandGrenade",2,1],["MiniGrenade",2,1],["1Rnd_HE_Grenade_shell",5,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["Chemlight_red",2,1],["1Rnd_Smoke_Grenade_shell",2,1],["1Rnd_SmokeRed_Grenade_shell",1,1],["1Rnd_SmokeOrange_Grenade_shell",1,1],["1Rnd_SmokeYellow_Grenade_shell",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","G_Balaclava_blk",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_lush_arco_pointer_F","","acc_pointer_IR","optic_Arco_AK_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_fieldDressing",2],["ACE_morphine",1],["16Rnd_9x21_Mag",2,17],["MiniGrenade",1,1],["Chemlight_red",1,1]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",5,30],["MiniGrenade",1,1],["O_R_IR_Grenade",2,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["Chemlight_red",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava1_olive",["Laserdesignator_02","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_RPK12_lush_arco_pointer_F","","acc_pointer_IR","optic_Arco_AK_lush_F",["75rnd_762x39_AK12_Lush_Mag_F",75],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_EarPlugs",1],["ACE_fieldDressing",2],["ACE_morphine",1],["SmokeShell",1,1]]],["V_SmershVest_01_F",[["75rnd_762x39_AK12_Lush_Mag_F",5,75],["16Rnd_9x21_Mag",2,17],["HandGrenade",1,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],[],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava1_olive",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["srifle_DMR_04_DMS_weathered_Kir_F_F","","acc_pointer_IR","optic_DMS_weathered_Kir_F",["10Rnd_127x54_Mag",10],[],"bipod_02_F_blk"],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_fieldDressing",2],["ACE_morphine",1],["10Rnd_127x54_Mag",2,10]]],["V_SmershVest_01_F",[["10Rnd_127x54_Mag",7,10],["16Rnd_9x21_Mag",2,17],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],[],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava1_olive",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12U_lush_holo_pointer_F","","acc_pointer_IR","optic_Holosight_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],["launch_RPG32_green_F","","","",["RPG32_F",1],[],""],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_EarPlugs",1],["ACE_fieldDressing",2],["ACE_morphine",1],["30rnd_762x39_AK12_Lush_Mag_F",2,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",3,30],["16Rnd_9x21_Mag",2,17],["SmokeShell",1,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],["B_FieldPack_taiga_RPG_AT_F",[["RPG32_F",2,1],["RPG32_HE_F",2,1]]],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava1_olive",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_GL_lush_arco_pointer_F","","acc_pointer_IR","optic_Arco_AK_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["ACE_fieldDressing",2],["ACE_morphine",1],["30rnd_762x39_AK12_Lush_Mag_F",2,30]]],["V_SmershVest_01_radio_F",[["30rnd_762x39_AK12_Lush_Mag_F",1,30],["30rnd_762x39_AK12_Lush_Mag_Tracer_F",2,30],["16Rnd_9x21_Mag",2,17],["MiniGrenade",2,1],["1Rnd_HE_Grenade_shell",5,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["SmokeShellOrange",1,1],["SmokeShellYellow",1,1],["Chemlight_red",2,1],["1Rnd_Smoke_Grenade_shell",2,1],["1Rnd_SmokeRed_Grenade_shell",1,1],["1Rnd_SmokeOrange_Grenade_shell",1,1],["1Rnd_SmokeYellow_Grenade_shell",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12U_lush_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["30rnd_762x39_AK12_Lush_Mag_F",1,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",4,30],["HandGrenade",2,1],["SmokeShell",1,1]]],["B_Patrol_Carryall_green_Ammo_F",[["30rnd_762x39_AK12_Lush_Mag_F",8,30],["75rnd_762x39_AK12_Lush_Mag_F",3,75],["RPG32_F",1,1],["RPG32_HE_F",1,1],["1Rnd_HE_Grenade_shell",3,1]]],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_RPK12_lush_holo_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","optic_Holosight_lush_F",["75rnd_762x39_AK12_Lush_Mag_F",75],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["HandGrenade",2,1]]],["V_SmershVest_01_F",[["75rnd_762x39_AK12_Lush_Mag_F",3,75],["SmokeShell",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_RPK12_lush_arco_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","optic_Arco_AK_lush_F",["75rnd_762x39_AK12_Lush_Mag_F",75],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["HandGrenade",2,1]]],["V_SmershVest_01_F",[["75rnd_762x39_AK12_Lush_Mag_F",3,75],["SmokeShell",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_lush_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["30rnd_762x39_AK12_Lush_Mag_F",1,30]]],["V_SmershVest_01_radio_F",[["30rnd_762x39_AK12_Lush_Mag_F",4,30],["HandGrenade",2,1],["SmokeShell",1,1]]],["B_Patrol_Carryall_taiga_medic_F",[["Medikit",1]]],"H_HelmetAggressor_cover_F","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12U_lush_holo_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","optic_Holosight_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["30rnd_762x39_AK12_Lush_Mag_F",1,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",4,30],["HandGrenade",2,1],["SmokeShell",1,1]]],["B_Patrol_FieldPack_green_eng_F",[["ToolKit",1],["MineDetector",1],["APERSBoundingMine_Range_Mag",3,1],["ClaymoreDirectionalMine_Remote_Mag",2,1]]],"H_HelmetAggressor_F","",["Laserdesignator_01_khk_F","","","",["Laserbatteries",1],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_GL_lush_holo_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","optic_Holosight_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["1Rnd_HE_Grenade_shell",4,1]]],["V_SmershVest_01_F",[["1Rnd_HE_Grenade_shell",3,1],["1Rnd_SmokePurple_Grenade_shell",1,1],["30rnd_762x39_AK12_Lush_Mag_F",5,30],["HandGrenade",2,1],["SmokeShell",1,1],["UGL_FlareGreen_F",1,1],["UGL_FlareRed_F",1,1]]],["B_FieldPack_taiga_F",[]],"H_HelmetAggressor_cover_taiga_F","rhs_balaclava1_olive",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["srifle_DMR_04_DMS_weathered_Kir_F_F","","acc_pointer_IR","optic_DMS_weathered_Kir_F",["10Rnd_127x54_Mag",10],[],"bipod_02_F_blk"],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["FirstAidKit",2],["10Rnd_127x54_Mag",1,10]]],["V_SmershVest_01_F",[["10Rnd_127x54_Mag",5,10],["16Rnd_9x21_Mag",1,17],["HandGrenade",2,1],["SmokeShell",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","G_Balaclava_blk",["Rangefinder","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_lush_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","",["30rnd_762x39_AK12_Lush_Mag_F",30],[],""],["launch_RPG32_green_F","","","",["RPG32_F",1],[],""],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["30rnd_762x39_AK12_Lush_Mag_F",1,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",4,30],["HandGrenade",2,1],["SmokeShell",1,1]]],["B_FieldPack_taiga_RPG_AT_F",[["RPG32_F",2,1],["RPG32_HE_F",2,1]]],"H_HelmetAggressor_cover_taiga_F","",["Rangefinder","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_lush_arco_snds_pointer_bipod_F","muzzle_snds_B_lush_F","acc_pointer_IR","optic_Arco_AK_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],[],"bipod_02_F_lush"],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_camo_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["30rnd_762x39_AK12_Lush_Mag_F",1,30]]],["V_SmershVest_01_F",[["30rnd_762x39_AK12_Lush_Mag_F",4,30],["HandGrenade",2,1],["SmokeShell",1,1]]],[],"H_HelmetAggressor_cover_taiga_F","G_Balaclava_blk",["Rangefinder","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]],
	[["arifle_AK12_GL_lush_holo_snds_pointer_F","muzzle_snds_B_lush_F","acc_pointer_IR","optic_Holosight_lush_F",["30rnd_762x39_AK12_Lush_Mag_F",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["U_O_R_Gorka_01_F",[["FirstAidKit",2],["16Rnd_9x21_Mag",1,17],["30rnd_762x39_AK12_Lush_Mag_F",1,30]]],["V_SmershVest_01_radio_F",[["30rnd_762x39_AK12_Lush_Mag_F",4,30],["1Rnd_HE_Grenade_shell",8,1],["HandGrenade",2,1],["SmokeShell",1,1]]],["B_FieldPack_taiga_F",[]],"H_HelmetAggressor_F","G_Balaclava_blk",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_grn_F"]]
];

player setUnitLoadout _loadOut;
