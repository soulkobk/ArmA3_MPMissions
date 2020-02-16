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

	Name: fn_initSpectator.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017

	Description: allows users spectator access (via O key). playerUID must be in array KOBK_var_whiteListedSpectate

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

KOBK_fncl_addLocations = {
	_locationIcon = "\A3\3den\Data\Displays\Display3DEN\PanelLeft\locationList_ca.paa";
	_locationMarkerArray = allMapMarkers select {(["KOBK_mkr_",_x] call BIS_fnc_inString) isEqualTo true};
	{
		_locationMarker = _x;
		_locationMarkerName = _locationMarker splitString "_" select 2;
		_locationMarkerPos = getMarkerPos _locationMarker;
		_locationMarkerPos set [2,20];
		["AddLocation", [_locationMarkerName,_locationMarkerName,"",_locationIcon,[_locationMarkerPos,[0,0,0],[0,0,0]],[0, false]]] call BIS_fnc_EGSpectator;
	} forEach _locationMarkerArray;
};

KOBK_fncl_deleteLocations = {
	_locationList = ["GetLocations"] call BIS_fnc_EGSpectator;
	{
		_location = _x;
		["RemoveLocation", _location] call BIS_fnc_EGSpectator;
	} forEach _locationList;
};

KOBK_fncl_spectate = {
	params ["_isSpectating"];
	if (_isSpectating isEqualTo "true") then
	{
		playerSoundVolume = soundVolume;
		playerCameraView = cameraView;
		0.2 fadeSound 1;
		["Initialize", [player, [], true]] call BIS_fnc_EGSpectator;
		// [] spawn {call KOBK_fncl_addLocations};
		// player hideObjectGlobal true;
		// playerWorldPosition = getPos player;
		// player setPos [0,0,0];
		// [player,true] remoteExec ["hideObjectGlobal",2];
		player allowDamage false;
	};
	if (_isSpectating isEqualTo "false") then
	{
		0.2 fadeSound playerSoundVolume;
		["Terminate"] call BIS_fnc_EGSpectator;
		[] spawn {call KOBK_fncl_deleteLocations};
		// player hideObjectGlobal false;
		// [player,false] remoteExec ["hideObjectGlobal",2];
		player allowDamage true;
		player switchCamera playerCameraView;
		// player setPos playerWorldPosition;
		_isSpectating = nil;
	};
};

waitUntil {!isNil "KOBK_var_whiteListedSpectate"};
waitUntil {!isNil "KOBK_var_spectatorInit"};

_playerUID = getPlayerUID player;
_isWhiteListed = _playerUID in KOBK_var_whiteListedSpectate;
if (_isWhiteListed isEqualTo true) then
{
	// in-game display, wait for in game display to initiate before adding display event handler.
	waitUntil {!isNull findDisplay 46};
	
	systemChat format ["[MISSION] %1, spectator access granted (O keybind)",name player];

	(findDisplay 46) displayAddEventHandler ["KeyDown", {
		_source = _this select 0; _keyCode = _this select 1; _isShift = _this select 2; _isCtrl = _this select 3; _isAlt = _this select 4;
		if (_keyCode isEqualTo 24) then // used O
		{
			"true" call KOBK_fncl_spectate;
		};
	}];

	while {sleep 1; !(isNull findDisplay 46)} do // while in-game
	{
		// spectate display, display gets destroyed after closing spectate therefore the display event handler is also destroyed.
		waitUntil {!isNull findDisplay 60492};
		(findDisplay 60492) displayAddEventHandler ["KeyDown", {
			_source = _this select 0; _keyCode = _this select 1; _isShift = _this select 2; _isCtrl = _this select 3; _isAlt = _this select 4;
			if (_keyCode isEqualTo 24) then // used O
			{
				"false" call KOBK_fncl_spectate;
			};
		}];
	};
};
