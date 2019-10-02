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
	
	Name: fn_dynamicSimulationInit.sqf
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

if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

params [["_groupDistance",2000],["_propDistance",2000],["_vehicleDistance",2000],["_emptyVehicleDistance",2000],["_isMovingDistanceCoef",2],["_disableAirVehicles",true]];

enableDynamicSimulationSystem true;

"GROUP" setDynamicSimulationDistance _groupDistance;
"PROP" setDynamicSimulationDistance _propDistance;
"VEHICLE" setDynamicSimulationDistance _vehicleDistance;
"EMPTYVEHICLE" setDynamicSimulationDistance _emptyVehicleDistance;
"ISMOVING" setDynamicSimulationDistanceCoef _isMovingDistanceCoef;

{
	_unitGroup = _x;
	// enable dynamic simulation
	[_unitGroup,true] remoteExec ["enableDynamicSimulation",0];
	// disable dynamic simulation if skip group
	_skipGroup = ((_unitGroup getVariable ["SKIPDYNAMICSIMULATION",false]) isEqualTo true);
	if (_skipGroup isEqualTo true) then
	{
		[_unitGroup,false] remoteExec ["enableDynamicSimulation",0];
	};
	// disable dynamic simulation if disable air vehicles is true and it kind of air vehicle
	if (_disableAirVehicles isEqualTo true) then
	{
		_unitsAir = !(units _unitGroup select {(vehicle _x isKindOf "AIR")} isEqualTo []);
		if (_unitsAir isEqualTo true) then
		{
			[_unitGroup,false] remoteExec ["enableDynamicSimulation",0];
		};
	};
} forEach allGroups;
