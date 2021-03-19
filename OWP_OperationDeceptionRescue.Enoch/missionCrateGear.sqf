params ["_crate"];

waitUntil {!(isNull _crate)};

clearBackpackCargoGlobal _crate; 
clearMagazineCargoGlobal _crate; 
clearWeaponCargoGlobal _crate; 
clearItemCargoGlobal _crate;

// PRIMARYWEAPON

_primaryWeapons = 
[
	"SMA_M4_GL", // M4A1 Tactical (M203) - PRIMARYWEAPON - SMA
	"SMA_M4_GL_SM", // M4A1 Tactical SM(M203) - PRIMARYWEAPON - SMA
	"SMA_M4afg", // M4A1 Tactical Blk(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_SM", // M4A1 Tactical Blk SM(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_Tan", // M4A1 Tactical Tan(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_Tan_SM", // M4A1 Tactical Tan SM(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_OD", // M4A1 Tactical OD(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_OD_SM", // M4A1 Tactical OD SM(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_BLK1", // M4A1 Tactical Blk2(afg) - PRIMARYWEAPON - SMA
	"SMA_M4afg_BLK1_SM", // M4A1 Tactical Blk2 SM(afg) - PRIMARYWEAPON - SMA
	"SMA_M4MOE", // M4A1 Tactical Blk(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_SM", // M4A1 Tactical Blk SM(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_Tan", // M4A1 Tactical Tan(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_Tan_SM", // M4A1 Tactical Tan SM(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_OD", // M4A1 Tactical OD(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_OD_SM", // M4A1 Tactical OD SM(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_BLK1", // M4A1 Tactical Blk2(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4MOE_BLK1_SM", // M4A1 Tactical Blk2 SM(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4afgSTOCK", // M4A1 Tactical Standard Blk(VFG) - PRIMARYWEAPON - SMA
	"SMA_M4CQBR", // M4A1 Tactical SBR Blk(AFG) - PRIMARYWEAPON - SMA
	"SMA_M4CQBRMOE" // M4A1 Tactical SBR Blk(VFG) - PRIMARYWEAPON - SMA
];

{
	_crate addWeaponCargoGlobal [_x,24];
} forEach _primaryWeapons;
	
// SCOPES

_scopes =
[
	"SMA_ELCAN_SPECTER", // ELCAN SpecterDR DFOV14-C1 - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_TAN", // ELCAN SpecterDR DFOV14-C1(TAN) - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_GREEN", // ELCAN SpecterDR DFOV14-C1(FDE) - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_ARDRDS", // ELCAN SpecterDR DFOV14-C1 RDS-ARD - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_TAN_ARDRDS", // ELCAN SpecterDR DFOV14-C1(TAN) RDS-ARD - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_GREEN_ARDRDS", // ELCAN SpecterDR DFOV14-C1(FDE) RDS-ARD - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_RDS", // ELCAN SpecterDR DFOV14-C1 RDS - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_TAN_RDS", // ELCAN SpecterDR DFOV14-C1(TAN) RDS - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_GREEN_RDS", // ELCAN SpecterDR DFOV14-C1(FDE) RDS - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_4z", // ELCAN SpecterDRCS DFOV14-C1 - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_TAN_4z", // ELCAN SpecterDRCS DFOV14-C1(TAN) - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_GREEN_4z", // ELCAN SpecterDRCS DFOV14-C1(FDE) - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_ARDRDS_4z", // ELCAN SpecterDRCS DFOV14-C1 RDS-ARD - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_TAN_ARDRDS_4z", // ELCAN SpecterDRCS DFOV14-C1(TAN) RDS-ARD - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_GREEN_ARDRDS_4z", // ELCAN SpecterDRCS DFOV14-C1(FDE) RDS-ARD - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_RDS_4z", // ELCAN SpecterDRCS DFOV14-C1 RDS - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_TAN_RDS_4z", // ELCAN SpecterDRCS DFOV14-C1(TAN) RDS - ITEM - VANILLA
	"SMA_ELCAN_SPECTER_GREEN_RDS_4z" // ELCAN SpecterDRCS DFOV14-C1(FDE) RDS - ITEM - VANILLA
];

{
	_crate addItemCargoGlobal [_x,24];
} forEach _scopes;

// AMMO

_ammunition =
[
	"SMA_30Rnd_556x45_M855A1", // M855A1 EPR 5.56mm 30rnd Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_M855A1_Tracer", // M855A1 EPR 5.56mm 30rnd Tracer Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_M855A1_IR", // M855A1 EPR  5.56mm 30rnd IR Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_Mk318", // Mk318 Mod 1 SOST 5.56mm 30rnd  Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_Mk318_Tracer", // Mk318 Mod 1 SOST 5.56mm 30rnd  Tracer Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_Mk318_IR", // Mk318 Mod 1 SOST 5.56mm 30rnd IR Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_Mk262", // Mk262 Mod 1 SBLR 5.56mm 30rnd Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_Mk262_Tracer", // Mk262 Mod 1 SBLR 5.56mm 30rnd Tracer Mag - MAGAZINE - VANILLA
	"SMA_30Rnd_556x45_Mk262_IR" // Mk262 Mod 1 SBLR 5.56mm 30rnd IR Mag - MAGAZINE - VANILLA
];

