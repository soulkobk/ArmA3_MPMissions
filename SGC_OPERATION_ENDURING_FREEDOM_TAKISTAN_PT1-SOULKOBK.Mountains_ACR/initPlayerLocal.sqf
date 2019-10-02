params ["_newUnit"];
///////////////////////////////////////////////////////////////////////////////
player enableFatigue false;
player enableStamina false;
player setCustomAimCoef 0.1;
///////////////////////////////////////////////////////////////////////////////
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // initializes the player/client side dynamic groups framework
player setUnitTrait ["UAVHacker",true];
player setVariable ["clientOwner",clientOwner,true];
///////////////////////////////////////////////////////////////////////////////
enableRadio false;
enableSentences false;
///////////////////////////////////////////////////////////////////////////////
// for zues
// [] spawn
// {
	// waitUntil {!isNil "SGC_var_whiteListedZeus"}; // server side variable - publicvariable
	// waitUntil {!isNil "SGC_var_zeusInit"}; // server side variable - publicvariable
	// waitUntil {!isNull findDisplay 46}; // wait until in-game display is not null
	// _curatorArr = allCurators select {((_x getVariable ["UID","0"]) isEqualTo (getPlayerUID player))};
	// if !(_curatorArr isEqualTo []) then
	// {
		// _curator = _curatorArr select 0;
		// [_curator] remoteExec ["unassignCurator",[0,-2] select isDedicated];
		// waitUntil {((getAssignedCuratorLogic player) isEqualTo objNull)};
		// _curatorAllocated = false;
		// while {!(_curatorAllocated)} do
		// {
			// [player,_curator] remoteExec ["assignCurator",[0,-2] select isDedicated];
			// _curator setVariable ["name",name player,true];
			// uiSleep 1;
			// if !((getAssignedCuratorLogic player) isEqualTo objNull) then
			// {
				// _curatorAllocated = true;
			// };
		// };
		// player onMapSingleClick "if (_alt) then {vehicle player setPos _pos}"; // for teleport
		// systemChat format ["[MISSION] %1, zeus access granted (%2 keybind)",name player,((actionKeysNames "CuratorInterface") splitString """" select 0)];
	// };
// };

// [player] spawn
// {
	// params [["_player",objNull]];
	// waitUntil {!isNull findDisplay 46};
	// [_player] spawn SGC_fnc_zeusInitPlayer;
// };
// [player] spawn SGC_fnc_zeusInitPlayer;
[player] remoteExec ["SGC_fnc_zeusInitPlayer",[0,-2] select isDedicated];

///////////////////////////////////////////////////////////////////////////////
// for spectator allocation
[] spawn SGC_fnc_initSpectator;
///////////////////////////////////////////////////////////////////////////////
// for dynamic simulation
player triggerDynamicSimulation true;
[] spawn {
	while {true} do
	{
		if (cameraView isEqualTo "GUNNER") then
		{
			"Group" setDynamicSimulationDistance (viewDistance - (viewDistance * fog)); 
			// Scoped
		}
		else
		{
			"Group" setDynamicSimulationDistance ((viewDistance * 0.8) - (viewDistance * fog)); 
			// Not scoped
		};
		uiSleep 0.25; 
	};
};
///////////////////////////////////////////////////////////////////////////////
// for unit markers and entitykilled event handler in order to keep side = WEST
player addRating 99999999999999999999;
///////////////////////////////////////////////////////////////////////////////
["sgc", {[[(_this select 0),player]] remoteExec ["SGC_fnc_chatCommands",[0,-2] select isDedicated]}, "all"] call CBA_fnc_registerChatCommand;
///////////////////////////////////////////////////////////////////////////////
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	if (isNull _instigator) then {_instigator = UAVControl vehicle _killer select 0}; // UAV/UGV player operated road kill
	if (isNull _instigator) then {_instigator = _unit getVariable ["hit",objNull]};
	if (_instigator isEqualTo objNull) then {_instigator = _killer};
	_side = str (group _unit) splitString " " select 0;
	if ((_side isEqualTo "B") && (isPlayer _unit)) then // blufor and is player
	{
		_deathCount = missionNamespace getVariable ["SGC_var_playersDead",0];
		missionNamespace setVariable ["SGC_var_playersDead",(_deathCount + 1),true];
	};
}];
///////////////////////////////////////////////////////////////////////////////
[] spawn SGC_fnc_initArsenalRestriction;
///////////////////////////////////////////////////////////////////////////////
