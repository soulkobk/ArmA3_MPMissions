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

	Name: KOBK_fnc_zeusInitPlayer.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 1/09/2019
	Modification Date: 12:00 PM 1/09/2019

	Description:

	Parameter(s):
			
	Example:

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params [["_player",objNull]];

if (_player isEqualTo objNull) exitWith {};

waitUntil {!isNil "KOBK_var_whiteListedZeus" && !isNil "KOBK_var_zeusInit"};

_playerUID = getPlayerUID _player;

if (_playerUID in KOBK_var_whiteListedZeus) then
{
	_curatorArr = allCurators select {((_x getVariable ["UID","0"]) isEqualTo (getPlayerUID _player))};
	if !(_curatorArr isEqualTo []) then
	{
		_curator = _curatorArr select 0;
		_curatorUnassigned = false;
		while {!(_curatorUnassigned)} do
		{
			[_curator] remoteExec ["unassignCurator",[0,-2] select isDedicated];
			uiSleep 1;
			if ((getAssignedCuratorLogic _player) isEqualTo objNull) then
			{
				_curatorUnassigned = true;
			};
		};
		_curatorAllocated = false;
		while {!(_curatorAllocated)} do
		{
			[_player,_curator] remoteExec ["assignCurator",[0,-2] select isDedicated];
			_curator setVariable ["name",name _player,true];
			uiSleep 1;
			if !((getAssignedCuratorLogic _player) isEqualTo objNull) then
			{
				_curatorAllocated = true;
			};
		};
		diag_log format ["[SERVER] ASSIGNED ZUES %1 TO %2",_curator,name _player];
	};
};
