/*
	----------------------------------------------------------------------------------------------

	Copyright © 2020 soulkobk (soulkobk.blogspot.com)

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

	Name: fn_medicalCrateLoadout.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:30 PM 2/01/2020
	Modification Date: 4:30 PM 2/01/2020

	Description: none

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

params [["_crate",objNull]];

if (_crate isEqualTo objNull) exitWith {};

_crate addItemCargoGlobal ["ACE_fieldDressing",100];
_crate addItemCargoGlobal ["ACE_elasticBandage",100];
_crate addItemCargoGlobal ["ACE_packingBandage",100];
_crate addItemCargoGlobal ["ACE_quikclot",100];
_crate addItemCargoGlobal ["ACE_splint",100];
_crate addItemCargoGlobal ["ACE_tourniquet",100];

// _crate addItemCargoGlobal ["ACE_adenosine",100];
_crate addItemCargoGlobal ["ACE_epinephrine",100];
_crate addItemCargoGlobal ["ACE_morphine",100];

_crate addItemCargoGlobal ["ACE_bloodIV",100];
_crate addItemCargoGlobal ["ACE_bloodIV_500",100];
_crate addItemCargoGlobal ["ACE_bloodIV_250",100];

// _crate addItemCargoGlobal ["ACE_plasmaIV",100];
// _crate addItemCargoGlobal ["ACE_plasmaIV_500",100];
// _crate addItemCargoGlobal ["ACE_plasmaIV_250",100];

// _crate addItemCargoGlobal ["ACE_salineIV",100];
// _crate addItemCargoGlobal ["ACE_salineIV_500",100];
// _crate addItemCargoGlobal ["ACE_salineIV_250",100];

_crate addItemCargoGlobal ["ACE_surgicalKit",100];
_crate addItemCargoGlobal ["ACE_personalAidKit",100];

_crate addItemCargoGlobal ["ACE_bodyBag",100];
_crate addItemCargoGlobal ["ACE_CableTie",100];
