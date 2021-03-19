params ["_newUnit"];
///////////////////////////////////////////////////////////////////////////////
player enableFatigue false;
player enableStamina false;
player setCustomAimCoef 0.1;
player setUnitTrait ["loadCoef",9999];
player setUnitTrait ["UAVHacker",true];
enableRadio false;
enableSentences false;
player setVariable ["clientOwner",clientOwner,true];
///////////////////////////////////////////////////////////////////////////////
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // initializes the player/client side dynamic groups framework
///////////////////////////////////////////////////////////////////////////////
// for zues
[player] remoteExec ["OWP_fnc_zeusInitPlayer",[0,-2] select isDedicated];
///////////////////////////////////////////////////////////////////////////////
// for spectator allocation
[] spawn OWP_fnc_initSpectator;
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
["owp", {[[(_this select 0),player]] remoteExec ["OWP_fnc_chatCommands",[0,-2] select isDedicated]}, "all"] call CBA_fnc_registerChatCommand;
///////////////////////////////////////////////////////////////////////////////
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	if (isNull _instigator) then {_instigator = UAVControl vehicle _killer select 0}; // UAV/UGV player operated road kill
	if (isNull _instigator) then {_instigator = _unit getVariable ["hit",objNull]};
	if (_instigator isEqualTo objNull) then {_instigator = _killer};
	_side = str (group _unit) splitString " " select 0;
	if ((_side isEqualTo "B") && (isPlayer _unit)) then // blufor and is player
	{
		_deathCount = missionNamespace getVariable ["OWP_var_playersDead",0];
		missionNamespace setVariable ["OWP_var_playersDead",(_deathCount + 1),true];
	};
}];
///////////////////////////////////////////////////////////////////////////////
[] spawn OWP_fnc_initArsenalRestriction;
///////////////////////////////////////////////////////////////////////////////
