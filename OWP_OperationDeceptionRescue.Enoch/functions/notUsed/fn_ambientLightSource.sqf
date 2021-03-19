
params ["_object","_color"];

if (_object isEqualTo objNull) exitWith {};

_ambient = "COOLWHITE";
switch (_color) do
{
	case "COOLWHITE": {_ambient = [0.2,0.3,0.7]};
	case "WARMWHITE": {_ambient = [1,0.3,0]};
};

params ["_object"];
_light = "#lightpoint" createVehicle (getPos _object);
_light attachTo [_object, [0, 0, 0]];
_light setLightBrightness 1.5; 
_light setLightColor [1,0.85,0.6]; 
_light setLightAmbient [1,0.3,0];
_light setLightUseFlare true;
_light setLightFlareSize 1;


[_light,1.5] remoteExec ["setLightBrightness",[0,-2] select isDedicated,_light];
[_light,[1,0.85,0.6]] remoteExec ["setLightColor",[0,-2] select isDedicated,_light];
[_light,_ambient] remoteExec ["setLightAmbient",[0,-2] select isDedicated,_light];