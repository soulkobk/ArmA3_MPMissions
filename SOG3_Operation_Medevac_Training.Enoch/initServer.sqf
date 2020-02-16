
// MISSION OWNERS (who can access mission controls)
KOBK_var_missionOwners = [
	"76561198044020915"			// soulkobk
];

// WHO HAS ACCESS TO ZEUS? NEED PLAYER UID
KOBK_var_whiteListedZeus = [
	"76561198031948900",		// grub
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];

// WHO HAS ACCESS TO SPECTATOR? NEED PLAYER UID
KOBK_var_whiteListedSpectate = [
	"76561198031948900",		// grub
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];

KOBK_var_whiteListedChatCommands = [
	"76561198031948900",		// grub
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];

KOBK_var_setDate = [2020,01,01,12,00]; // [year,month,day,hour,minute]

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

// ["KOBK_mkr_natoBaseMedicalTents"] spawn KOBK_fnc_medicalGarbageReposition;
// diag_log "[SERVER] ACE MEDICAL GARBAGE RESET TO GROUND LEVEL INIT";

diag_log "[SERVER] SERVER INIT COMPLETE";
["[SERVER] SERVER INIT COMPLETE."] remoteExec ["BIS_fnc_dynamicText",[0,-2] select isDedicated];
["[SERVER] SERVER INIT COMPLETE."] remoteExec ["SystemChat",[0,-2] select isDedicated];
KOBK_var_serverInit = true;
///////////////////////////////////////////////////////////////////////////////
