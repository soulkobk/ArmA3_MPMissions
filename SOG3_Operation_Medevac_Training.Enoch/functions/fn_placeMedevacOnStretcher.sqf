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

	Name: fn_placeMedevacOnStretcher.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 7:50 PM 6/01/2020
	Modification Date: 7:50 PM 6/01/2020

	Description: for use with ace medical system

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {};

params ["_player","_stretcher"];

[_player,_stretcher] spawn
{
	params ["_player","_stretcher"];
	
	_fnc_logThis = { // for debug purposes
	params ["_logString"];
	// [_logString] remoteExec ["SystemChat",[0,-2] select isDedicated];
	diag_log _logString;
	};
	
	private ["_medevac"];
	
	switch true do
	{
		case (_player getVariable ["ace_captives_isescorting",false] isEqualTo true): {
			_medevac = _player getVariable ["ace_captives_escortedunit",objNull];
			[_player,_medevac,false] remoteExec ["ACE_captives_fnc_doEscortCaptive",0];
		};
		case (_player getVariable ["ace_dragging_iscarrying",false] isEqualTo true): {
			_medevac = _player getVariable ["ace_dragging_carriedobject",objNull];
			[_player,_medevac] remoteExec ["ACE_dragging_fnc_dropObject_carry",0];
		};
		case (_player getVariable ["ace_dragging_isdragging",false] isEqualTo true): {
			_medevac = _player getVariable ["ace_dragging_draggedobject",objNull];
			[_player,_medevac] remoteExec ["ACE_dragging_fnc_dropObject",0];
		};
	};
	
	if !(isNil "_medevac") then
	{
		if !(_medevac isEqualTo objNull) then
		{
			if (isPlayer _medevac) exitWith {}; // exit if _medevac is a player
			
			_stretcher setVariable ["KOBK_var_medevacStretcherIsOccupied",true,true];
			
			_medevac setVariable ["KOBK_var_medevacStable",false,true];
			_medevac setVariable ["KOBK_var_medevacStretcher",_stretcher,true]; // add the stretcher object to the evacuated
			
			_medevac setVariable ["ace_dragging_cancarry",false,true]; // remove carry interaction
			_medevac setVariable ["ace_dragging_candrag",false,true]; // remove drag interaction
			
			_medevacUniform = uniform _medevac;
			
			{
				[_medevac] remoteExec [_x,0]; // to avoid locality issues, remoteExec everywhere.
			} forEach ["removeAllWeapons","removeAllItems","removeAllAssignedItems","removeVest","removeBackpackGlobal","removeHeadgear","removeGoggles","removeUniform"];
			
			// add uniform and goggles
			[_medevac,_medevacUniform] remoteExec ["forceAddUniform",0]; // to avoid locality issues, remoteExec everywhere.
			[_medevac,"G_Respirator_white_F"] remoteExec ["addGoggles",0]; // to avoid locality issues, remoteExec everywhere.
			
			// disableAI
			[_medevac,"ALL"] remoteExec ["disableAI",0]; // to avoid locality issues, remoteExec everywhere.
			
			// stop bleeding
			_medevac setVariable ["ace_medical_woundbleeding",0,true];
			
			// reset unconscious state
			[_medevac,false] call ACE_medical_fnc_setUnconscious;
			[_medevac,true,60,false] call ACE_medical_fnc_setUnconscious;
			
			// place on stretcher
			_stretcherPosition = getPos _stretcher;
			_stretcherDirection = getDir _stretcher;
			_medevac setPos _stretcherPosition;
			_medevac setDir _stretcherDirection;
			
			// force the _medevac to attach to the _stretcher (buggy due to unconscious animation when being dropped)
			_i = 0;
			while {_i < 10 || ((attachedTo _medevac) isEqualTo objNull)} do
			{
				[_medevac,[_stretcher, [0,0,0.2]]] remoteExec ["attachTo",0]; // to avoid locality issues, remoteExec everywhere.
				_i = _i + 1;
				sleep 0.1;
			};
			
			// check if player, if so, release from the stretcher and reset variables for _medevac and _stretcher
			if (isPlayer _medevac) then
			{
				_medevacAttachedTo = attachedTo _medevac;
				if !(isNull _medevacAttachedTo) then
				{
					detach _medevacAttachedTo;
				};
				// enableAI
				[_medevac,"ALL"] remoteExec ["enableAI",0]; // to avoid locality issues, remoteExec everywhere.
				[_medevac] spawn
				{
					params ["_medevac"];
					_stretcher = _medevac getVariable ["KOBK_var_medevacStretcher",objNull];
					if !(isNil "_stretcher") then
					{
						if !(_stretcher isEqualTo objNull) then
						{
							waitUntil {((_medevac distance2d _stretcher) > 3)};
							_stretcher setVariable ["KOBK_var_medevacStretcherIsOccupied",false,true];
							_medevac setVariable ["KOBK_var_medevacStretcher",nil,true];
						};
					};
				};
			}
			else
			{
				// check if not player, then do animation sequence based on unconscious state and pain/stable level
				
				// killed event handler
				_medevac addEventHandler ["KILLED", {
					_medevac = (_this select 0);
					_stretcher = _medevac getVariable ["KOBK_var_medevacStretcher",objNull];
					_stretcher setVariable ["KOBK_var_medevacStretcherIsOccupied",false,true];
				}];
				
				// do initial animation sequence
				_evacuatedAnimation = selectRandom ["Acts_LyingWounded_loop","Acts_LyingWounded_loop1","Acts_LyingWounded_loop2","Acts_LyingWounded_loop3"];
				[_medevac, _evacuatedAnimation, 2] call ace_common_fnc_doAnimation; // 0 = playMove 1 = playMoveNow 2 = switchMove
				
				// spawn + wait for _medevac to become conscious then do pain or no-pain animation sequence
				[_medevac] spawn
				{
					params ["_medevac"];
					waitUntil {((_medevac getVariable ["ace_isunconscious",false]) isEqualTo false) || !(alive _medevac)};
					if (alive _medevac) then
					{
						if (_medevac getVariable ["KOBK_var_medevacStable",false] isEqualTo false) then
						{
							if (((_medevac getVariable ["ace_medical_pain",0]) > 0.15)) then
							{
								_evacuatedAnimation = selectRandom ["Acts_CivilInjuredArms_1","Acts_CivilInjuredChest_1","Acts_CivilInjuredGeneral_1","Acts_CivilInjuredHead_1","Acts_CivilInjuredLegs_1"];
								[_medevac, _evacuatedAnimation, 2] call ace_common_fnc_doAnimation; // 0 = playMove 1 = playMoveNow 2 = switchMove
								waitUntil {((_medevac getVariable ["ace_medical_pain",0]) < 0.15) || !(alive _medevac)};
								if (alive _medevac) then
								{
									if (_medevac getVariable ["KOBK_var_medevacStable",false] isEqualTo false) then
									{
										_evacuatedAnimation = "Acts_SittingWounded_loop";
										[_medevac, _evacuatedAnimation, 2] call ace_common_fnc_doAnimation; // 0 = playMove 1 = playMoveNow 2 = switchMove
									};
								};
							}
							else
							{
								_evacuatedAnimation = "Acts_SittingWounded_loop";
								[_medevac, _evacuatedAnimation, 2] call ace_common_fnc_doAnimation; // 0 = playMove 1 = playMoveNow 2 = switchMove
							};
						};
					};
				};
				
				// spawn + wait for _medevac to become conscious then do stable animation sequence
				[_medevac] spawn
				{
					params ["_medevac"];
					// wait condition
					waitUntil {((_medevac getVariable ["ace_isunconscious",false]) isEqualTo false) && ((_medevac getVariable ["ace_medical_pain",0]) < 0.15) && ((_medevac getVariable ["ace_medical_bloodPressure",[80,120]]) isEqualTo [80,120]) && ((_medevac getVariable ["ace_medical_bloodVolume",6]) isEqualTo 6) || !(alive _medevac)};
					// patient is now conscious and stable (or dead)
					if (alive _medevac) then
					{
						_medevac setVariable ["KOBK_var_medevacStable",true,true];
						_evacuatedAnimation = "AidlPsitMstpSnonWnonDnon_ground00";
						[_medevac, _evacuatedAnimation, 2] call ace_common_fnc_doAnimation; // 0 = playMove 1 = playMoveNow 2 = switchMove
					};
				};
			};
		};
	};
};
