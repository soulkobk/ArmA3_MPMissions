///////////////////////////////////////////////////////////////////////////////
// MISSION OWNERS (who can access mission controls)
KOBK_var_missionOwners = [
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
// WHO HAS ACCESS TO ZEUS? NEED PLAYER UID
KOBK_var_whiteListedZeus = [
	"76561198029292841",		// gav
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
// WHO HAS ACCESS TO SPECTATOR? NEED PLAYER UID
KOBK_var_whiteListedSpectate = [
	"76561198029292841",		// gav
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
KOBK_var_whiteListedChatCommands = [
	"76561198029292841",		// gav
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
// SET DATE AND TIME
KOBK_var_setDate = [2001,10,21,07,00]; // [year,month,day,hour,minute]
///////////////////////////////////////////////////////////////////////////////
// CIVILIAN UNITS
_unitsCivilian = [
	"C_Man_1_enoch_F",
	"C_Man_2_enoch_F",
	"C_Man_3_enoch_F",
	"C_Man_4_enoch_F",
	"C_Man_5_enoch_F",
	"C_Farmer_01_enoch_F",
	"C_man_hunter_1_F",
	"C_Man_Fisherman_01_F",
	"C_Man_ConstructionWorker_01_Black_F",
	"C_Man_ConstructionWorker_01_Blue_F",
	"C_Man_ConstructionWorker_01_Red_F",
	"C_Man_UtilityWorker_01_F",
	"C_man_w_worker_F"
];

[
	"civBielawa", // unique label/string to spawned ai
	_unitsCivilian, // array of ai classes
	"CIV", // side of ai units
	"STEALTH", // behaviour of ai units
	"LIMITED", // speed of ai units
	6, // amount of ai units to spawn
	"KOBK_mkr_bielawa", // map marker name to spawn ai units at
	"PATROL", // "PATROL", "SEEK", "STAND" are the current options
	100, // if "PATROL" set as distance, if "SEEK" set as marker name, if "STAND" set as nil
	false, // spawn ai in cover? if true, will spawn ai in/next to a tree or bush
	true, // enable dynamic simulation for ai units?
	false // find a building position to spawn the ai units at instead?
] spawn KOBK_fnc_spawnUnits;

[
	"civFarm",
	_unitsCivilian,
	"CIV",
	"STEALTH",
	"LIMITED",
	6,
	"KOBK_mkr_farm",
	"PATROL",
	100,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

[
	"civToplin",
	_unitsCivilian,
	"CIV",
	"STEALTH",
	"LIMITED",
	12,
	"KOBK_mkr_topolin",
	"PATROL",
	100,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

[
	"civAdamow",
	_unitsCivilian,
	"CIV",
	"STEALTH",
	"LIMITED",
	6,
	"KOBK_mkr_adamow",
	"PATROL",
	100,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

[
	"civRadacz",
	_unitsCivilian,
	"CIV",
	"STEALTH",
	"LIMITED",
	6,
	"KOBK_mkr_radacz",
	"PATROL",
	50,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

[
	"civRadaczNorth",
	_unitsCivilian,
	"CIV",
	"STEALTH",
	"LIMITED",
	6,
	"KOBK_mkr_radaczNorth",
	"PATROL",
	50,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

/////////////////////////////////////////////////////////////////////////
// ENEMY UNITS
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

[
	"enemyTopolin",
	_unitsEnemy,
	"EAST",
	"STEALTH",
	"NORMAL",
	12,
	"KOBK_mkr_topolin",
	"PATROL",
	100,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

[
	"enemyTopolin",
	_unitsEnemy,
	"EAST",
	"STEALTH",
	"NORMAL",
	6,
	"KOBK_mkr_topolin",
	"STAND",
	nil,
	false,
	true,
	true
] spawn KOBK_fnc_spawnUnits;

[
	"enemyAdamow",
	_unitsEnemy,
	"EAST",
	"STEALTH",
	"LIMITED",
	12,
	"KOBK_mkr_adamow",
	"PATROL",
	25,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

[
	"enemyAdamow",
	_unitsEnemy,
	"EAST",
	"STEALTH",
	"LIMITED",
	6,
	"KOBK_mkr_adamow",
	"STAND",
	nil,
	false,
	true,
	true
] spawn KOBK_fnc_spawnUnits;

[
	"enemyRoadBlock",
	_unitsEnemy,
	"EAST",
	"STEALTH",
	"LIMITED",
	12,
	"KOBK_mkr_roadBlock",
	"PATROL",
	25,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

///////////////////////////////////////////////////////////////////////////////
// ANIMALS (DOGS)
	_animalsDoge = [
	"Alsatian_Random_F"
];

[
	"dogsNatoMedicalBase",
	_animalsDoge,
	"CIV",
	"STEALTH",
	"LIMITED",
	3,
	"KOBK_mkr_natoMedicalCampSeek",
	"PATROL",
	25,
	false,
	true,
	false
] spawn KOBK_fnc_spawnAnimals;

_animalsDoge = [
	"Alsatian_Random_F"
];

[
	"dogsAdamow",
	_animalsDoge,
	"CIV",
	"STEALTH",
	"LIMITED",
	3,
	"KOBK_mkr_adamow",
	"PATROL",
	25,
	false,
	true,
	false
] spawn KOBK_fnc_spawnAnimals;

///////////////////////////////////////////////////////////////////////////////
// WORKER UNITS
_unitsWorker = [
	"C_Man_ConstructionWorker_01_Black_F",
	"C_Man_ConstructionWorker_01_Blue_F",
	"C_Man_ConstructionWorker_01_Red_F"
];

[
	"workerQuarry",
	_unitsWorker,
	"CIV",
	"STEALTH",
	"LIMITED",
	3,
	"KOBK_mkr_quarry",
	"PATROL",
	50,
	false,
	true,
	false
] spawn KOBK_fnc_spawnUnits;

///////////////////////////////////////////////////////////////////////////////
// DON'T EDIT ANYTHING BELOW HERE!
///////////////////////////////////////////////////////////////////////////////
KOBK_var_serverInit = false;

missionPath = (str missionConfigFile select [0, count str missionConfigFile - 15]); // mission path
diag_log "[SERVER] MISSION PATH INIT";

publicVariable "KOBK_var_missionOwners";
publicVariable "KOBK_var_whiteListedZeus";
publicVariable "KOBK_var_whiteListedSpectate";
publicVariable "KOBK_var_whiteListedChatCommands";

createCenter WEST;
createCenter EAST;
createCenter CIVILIAN;
createCenter RESISTANCE;

enableSaving [false,false];
enableEnvironment [false,false];

missionNamespace setVariable ["KOBK_var_unitsDeadPlayer",0,true];
missionNamespace setVariable ["KOBK_var_unitsDeadEnemy",0,true];
missionNamespace setVariable ["KOBK_var_unitsDeadCivilian",0,true];
missionNamespace setVariable ["KOBK_var_unitsDeadAnimal",0,true];

["Initialize"] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework
diag_log "[SERVER] DYNAMIC GROUPS INIT";

["KOBK_mkr_natoBase",120,10] spawn KOBK_fnc_baseCleaner; // base cleaner for dropped items
diag_log "[SERVER] BASE CLEANER INIT";

[1000,1000,1000,1000,2,true] call KOBK_fnc_dynamicSimulationInit; // initiates dynamic simulation "GROUP","PROP","VEHICLE","EMPTYVEHICLE","ISMOVING","SKIPAIRVEHICLES"
diag_log "[SERVER] DYNAMIC SIMULATION INIT";

{
	_x triggerDynamicSimulation false;
} forEach (allUnits - allPlayers);
diag_log "[SERVER] DYNAMIC SIMULATION UNITS INIT (MANUALLY PLACED UNITS)";

{
	[_x] call KOBK_fnc_aiSetSkill;
} forEach (allUnits - allPlayers);
diag_log "[SERVER] RANDOM SKILL SET (MANUALLY PLACED UNITS)";

{
	_x addEventHandler ["KILLED", {(_this select 0) spawn KOBK_fnc_corpseCleanupHandler}];
} forEach (allUnits - allPlayers);
diag_log "[SERVER] CORPSE CLEANUP HANDLER (MANUALLY PLACED UNITS)";

[KOBK_var_setDate] remoteExec ["setDate"];
diag_log "[SERVER] SET DATE/TIME INIT";

[] spawn KOBK_fnc_zeusInitServer;
diag_log "[SERVER] ZEUS INIT";

KOBK_var_spectatorInit = true;
publicVariable "KOBK_var_spectatorInit";
diag_log "[SERVER] SPECTATOR INIT";

[] execVM "eventHandlers\unconsciousState.sqf";
diag_log "[SERVER] UNCONSCIOUS STATE EVENT HANDLER INIT";

[] call KOBK_fnc_prisonerLockup;
diag_log "[SERVER] PRISONER LOCK UP ZONE ENABLED";
///////////////////////////////////////////////////////////////////////////////
diag_log "[SERVER] SERVER INIT COMPLETE";
["[SERVER] SERVER INIT COMPLETE."] remoteExec ["BIS_fnc_dynamicText",[0,-2] select isDedicated];
["[SERVER] SERVER INIT COMPLETE."] remoteExec ["SystemChat",[0,-2] select isDedicated];
KOBK_var_serverInit = true;
///////////////////////////////////////////////////////////////////////////////