{
	_crate addMagazineCargoGlobal [_x,24];
} forEach _ammunition;

// GRENADES
_grenades =
[
	"1Rnd_HE_Grenade_shell", // 40 mm HE Grenade Round - MAGAZINE - VANILLA
	"1Rnd_Smoke_Grenade_shell", // Smoke Round (White) - MAGAZINE - VANILLA
	"1Rnd_SmokeRed_Grenade_shell", // Smoke Round (Red) - MAGAZINE - VANILLA
	"1Rnd_SmokeGreen_Grenade_shell", // Smoke Round (Green) - MAGAZINE - VANILLA
	"1Rnd_SmokeYellow_Grenade_shell", // Smoke Round (Yellow) - MAGAZINE - VANILLA
	"1Rnd_SmokePurple_Grenade_shell", // Smoke Round (Purple) - MAGAZINE - VANILLA
	"1Rnd_SmokeBlue_Grenade_shell", // Smoke Round (Blue) - MAGAZINE - VANILLA
	"1Rnd_SmokeOrange_Grenade_shell" // Smoke Round (Orange) - MAGAZINE - VANILLA
];

{
	_crate addMagazineCargoGlobal [_x,24];
} forEach _grenades;

// LASER/FLASHLIGHT
_primaryWeaponLight =
[
	"SMA_SFPEQ_M4TOP_TAN", // Laser Light Combo tan(Top Mount) AR15 - ITEM - SMA
	"SMA_SFPEQ_M4TOP_BLK" // Laser Light Combo Black(Top Mount) AR15 - ITEM - SMA
];

{
	_crate addItemCargoGlobal [_x,24];
} forEach _primaryWeaponLight;

// SUPRESSOR
_primaryWeaponSupressor =
[
	"SMA_supp2smaB_556", // SMA SOCOM II Blk - ITEM - SMA
	"SMA_supp2smaT_556" // SMA SOCOM II Tan - ITEM - SMA
];

{
	_crate addItemCargoGlobal [_x,24];
} forEach _primaryWeaponSupressor;

// HELMET
_helmet =
[
	"BLK2_opscore", // Opscore Multicam Black - ITEM - VANILLA
	"BLK_opscore_2" // Opscore 2 Multicam Black - ITEM - VANILLA
];

{
	_crate addItemCargoGlobal [_x,24];
} forEach _helmet;

// UNIFORM
_uniform =
[
	"black_Crye_Camo", // Multicam Black (Crye G3) - ITEM - VANILLA
	"black_Crye2_Camo", // Multicam Black V2(Crye G3) - ITEM - VANILLA
	"Multicam_black_casual_Camo", // Multicam Black Crye G3 Button Up - ITEM - VANILLA
	"Black_Black_Camo", // Multicam Black - Black Shirt (Crye G3) - ITEM - VANILLA
	"Black_Crye_SS_Camo", // Multicam Black SS (Crye G3) - ITEM - VANILLA
	"Black_Black_SS_Camo" // Multicam Black - Black Shirt SS (Crye G3) - ITEM - VANILLA
];

{
	_crate addItemCargoGlobal [_x,24];
} forEach _uniform;
	
// CHEST RIG
_vest =
[
	"dr_BLKlbt_op", // Multicam Black LBT6094 (Operator) - ITEM - VANILLA
	"dr_BLKlbt_mg", // Multicam Black LBT6094 (Gunner) - ITEM - VANILLA
	"dr_BLKlbt_br", // Multicam Black LBT6094 (Breacher) - ITEM - VANILLA
	"dr_BLKfacp_op", // Multicam Black FACP (Operator) - ITEM - VANILLA
	"dr_BLKfacp_br", // Multicam Black FACP (Breacher) - ITEM - VANILLA
	"dr_BLKfacp_mg", // Multicam Black FACP (Gunner) - ITEM - VANILLA
	"dr_BLKpar_op", // Multicam Black Paraclete (Operator) - ITEM - VANILLA
	"dr_BLKpar_br", // Multicam Black Paraclete (Breacher) - ITEM - VANILLA
	"dr_BLKpar_mg" // Multicam Black Paraclete (Gunner) - ITEM - VANILLA
];

{
	_crate addItemCargoGlobal [_x,24];
} forEach _vest;
	
// BACKPACK
_backpack =
[
	"Black_Backpack_Compact", // Multicam Black Compact Bag - BACKPACK - VANILLA
	"Black_Carryall", // Multicam Black CarryAll - BACKPACK - VANILLA
	"Black_Backpack_kitbag" // Multicam Black Kitbag - BACKPACK - VANILLA
];

{
	_crate addBackpackCargoGlobal  [_x,24];
} forEach _backpack;
