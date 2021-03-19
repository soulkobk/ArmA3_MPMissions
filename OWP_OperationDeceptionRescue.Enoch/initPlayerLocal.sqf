params [
	"_player",
	"_didJIP"
];

player enableFatigue false;
player enableStamina false;

player setCustomAimCoef 0.1;

["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // initializes the player/client side dynamic groups framework

player setUnitTrait ["loadCoef",9999];

player setUnitTrait ["UAVHacker",true];
player setVariable ["clientOwner",clientOwner,true];

enableRadio false;
enableSentences false;

player addRating 99999999999999999999;

player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	if (isNull _instigator) then {_instigator = UAVControl vehicle _killer select 0}; // UAV/UGV player operated road kill
	if (isNull _instigator) then {_instigator = _unit getVariable ["hit",objNull]};
	if (_instigator isEqualTo objNull) then {_instigator = _killer};
	_side = str (group _unit) splitString " " select 0;
	if ((_side isEqualTo "B") && (isPlayer _unit)) then // blufor and is player
	{
		_deathCount = missionNamespace getVariable ["KOBK_var_playersDead",0];
		missionNamespace setVariable ["KOBK_var_playersDead",(_deathCount + 1),true];
	};
}];

player addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	if (captive _unit) then
	{
		_unit setCaptive false;
	};
}];

player addEventHandler ["KILLED", {(_this select 0) spawn KOBK_fnc_corpseCleanupHandler}]; // custom function

[player] call KOBK_fnc_autoChute;
[] call KOBK_fnc_playerViewDistance;

player triggerDynamicSimulation true;
player setCaptive false;

player setVariable ["savedLoadout",getUnitLoadout player];

[] spawn KOBK_fnc_initSpectator;
[player] spawn KOBK_fnc_zeusInitPlayer;
