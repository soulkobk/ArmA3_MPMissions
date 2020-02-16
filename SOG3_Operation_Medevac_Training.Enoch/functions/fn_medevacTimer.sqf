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

	Name: fn_medevacTimer.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 3:22 PM 21/01/2020
	Modification Date: 3:22 PM 21/01/2020

	Description: none

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if !(hasInterface) exitWith {};

if (missionNamespace getVariable ["KOBK_var_medevacSpawnZone",false] isEqualTo true) then
{
	with uiNamespace do {
		[] spawn
		{
			private ["_ctrlTimerWait"];
			
			waitUntil {!isNull findDisplay 46};
			disableSerialization;
			
			_ctrlWidth = 0.45;
			_ctrlHeight = 0.1;

			_resX = (safeZoneX + (safeZoneWAbs / 2)) - (_ctrlWidth / 2) ;
			// _resY = (safeZoneY + safeZoneH) - _ctrlHeight; // TIMER AT BOTTOM OF SCREEN
			_resY = safeZoneY + (_ctrlHeight * _ctrlHeight); // TIMER AT TOP OF SCREEN

			_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText",-1];
			_ctrl ctrlSetPosition [_resX,_resY,_ctrlWidth,_ctrlHeight];
			_ctrl ctrlCommit 0;
			
			while {(missionNamespace getVariable ["KOBK_var_medevacSpawnZone",true] isEqualTo true) || missionNamespace getVariable ["KOBK_var_medevacSpawnTimer",-1] >= 0} do
			{
				_loopTimerStart = time;
				_ctrlTimer = missionNamespace getVariable ["KOBK_var_medevacSpawnTimer",0];
				_ctrl ctrlSetStructuredText parseText format ["<t color='#fefefe' size='1' align='center'>MEDEVAC TIMER<br/>%1</t>",[((missionNamespace getVariable ["KOBK_var_medevacSpawnTimer",0])/60)+.01,"HH:MM"] call BIS_fnc_timeToString];
				_loopTimerFinish = time;
				if ((_loopTimerFinish - _loopTimerStart) > 0) then // use this to keep accurate track of timing client side.
				{
					_ctrlTimerWait = time + 1 + (_loopTimerFinish - _loopTimerStart);
				}
				else
				{
					_ctrlTimerWait = time + 1;
				};
				waitUntil {time > _ctrlTimerWait};
			};
			ctrlDelete _ctrl;
		};
	};
};