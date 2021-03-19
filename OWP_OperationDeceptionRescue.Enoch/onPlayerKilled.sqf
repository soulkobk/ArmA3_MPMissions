params [
	"_oldUnit",
	"_killer",
	"_respawn",
	"_respawnDelay"
];

player setVariable ["savedLoadout",getUnitLoadout player];
player setCaptive false;
