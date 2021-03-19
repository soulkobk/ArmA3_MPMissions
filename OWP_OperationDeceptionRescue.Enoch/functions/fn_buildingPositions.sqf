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

	Name: fn_buildingPositions.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:39 PM 17/08/2019
	Modification Date: 5:39 PM 17/08/2019

	Description:

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params ["_marker","_numPositions"];

_areaSize = selectMax getMarkerSize _marker;
_nearestBuildings = (nearestObjects [getMarkerPos _marker, ["House"], _areaSize]);

_areaPositions = [];
{
	_buildingPositions = _x buildingPos -1;
	if !(_buildingPositions isEqualTo []) then
	{
		_areaPositions = _areaPositions + _buildingPositions;
	};
} forEach _nearestBuildings;

if (_numPositions > (count _areaPositions)) then
{
	_numPositions = (count _areaPositions);
};

_positionsRandom = [];
for [{_i=0},{_i<_numPositions},{_i=_i+1}] do
{
	_positionRandom = selectRandom _areaPositions;
	_areaPositions = _areaPositions - _positionRandom;
	_positionsRandom pushBack _positionRandom;
};

_positionsRandom
