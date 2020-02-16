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

	Name: fn_natoBaseDefend.sqf
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

_unitsEnemy = [ 
	"O_R_Soldier_AR_F",
	"O_R_medic_F",
	"O_R_soldier_exp_F",
	"O_R_Soldier_GL_F",
	"O_R_JTAC_F",
	"O_R_soldier_M_F",
	"O_R_Soldier_LAT_F",
	"O_R_Soldier_TL_F",
	"O_R_Patrol_Soldier_AR2_F",
	"O_R_Patrol_Soldier_AR_F",
	"O_R_Patrol_Soldier_Engineer_F",
	"O_R_Patrol_Soldier_GL_F",
	"O_R_Patrol_Soldier_M2_F",
	"O_R_Patrol_Soldier_LAT_F",
	"O_R_Patrol_Soldier_M_F",
	"O_R_Patrol_Soldier_TL_F",
	"O_R_recon_AR_F",
	"O_R_recon_exp_F",
	"O_R_recon_GL_F",
	"O_R_recon_M_F",
	"O_R_recon_medic_F",
	"O_R_recon_LAT_F",
	"O_R_Patrol_Soldier_A_F",
	"O_R_Patrol_Soldier_Medic",
	"O_R_recon_JTAC_F",
	"O_R_recon_TL_F"
];
											
_spawnLocations = [
	"KOBK_mkr_natoBaseEnemySpawn_0",
	"KOBK_mkr_natoBaseEnemySpawn_1",
	"KOBK_mkr_natoBaseEnemySpawn_2",
	"KOBK_mkr_natoBaseEnemySpawn_3",
	"KOBK_mkr_natoBaseEnemySpawn_4",
	"KOBK_mkr_natoBaseEnemySpawn_5"
];
 
_unitsMarkerSeekName = "KOBK_mkr_natoBase"; // marker name of where enemy to seek to

_unitsMarkerDeployNum = 3; // amount of enemy spawned at each location.

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

if !(isServer) exitWith {};

params [["_numberOfWaves",1]];

if !(typeName _numberOfWaves isEqualTo "SCALAR") exitWith {};

if ((missionNamespace getVariable ["KOBK_var_NATObaseEnemyWave",false]) isEqualTo true) exitWith
{
	_medivacString = "[MEDEVAC] MEDEVAC BASE ALREADY UNDER ATTACK, EXITING.";
	diag_log _medivacString;
	[_medivacString] remoteExec ["SystemChat",[0,-2] select isDedicated];
};

missionNamespace setVariable ["KOBK_var_NATObaseEnemyWave",true,true];
_medivacString = "[MEDEVAC] MEDEVAC BASE DEFEND, HERE COME THE ENEMY... DEFEND THE NATO BASE SOLDIERS!";
diag_log _medivacString;
[_medivacString] remoteExec ["SystemChat",[0,-2] select isDedicated];

private ["_waveCountString"];

{
	_unitsMarkerSpawnName = _x;
	[_unitsEnemy,_numberOfWaves,_unitsMarkerSeekName,_unitsMarkerDeployNum,_unitsMarkerSpawnName] spawn
	{
		params ["_unitsEnemy","_numberOfWaves","_unitsMarkerSeekName","_unitsMarkerDeployNum","_unitsMarkerSpawnName"];
		_i = 0;
		while {_i < _numberOfWaves} do
		{
			_waveCountString = str _unitsMarkerSpawnName + str _i;
			[
				_waveCountString,
				_unitsEnemy,
				"EAST",
				"STEALTH",
				"FULL",
				_unitsMarkerDeployNum,
				_unitsMarkerSpawnName,
				"SEEK",
				_unitsMarkerSeekName,
				true,
				true,
				false
			] spawn KOBK_fnc_spawnUnits;
			if (_numberOfWaves > 1) then
			{
				waitUntil
				{
					sleep 1;
					(count (allUnits select {_x getVariable ["spawnIdentifier",""] isEqualTo _waveCountString})) <= floor(_unitsMarkerDeployNum / 2);
				};
			};
			_i = _i + 1;
			sleep 0.5;
		};
	};
	sleep 0.5;
} forEach _spawnLocations;

// create red flashing light
{
	_object = _x;
	_ambient = [1,0.05,0]; // RED
	_light = "#lightpoint" createVehicle (getPos _object);
	_light attachTo [_object, [0, 0, 0]];
	_object setVariable ["KOBK_var_warningLight",_light,true];
	[_light,_ambient] remoteExec ["KOBK_fnc_ambientLightSourceFlash",[0,-2] select isDedicated,true]; // JIP, control flash client side
} forEach [KOBK_obj_warningLight_0];

waitUntil
{
	sleep 1;
	(count (allUnits select {(_x inArea "KOBK_mkr_natoBaseDefend") && ((side _x) isEqualTo EAST)}) isEqualTo 0);
};

if (missionNamespace getVariable ["KOBK_var_natoBaseEnemyWave",true] isEqualTo true) then
{
	_medivacString = "[MEDEVAC] MEDEVAC BASE DEFEND COMPLETE, WELL DONE SOLDIERS!";
	diag_log _medivacString;
	[_medivacString] remoteExec ["SystemChat",[0,-2] select isDedicated];
	missionNamespace setVariable ["KOBK_var_natoBaseEnemyWave",false,true];
	
	// delete red flashing light
	{
		_object = _x;
		_light = _object getVariable ["KOBK_var_warningLight",objNull];
		detach _light;
		deleteVehicle _light;
	} forEach [KOBK_obj_warningLight_0];
};

// this addAction ["Medevac NATO Base Defend (1 Wave)",{[1] remoteExec ["KOBK_fnc_natoBaseDefend",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Medevac NATO Base Defend (2 Waves)",{[2] remoteExec ["KOBK_fnc_natoBaseDefend",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];
// this addAction ["Medevac NATO Base Defend (3 Waves)",{[3] remoteExec ["KOBK_fnc_natoBaseDefend",[0,-2] select isDedicated]},[],9,true,true,"","true",5,false,"",""];
