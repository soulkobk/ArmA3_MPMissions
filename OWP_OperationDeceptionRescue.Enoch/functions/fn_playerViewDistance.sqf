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

	Name: fn_playerViewDistance.sqf.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 25/Mar/2020 13:05
	Modification Date: 25/Mar/2020 13:05

	Description: none

	Parameter(s): none

	Example:
	place...
	[] execVM "fn_playerViewDistance.sqf.sqf";

	in...
	initPlayerLocal.sqf

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

_onFoot = 1800; // view distance whilst on-foot
_inVehicle = 2200; // view distance whilst 
_inAir = 3400; // view distance whilst in air vehicle
_inUAV = 3400; // view distance whilst in uav drive/gunner position.
_shadow = 50; // shadow distance

/* -----------------------------------------------------------------------------------------------
 DON'T EDIT ANYTHING BELOW HERE!
----------------------------------------------------------------------------------------------- */

if !(hasInterface) exitWith {};

[_onFoot,_inVehicle,_inAir,_inUAV,_shadow] spawn
{
	params ["_onFoot","_inVehicle","_inAir","_inUAV","_shadow"];
	while {true} do
	{
		_connectedUAVControl = ((uavControl (getConnectedUAV player)) select ((uavControl (getConnectedUAV player)) find player) + 1);
		if !(_connectedUAVControl isEqualTo objNull) then
		{
			if !(_connectedUAVControl isEqualTo "") then
			{
				setViewDistance _inUAV;
				setObjectViewDistance [_inUAV,_shadow];
			}
			else
			{
				_vehiclePlayer = vehicle player;
				if (_vehiclePlayer isKindOf "CAManBase") then
				{
					setViewDistance _onFoot;
					setObjectViewDistance [_onFoot,_shadow];
				};
				if (_vehiclePlayer isKindOf "Air") then
				{
					setViewDistance _inAir;
					setObjectViewDistance [_inAir,_shadow];
				};
				if (_vehiclePlayer isKindOf "LandVehicle") then
				{
					setViewDistance _inVehicle;
					setObjectViewDistance [_inVehicle,_shadow];
				};
			};
		}
		else
		{
				_vehiclePlayer = vehicle player;
				if (_vehiclePlayer isKindOf "CAManBase") then
				{
					setViewDistance _onFoot;
					setObjectViewDistance [_onFoot,_shadow];
				};
				if (_vehiclePlayer isKindOf "Air") then
				{
					setViewDistance _inAir;
					setObjectViewDistance [_inAir,_shadow];
				};
				if (_vehiclePlayer isKindOf "LandVehicle") then
				{
					setViewDistance _inVehicle;
					setObjectViewDistance [_inVehicle,_shadow];
				};
		};
		uiSleep 0.1;
	};
};