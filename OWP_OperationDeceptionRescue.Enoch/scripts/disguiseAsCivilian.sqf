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
	
	Name: disguiseAsCivilian.sqf
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
	[[],[],[],["U_I_L_Uniform_01_tshirt_skull_F",[]],[],[],"","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]],
	[[],[],[],["U_I_L_Uniform_01_tshirt_black_F",[]],[],[],"","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]],
	[[],[],[],["U_I_L_Uniform_01_tshirt_sport_F",[]],[],[],"","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]],
	[[],[],[],["U_I_L_Uniform_01_tshirt_olive_F",[]],[],[],"","G_Squares",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]],
	[[],[],[],["U_C_Poloshirt_stripped",[]],[],[],"","G_Sport_Greenblack",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]],
	[[],[],[],["U_C_Poloshirt_redwhite",[]],[],[],"","G_Shades_Black",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]],
	[[],[],[],["U_C_Uniform_Farmer_01_F",[]],[],[],"","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]
];

player setUnitLoadout _loadOut;
