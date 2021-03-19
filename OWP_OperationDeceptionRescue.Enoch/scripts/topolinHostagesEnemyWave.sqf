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
	"KOBK_mkr_toplinHostagesSpawn_0",
	"KOBK_mkr_toplinHostagesSpawn_1",
	"KOBK_mkr_toplinHostagesSpawn_2",
	"KOBK_mkr_toplinHostagesSpawn_3",
	"KOBK_mkr_toplinHostagesSpawn_4"
];
 
_numberOfWaves = 3; // number of waves to spawn enemy

_unitsMarkerSeekName = "KOBK_mkr_toplinHostagesSeek"; // marker name of where enemy to seek to

_unitsMarkerDeployNum = 3; // amount of enemy spawned at each location.

/////////////////////////////////////////////////////////////////////////////////////////
// DON'T EDIT BELOW HERE! - soulkobk
/////////////////////////////////////////////////////////////////////////////////////////

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
