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

	Name: fn_initArsenal.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017

	Description:

	Parameter(s):

	Example:

	Change Log:
	1.0 - original base script for object delete.

	----------------------------------------------------------------------------------------------
*/

// if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

params ["_crate"];

waitUntil {!(isNull _crate)};

clearBackpackCargoGlobal _crate; 
clearMagazineCargoGlobal _crate; 
clearWeaponCargoGlobal _crate; 
clearItemCargoGlobal _crate;

["AmmoboxInit",[_crate,true,{(_this distance _target) < 5}]] spawn BIS_fnc_arsenal;

[_crate,true] call ace_arsenal_fnc_initBox;
_crate addAction ["Arsenal (Ace)",{[player,player,true] call ace_arsenal_fnc_openBox},[],9,true,true,"","true",5,false,"",""];
