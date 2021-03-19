{
	_unit = _x;
	if ((driver (vehicle _unit)) isEqualTo _unit) then
	{
		_crew = (crew (vehicle _unit)) - [driver (vehicle _unit)] - [gunner (vehicle _unit)];
		{
			_jumper = _x;
			unassignVehicle _jumper;
			moveOut _jumper;
			[_jumper] call KOBK_fnc_autoChute;
			[group _jumper,getPosATL _jumper,(getMarkerPos "KOBK_mkr_muratynSeek")] call KOBK_fnc_taskSeekAndDestroy;
		} forEach _crew;
	};
} forEach thisList;