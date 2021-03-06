///////////////////////////////////////////////////////////////////////////////
// MISSION OWNERS (who can access mission controls)
OWP_var_missionOwners = [
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
// WHO HAS ACCESS TO ZEUS? NEED PLAYER UID
OWP_var_whiteListedZeus = [
	"76561198029292841",		// gav
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
// WHO HAS ACCESS TO SPECTATOR? NEED PLAYER UID
OWP_var_whiteListedSpectate = [
	"76561198029292841",		// gav
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];
///////////////////////////////////////////////////////////////////////////////
OWP_var_whiteListedChatCommands = [
	"76561198029292841",		// gav
	"76561198089310272",		// Wolvren
	"76561198044020915"			// soulkobk
];

///////////////////////////////////////////////////////////////////////////////
// DON'T EDIT ANYTHING BELOW HERE!
///////////////////////////////////////////////////////////////////////////////
[[2001,10,27,7,30]] remoteExec ["setDate"];

publicVariable "OWP_var_missionOwners";
publicVariable "OWP_var_whiteListedZeus";
publicVariable "OWP_var_whiteListedSpectate";
publicVariable "OWP_var_whiteListedChatCommands";

createCenter WEST;
createCenter EAST;
createCenter CIVILIAN;
createCenter RESISTANCE;

enableSaving [false,false]; // saving off
enableEnvironment [false,false]; // environment off (rabbits, snakes, etc)

OWP_var_serverInit = false;

missionNamespace setVariable ["OWP_var_unitsDeadPlayer",0,true];
missionNamespace setVariable ["OWP_var_unitsDeadEnemy",0,true];
missionNamespace setVariable ["OWP_var_unitsDeadCivilian",0,true];
missionNamespace setVariable ["OWP_var_unitsDeadAnimal",0,true];

OWP_var_missionMines = allmines inAreaArray "OWP_mkr_enemyArea"; // store all mission mines in variable as an array
publicVariable "OWP_var_missionMines";
diag_log "[SERVER] MISSION MINE INIT";

missionPath = (str missionConfigFile select [0, count str missionConfigFile - 15]); // mission path
diag_log "[SERVER] MISSION PATH INIT";

["Initialize"] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework
diag_log "[SERVER] DYNAMIC GROUPS INIT";

[] spawn OWP_fnc_baseCleaner; // base cleaner for dropped items
diag_log "[SERVER] BASE CLEANER INIT";

[] spawn OWP_fnc_restrictToBase;
diag_log "[SERVER] RESTRICT TO BASE AREA INIT";

["OWP_mkr_friendlyArea"] spawn OWP_fnc_initVehicleTurretAmmo; // updates ammo count to 10 reloads on all vehicles/static weapons within marker area
["OWP_mkr_friendlySniperNest"] spawn OWP_fnc_initVehicleTurretAmmo; // updates ammo count to 10 reloads on all vehicles/static weapons within marker area

[2000,2000,2000,2000,2,true] call OWP_fnc_dynamicSimulationInit; // initiates dynamic simulation "GROUP","PROP","VEHICLE","EMPTYVEHICLE","ISMOVING","SKIPAIRVEHICLES"
diag_log "[SERVER] DYNAMIC SIMULATION INIT";
///////////////////////////////////////////////////////////////////////////////
// OWP_obj_insurgencyOfficer (independent)
// set up load-out and look of insurgency officer
removeAllWeapons OWP_obj_insurgencyOfficer;
removeAllItems OWP_obj_insurgencyOfficer; 
removeUniform OWP_obj_insurgencyOfficer; 
removeVest OWP_obj_insurgencyOfficer; 
removeBackpack OWP_obj_insurgencyOfficer; 
removeHeadgear OWP_obj_insurgencyOfficer; 
removeGoggles OWP_obj_insurgencyOfficer;
OWP_obj_insurgencyOfficer forceAddUniform "UK3CB_TKA_B_U_Officer_WDL"; 
OWP_obj_insurgencyOfficer addHeadgear "UK3CB_TKA_B_H_Beret"; 
OWP_obj_insurgencyOfficer addGoggles "G_Bandanna_oli"; 
OWP_obj_insurgencyOfficer linkItem "ItemWatch";
OWP_obj_insurgencyOfficer linkItem "ItemMap";
OWP_obj_insurgencyOfficer linkItem "ItemCompass";
OWP_obj_insurgencyOfficer linkItem "ItemGPS";
[OWP_obj_insurgencyOfficer,"PersianHead_A3_01","male01per"] call BIS_fnc_setIdentity;
// set up insurgency officer global variable
OWP_obj_insurgencyOfficer setVariable ["INSURGENCYOFFICER",true,true];
// find random building position
_buildingPositions = ["OWP_mkr_enemyArea",20] call OWP_fnc_buildingPositions;
_buildingPosition = selectRandom _buildingPositions;
OWP_obj_insurgencyOfficer setPosATL _buildingPosition;
OWP_obj_insurgencyOfficer setDir round(random 360);
// set up dynamic simulation
[group OWP_obj_insurgencyOfficer,true] remoteExec ["enableDynamicSimulation",0];
// set up so body is not deleted if killed
removeFromRemainsCollector [OWP_obj_insurgencyOfficer];
// set up arrest action
_icon = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa";
[OWP_obj_insurgencyOfficer,"<br/>Arrest Insurgency Officer",_icon,_icon,"(OWP_var_insurgencyOfficerCaptured isEqualTo false) && (alive _target) && (_this distance2d _target) < 5", "true",{},{},{OWP_var_insurgencyOfficerCaptured = true; [OWP_obj_insurgencyOfficer,true] call ACE_captives_fnc_setHandcuffed;},{},[],1,nil,true,false] remoteExec ["BIS_fnc_holdActionAdd",0,OWP_obj_insurgencyOfficer];
// trigger to allow the insurgency officer to run off when a blufor a player gets within 10 meters.
_insurgencyOfficerTrigger = createTrigger ["EmptyDetector", getPos OWP_obj_insurgencyOfficer, true];
_insurgencyOfficerTrigger setTriggerArea [10, 10, 0, false, 10];
_insurgencyOfficerTrigger setTriggerActivation ["WEST", "PRESENT", false];
_insurgencyOfficerTrigger setTriggerStatements ["this && OWP_var_serverInit isEqualTo true", "[group OWP_obj_insurgencyOfficer,getPos OWP_obj_insurgencyOfficer,100,10,'MOVE','CARELESS','STEALTH','FULL'] call CBA_fnc_taskPatrol;",""];
diag_log format ["[SERVER] INSURGENCY OFFICER INIT (%1)",_buildingPosition];
///////////////////////////////////////////////////////////////////////////////
diag_log "[SERVER] SPAWN UNITS INIT";
_spawnUnitsInit = [] spawn {
	_unitsCivilian = [
		"UK3CB_TKC_C_CIV",
		"UK3CB_TKC_C_DOC",
		"UK3CB_TKC_C_PILOT",
		"UK3CB_TKC_C_SPOT",
		"UK3CB_TKC_C_WORKER"
		];
	_unitsEnemy = [
		"UK3CB_TKM_O_AT",
		"UK3CB_TKM_O_STATIC_TRI_NSV",
		"UK3CB_TKM_O_AR",
		"UK3CB_TKM_O_DEM",
		"UK3CB_TKM_O_ENG",
		"UK3CB_TKM_O_GL",
		"UK3CB_TKM_O_STATIC_GUN_SPG9",
		"UK3CB_TKM_O_IED",
		"UK3CB_TKM_O_LAT",
		"UK3CB_TKM_O_MG",
		"UK3CB_TKM_O_MD",
		"UK3CB_TKM_O_RIF_2",
		"UK3CB_TKM_O_WAR"
		];
	// compounds
	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_civilianCompound00",[true,25],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN CIVILIAN COMPOUND 00";
	["CIV","STEALTH","NORMAL",2,"OWP_mkr_civilianCompound00",[true,25]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 1 WANDERING DOG SPAWNED WITHIN CIVILIAN COMPOUND 00";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyCompound00",[true,25],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY COMPOUND 00";
	["CIV","STEALTH","NORMAL",2,"OWP_mkr_enemyCompound00",[true,25]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 1 WANDERING DOG SPAWNED WITHIN ENEMY COMPOUND 01";
	
	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyCompound01",[true,25],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY COMPOUND 00";
	["CIV","STEALTH","NORMAL",2,"OWP_mkr_enemyCompound01",[true,25]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 1 WANDERING DOG SPAWNED WITHIN ENEMY COMPOUND 01";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyCompound02",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY COMPOUND 02";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",3,"OWP_mkr_enemyCompound02",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 3 WANDERING ENEMY SPAWNED WITHIN ENEMY COMPOUND 02";
	["CIV","STEALTH","NORMAL",2,"OWP_mkr_enemyCompound02",[true,50]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 2 WANDERING DOGS SPAWNED WITHIN ENEMY COMPOUND 02";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",3,"OWP_mkr_enemyTowVehicles",[true,50],"CBA",false] call OWP_fnc_spawnUnits; diag_log "[SERVER] 3 WANDERING CIVILIANS SPAWNED WITHIN ENEMY COMPOUND 02";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyTowVehicles",[true,50],"CBA",false] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY COMPOUND 02";
	["CIV","STEALTH","NORMAL",1,"OWP_mkr_enemyTowVehicles",[true,50]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 1 WANDERING DOG SPAWNED WITHIN ENEMY COMPOUND 02";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyCompound03",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY COMPOUND 03";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyCompound03",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY COMPOUND 03";
	["CIV","STEALTH","NORMAL",2,"OWP_mkr_enemyCompound03",[true,50]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 2 WANDERING DOGS SPAWNED WITHIN ENEMY COMPOUND 03";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",12,"OWP_mkr_enemyCompound04",[true,100],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 12 WANDERING CIVILIANS SPAWNED WITHIN ENEMY COMPOUND 04";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",18,"OWP_mkr_enemyCompound04",[true,100],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 18 WANDERING ENEMY SPAWNED WITHIN ENEMY COMPOUND 04";
	["CIV","STEALTH","NORMAL",6,"OWP_mkr_enemyCompound04",[true,100]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 6 WANDERING DOGS SPAWNED WITHIN ENEMY COMPOUND 04";

	// main ao
	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointNW",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA NW";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointNW",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA NW";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointNE",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA NE";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointNE",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA NE";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointNEE",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA NEE";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointNEE",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA NEE";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointSE",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA SE";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointSE",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA SE";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointSW",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA SW";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointSW",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA SW";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointSWW",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA SWW";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyAreaSpawnPointSWW",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA SWW";

	[_unitsCivilian,"CIV","STEALTH","LIMITED",6,"OWP_mkr_enemyArea",[true,100],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING CIVILIANS SPAWNED WITHIN ENEMY AREA CENTER";
	[_unitsEnemy,"EAST","STEALTH","LIMITED",12,"OWP_mkr_enemyArea",[true,100],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 12 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA CENTER";
	["CIV","STEALTH","NORMAL",12,"OWP_mkr_enemyArea",[true,100]] call OWP_fnc_spawnDogs; diag_log "[SERVER] 12 WANDERING DOGS SPAWNED WITHIN ENEMY AREA CENTER";
};
waitUntil {scriptDone _spawnUnitsInit};
[] spawn OWP_fnc_unitEventHandlers;
diag_log "[SERVER] UNITS EVENT HANDLERS INIT";
_spawnSecondWaveUnitsInit = [] spawn {
	waitUntil {(OWP_var_serverInit isEqualTo true) && (OWP_var_insurgencyOfficerCaptured isEqualTo true)};
	_spawnSecondWaveUnitsInit = [] spawn {
		_unitsEnemy = [
			"UK3CB_TKM_O_AT",
			"UK3CB_TKM_O_STATIC_TRI_NSV",
			"UK3CB_TKM_O_AR",
			"UK3CB_TKM_O_DEM",
			"UK3CB_TKM_O_ENG",
			"UK3CB_TKM_O_GL",
			"UK3CB_TKM_O_STATIC_GUN_SPG9",
			"UK3CB_TKM_O_IED",
			"UK3CB_TKM_O_LAT",
			"UK3CB_TKM_O_MG",
			"UK3CB_TKM_O_MD",
			"UK3CB_TKM_O_RIF_2",
			"UK3CB_TKM_O_WAR"
			];
		// compounds
		[_unitsEnemy,"EAST","STEALTH","LIMITED",3,"OWP_mkr_enemyCompound02",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 3 WANDERING ENEMY SPAWNED WITHIN COMPOUND 02 (SECOND WAVE)";
		[_unitsEnemy,"EAST","STEALTH","LIMITED",6,"OWP_mkr_enemyCompound03",[true,50],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 6 WANDERING ENEMY SPAWNED WITHIN COMPOUND 03 (SECOND WAVE)";
		[_unitsEnemy,"EAST","STEALTH","LIMITED",12,"OWP_mkr_enemyCompound04",[true,100],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 12 WANDERING ENEMY SPAWNED WITHIN COMPOUND 04 (SECOND WAVE)";
		[_unitsEnemy,"EAST","STEALTH","LIMITED",12,"OWP_mkr_enemyArea",[true,200],"CBA",true] call OWP_fnc_spawnUnits; diag_log "[SERVER] 12 WANDERING ENEMY SPAWNED WITHIN ENEMY AREA CENTER (SECOND WAVE)";
		diag_log "[SERVER] SPAWN UNITS SECOND WAVE INIT";
	};
	waitUntil {scriptDone _spawnSecondWaveUnitsInit};
	[] spawn OWP_fnc_unitEventHandlers;
};
///////////////////////////////////////////////////////////////////////////////
// bodybag event handler
["ace_placedInBodyBag", {(_this select 1) setVariable ["INSURGENCYOFFICER",(_this select 0) getVariable ["INSURGENCYOFFICER",false],true]}] call CBA_fnc_addEventHandler; // for insurgency officer dead/alive triggers
diag_log "[SERVER] BODY BAG EVENT HANDLER INIT";
// unconscious state event handler
["ace_unconscious", {
	params ["_unit","_state"];
	_side = str (group _unit) splitString " " select 0;
	_unconsiousText = selectRandom ["was knocked unconscious"];
	_consciousText = selectRandom ["is alert again","is conscious again","is responsive again"];
	if ((_side isEqualTo "B") && (isPlayer _unit)) then
	{
		if (alive _unit) then
		{
			if (_state isEqualTo true) then
			{
				[format ["%1 %2",name _unit,_unconsiousText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
			};
			if (_state isEqualTo false) then
			{
				[format ["%1 %2",name _unit,_consciousText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
			};
		};
	};
	if (_side isEqualTo "C") then
	{
		if (alive _unit) then
		{
			_instigator = _unit getVariable ["OWP_var_hit",objNull];
			if !(_instigator isEqualTo objNull) then
			{
				if (_state isEqualTo true) then
				{
					[format ["%1 %2 by %3",name _unit,_unconsiousText,name _instigator]] remoteExec ["SystemChat",[0,-2] select isDedicated];
				};
				if (_state isEqualTo false) then
				{
					[format ["%1 %2",name _unit,_consciousText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
					_unit setVariable ["OWP_var_hit",objNull,true];
					_unitSay = selectRandom [true,false];
					if (_unitSay) then
					{
						_speakActionText = selectRandom ["mumbles","yells","speaks","grumbles","says","screams"];
						_speakContextText = selectRandom ["fucking asshole","fuck that hurt","damnit","watch your fire, asshole","medic... I need a medic!","what a cunt","omg, that burned!","I need a gun","someone got a bandaid?"];
						[format ["%1 %2 in a foreign accent, %3",name _unit,_speakActionText,_speakContextText]] remoteExec ["SystemChat",[0,-2] select isDedicated];
					};
				};
			};
		};
	};
}] call CBA_fnc_addEventHandler;
diag_log "[SERVER] UNCONSCIOUS STATE EVENT HANDLER INIT";
///////////////////////////////////////////////////////////////////////////////
// plays radio music at base over loudspeakers
[] spawn {
	diag_log "[SERVER] BASE RADIO INIT";
	OWP_var_playRadioMusic = true;
	publicVariable "OWP_var_playRadioMusic";
	while {OWP_var_playRadioMusic isEqualTo true} do
	{
		_sound = missionPath + "media\sounds\proudToServe.ogg"; // 134 seconds

		_soundThread = [_sound] spawn
		{
			params ["_sound"];
			{
				_object = _x;
				_position = getPosASL _object;
				_position set [2,((_position select 2) + 7.4)]; // 7.4m above terrain level for actual speakers
				playSound3D [_sound,_object,false,_position,1,1,100];
			} forEach nearestObjects [getMarkerPos "OWP_mkr_friendlyArea",["Land_Loudspeakers_F"],200];
		};
		_timer = 0;
		while {_timer < 134} do // length of radio track
		{
			if (OWP_var_playRadioMusic isEqualTo false) exitWith
			{
				terminate _soundThread;
				false
			};
			_timer = _timer + 1;
			sleep 1;
		};
	};
	diag_log "[SERVER] BASE RADIO EXIT";
};
///////////////////////////////////////////////////////////////////////////////
[[2001,10,27,7,30]] remoteExec ["setDate"];
diag_log "[SERVER] SET DATE/TIME TO OCTOBER 27TH 2001 / 0730 HOURS - OPERATION ENDURING FREEDOM TAKISTAN PT1 (BY SOULKOBK)";
///////////////////////////////////////////////////////////////////////////////
[] spawn OWP_fnc_zeusInitServer; // zeus init
diag_log "[SERVER] ZEUS INIT";
OWP_var_spectatorInit = true;
publicVariable "OWP_var_spectatorInit";
diag_log "[SERVER] SPECTATOR INIT";

diag_log "[SERVER] SERVER INIT COMPLETE";
["[SERVER] SERVER INIT COMPLETE."] remoteExec ["BIS_fnc_dynamicText",[0,-2] select isDedicated];
["[SERVER] SERVER INIT COMPLETE."] remoteExec ["SystemChat",[0,-2] select isDedicated];
OWP_var_serverInit = true;
///////////////////////////////////////////////////////////////////////////////
