/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2019 soulkobk (soulkobk.blogspot.com)

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
	
	Name: fn_lightsOff.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 7:56 PM 5/08/2019
	Modification Date: 7:56 PM 5/08/2019
	
	Description:

	Parameter(s):

	Example:
	
	Change Log:
	1.0.0 -	original base script.

	----------------------------------------------------------------------------------------------
*/

params [["_object",objNull],["_distance",100]];

{
	_x setHit ["light_1_hitpoint", 0.90]; 
	_x setHit ["light_2_hitpoint", 0.90]; 
	_x setHit ["light_3_hitpoint", 0.90]; 
	_x setHit ["light_4_hitpoint", 0.90]; 
} forEach nearestObjects
[
	_object,
	[
	"Lamps_base_F", 
	"PowerLines_base_F", 
	"PowerLines_Small_base_F" 
	]
	,
	_distance
];
