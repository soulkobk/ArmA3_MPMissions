params ["_newUnit","_oldUnit"];
///////////////////////////////////////////////////////////////////////////////
player enableFatigue false;
player enableStamina false;
player setCustomAimCoef 0.1;
player setUnitTrait ["UAVHacker",true];
enableRadio false;
enableSentences false;
///////////////////////////////////////////////////////////////////////////////
// for zeus allocation
// [] spawn
// {
	// if ((!isNil "SGC_var_whiteListedZeus") && (!isNil "SGC_var_zeusInit")) then
	// {
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
		// };
	// };
// };
// [player] spawn SGC_fnc_zeusInitPlayer;
[player] remoteExec ["SGC_fnc_zeusInitPlayer",[0,-2] select isDedicated];
///////////////////////////////////////////////////////////////////////////////
