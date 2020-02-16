/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2017 soulkobk (soulkobk.blogspot.com)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.

	----------------------------------------------------------------------------------------------
	
	Name: fn_fireAndSmoke.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com) - credits to original BIS code.
	Creation Date: 12:00 PM 12/06/2017
	Modification Date: 12:00 PM 12/06/2017
	
	Description:

	Parameter(s): none

	Example:
	[<position>, <effect>, <duration>, <flicker>, <after glow>] remoteExec ["KOBK_fnc_fireAndSmoke",[0,-2] select isDedicated];
	aka
	[getPos this, "FIRE_LARGE", 20, true, true] remoteExec ["KOBK_fnc_fireAndSmoke",[0,-2] select isDedicated];
	
	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

private["_effect","_pos","_fire","_smoke","_duration","_afterGlow"];
private["_brightness","_color","_ambient"];
private["_eFire","_eSmoke","_eLight"];

_pos = param [0,[0,0,0]];
_effect = param [1,""];
_duration = param [2,1];
_flicker = param [3,false];
_afterGlow = param [4,false];

_fire = "";
_smoke = "";
_eLight = objNull;
_eLightFlicker = objNull;
_eLightGlow = objNull;
_color = [1,0.85,0.6];
_ambient = [1,0.3,0];

switch (_effect) do
{
	case "FIRE_SMALL" : {
		_fire = "SmallDestructionFire";
		_smoke = "SmallDestructionSmoke";
		_brightness = 0.5;
	};
	case "FIRE_MEDIUM" : {
		_fire = "MediumDestructionFire";
		_smoke = "MediumDestructionSmoke";
		_brightness = 0.75;
	};
	case "FIRE_LARGE" : {
		_fire = "BigDestructionFire";
		_smoke = "BigDestructionSmoke";
		_brightness = 1;
	};
	case "SMOKE_SMALL" : {
		_smoke = "SmallDestructionSmoke";
		_brightness = 0.5;
	};
	case "SMOKE_MEDIUM" : {
		_smoke = "MediumSmoke";
		_brightness = 0.75;
	};
	case "SMOKE_LARGE" : {
		_smoke = "BigDestructionSmoke";
		_brightness = 1;
	};
};

if (_fire != "") then
{
	_eFire = "#particlesource" createVehicleLocal _pos;
	_eFire setParticleClass _fire;
	_eFire setPosATL _pos;
	if !(_duration isEqualTo -1) then
	{
		[_eFire,_duration] spawn
		{
			params ["_eFire","_duration"];
			uiSleep _duration;
			deleteVehicle _eFire;
		};
	};
};

if (_smoke != "") then
{
	_eSmoke = "#particlesource" createVehicleLocal _pos;
	_eSmoke setParticleClass _smoke;
	_eSmoke setPosATL _pos;
	if !(_duration isEqualTo -1) then
	{
		[_eSmoke,_duration] spawn
		{
			params ["_eSmoke","_duration"];
			uiSleep _duration;
			deleteVehicle _eSmoke;
		};
	};
};

if (_effect in ["FIRE_LARGE","FIRE_MEDIUM","FIRE_SMALL"]) then
{
	_eLight = createVehicle ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
	_eLight setPosATL _pos;
	_eLight setLightBrightness _brightness;
	_eLight setLightAmbient _ambient;
	_eLight setLightColor _color;
	_eLight setLightDayLight false;
	if !(_duration isEqualTo -1) then
	{
		[_eLight,_duration] spawn
		{
			params ["_eLight","_duration"];
			uiSleep _duration;
			deleteVehicle _eLight;
		};
	};
};

if (_flicker isEqualTo true) then
{
		_eLightFlicker = createVehicle ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
		_eLightFlicker setPosATL _pos;
		_eLightFlicker setLightBrightness _brightness;
		_eLightFlicker setLightAmbient _ambient;
		_eLightFlicker setLightColor _color;
		_eLightFlicker setLightDayLight false;
		[_eLightFlicker,_duration,_brightness] spawn
		{
			params ["_eLightFlicker","_duration","_brightness"];
			_flickerTill = (time + _duration);
			while {time < _flickerTill} do
			{
				_brightness = selectRandom [0.5,0.6,0.7,0.8,0.9];
				_eLightFlicker setLightBrightness _brightness;
				uiSleep 0.05;
			};
			deleteVehicle _eLightFlicker;
		};
};

if (_afterGlow isEqualTo true) then
{
	_eLightGlow = createVehicle ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
	_eLightGlow setPosATL _pos;
	_eLightGlow setLightBrightness _brightness;
	_eLightGlow setLightAmbient _ambient;
	_eLightGlow setLightColor _color;
	_eLightGlow setLightDayLight false;
	[_eLightGlow,_duration,_brightness] spawn
	{
		params ["_eLightGlow","_duration","_brightness"];
		_glowDuration = (_duration + 120);
		_glowTill = (time + _glowDuration);
		waitUntil {time > _glowTill};
		_glowStep = (_brightness / _glowDuration);
		while {_brightness > 0} do
		{
			_brightness = _brightness - _glowStep;
			_eLightGlow setLightBrightness _brightness;
			uiSleep (_glowStep / _glowStep);
		};
		deleteVehicle _eLightGlow;
	};
};
