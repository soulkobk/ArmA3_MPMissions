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
	
	Name: fn_friendlyAreaPlaySound3D.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/08/2019
	Modification Date: 12:00 PM 01/08/2019
	
	Description:

	Parameter(s): [sound name to play,sound volume,sound distance]
	
	["ordersCall",1,100] spawn SGC_fnc_friendlyAreaPlaySound3D;
	or
	["ordersCall",1,100] remoteExec ["SGC_fnc_friendlyAreaPlaySound3D",2]; // execute on server only, effect global (to all connected clients)

	Example: none
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitWith {};

params [["_sound","none"],["_soundVolume",1],["_soundRange",100]];

_soundToPlay = "";

switch _sound do
{
	case "ordersCall": {_soundToPlay = missionPath + "media\sounds\ordersCall.ogg"};
	case "saluteCall": {_soundToPlay = missionPath + "media\sounds\saluteCall.ogg"};
	case "lastPostCall": {_soundToPlay = missionPath + "media\sounds\lastPostCall.ogg"};
	case "ultimateVictory": {_soundToPlay = missionPath + "media\sounds\ultimateVictory.ogg"};
};

if !(_soundToPlay isEqualTo "") then
{
	{
		_object = _x;
		_position = getPosASL _object;
		_position set [2,((_position select 2) + 7.4)]; // 7.4m above terrain level for actual speakers
		playSound3D [_soundToPlay,_object,false,_position,_soundVolume,1,_soundRange];
	} forEach nearestObjects [getMarkerPos "SGC_mkr_friendlyArea",["Land_Loudspeakers_F"],200];
	diag_log format ["[SERVER] INITIATED SOUND %1 TO BE PLAYED",_sound];
};
