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

	Name: fn_stretcherInteractionInit.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:46 PM 31/12/2019
	Modification Date: 5:46 PM 31/12/2019

	Description: 

	Parameter(s): spawn, not call.

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params ["_stretcher"];

if (isNil "_stretcher") exitWith {};
if (_stretcher isEqualTo objNull) exitWith {};

_stretcherInteraction = [ 
	"KOBK_fnc_placeMedevacOnStretcher", 
	"Place Medevac On Stretcher", 
	"", 
	{
		[_player,_target] remoteExec ["KOBK_fnc_placeMedevacOnStretcher",2];
		[] call ACE_interaction_fnc_hideMouseHint;
	}, 
	{ 
		(_target getVariable ["KOBK_var_medevacStretcherIsOccupied",false] isEqualTo false) && isPlayer _player && ((_player getVariable ["ace_captives_isescorting",false] isEqualTo true) || (_player getVariable ["ace_dragging_isCarrying",false] isEqualTo true) || (_player getVariable ["ace_dragging_isDragging",false] isEqualTo true));
	}, 
	{}, 
	[], 
	[0,0,0], 
	3 
] call ace_interact_menu_fnc_createAction; 
 
[_stretcher,0,["ACE_MainActions"],_stretcherInteraction] call ace_interact_menu_fnc_addActionToObject;
