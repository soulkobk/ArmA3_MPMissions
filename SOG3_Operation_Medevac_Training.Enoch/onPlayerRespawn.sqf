params [
	"_newUnit",
	"_oldUnit",
	"_respawn",
	"_respawnDelay"
];

removeAllWeapons player;
removeGoggles player;
removeHeadgear player;
removeVest player;
removeUniform player;
removeAllAssignedItems player;
clearAllItemsFromBackpack player;
removeBackpack player;

player enableFatigue false;
player enableStamina false;
player setCustomAimCoef 0.1;

player setUnitTrait ["UAVHacker",true];
player setVariable ["clientOwner",clientOwner,true];

enableRadio false;
enableSentences false;

player setUnitLoadout (player getVariable ["savedLoadout",[]]);
player setCaptive false;

[player] spawn KOBK_fnc_zeusInitPlayer;

[player] call KOBK_fnc_autoChute;

player call ACE_medical_treatment_fnc_fullHealLocal;
