params ["_newUnit","_oldUnit"];
///////////////////////////////////////////////////////////////////////////////
player enableFatigue false;
player enableStamina false;
player setCustomAimCoef 0.1;
player setUnitTrait ["loadCoef",9999];
player setUnitTrait ["UAVHacker",true];
enableRadio false;
enableSentences false;
///////////////////////////////////////////////////////////////////////////////
// for zeus allocation
[player] remoteExec ["OWP_fnc_zeusInitPlayer",[0,-2] select isDedicated];
///////////////////////////////////////////////////////////////////////////////
