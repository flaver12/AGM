/*
 * Author: CAA-Picard
 *
 * Select the next grenade muzzle to throw.
 *
 * Argument:
 * muzzle name
 *
 * Return value:
 * None
 *
 */

 _muzzle = _this;

_uniformMags = getMagazineCargo uniformContainer player;
_vestMags = getMagazineCargo vestContainer player;
_backPackMags = getMagazineCargo backpackContainer player;

_uniformMagsToRemove = [];
_vestMagsToRemove = [];
_backPackMagsToRemove = [];

_firstMagazine = "";

// Collect which magazines to remove
_throwMuzzleNames = getArray (configfile >> "CfgWeapons" >> "Throw" >> "muzzles");
{
  _muzzleName = _x;
  _muzzleMagazines = getArray (configFile >> "CfgWeapons" >> "Throw" >> _muzzleName >> "magazines" );
  if (_muzzle != _muzzleName) then {
    {
      _index = (_uniformMags select 0) find _x;
      if (_index > -1) then {
        _uniformMagsToRemove = _uniformMagsToRemove + [[_x, (_uniformMags select 1) select _index]];
      };
      _index = (_vestMags select 0) find _x;
      if (_index > -1) then {
        _vestMagsToRemove = _vestMagsToRemove + [[_x, (_vestMags select 1) select _index]];
      };
      _index = (_backpackMags select 0) find _x;
      if (_index > -1) then {
        _backpackMagsToRemove = _backpackMagsToRemove + [[_x, (_backpackMags select 1) select _index]];
      };
    } forEach _muzzleMagazines;
  } else {
    {
      _index = (_uniformMags select 0) find _x;
      if (_index > -1) then {
        _firstMagazine = _x;
      };
      _index = (_vestMags select 0) find _x;
      if (_index > -1) then {
        _firstMagazine = _x;
      };
      _index = (_backpackMags select 0) find _x;
      if (_index > -1) then {
        _firstMagazine = _x;
      };
    } forEach _muzzleMagazines;
  };
} forEach _throwMuzzleNames;

// Remove all magazines except those we are switching to --> this breaks the selector
{
  for [{_i=0},{_i < (_x select 1)}, {_i = _i + 1}] do {
    player removeItem (_x select 0);
  };
} forEach _uniformMagsToRemove;
{
  for [{_i=0},{_i < (_x select 1)}, {_i = _i + 1}] do {
    player removeItem (_x select 0);
  };
} forEach _vestMagsToRemove;
{
  for [{_i=0},{_i < (_x select 1)}, {_i = _i + 1}] do {
    player removeItem (_x select 0);
  };
} forEach _backPackMagsToRemove;

if (_muzzle != "") then {
  // Fix the selector
  if (player canAdd "HandGrenade_Stone") then {
    // If there's space, add and remove an item
    // We use HandGrenade_Stone to ensure we remove the same item we added a no other placed somewhere else
    player addItem "HandGrenade_Stone"; player removeItem "HandGrenade_Stone";
  } else {
    // If there's no extra space, remove the current grenade and readd it.
    // The correct grenade placement should be kept, as there's no place for the grenade to go except the correct one.
    player removeItem _firstMagazine; player addItem _firstMagazine;
  };
};

// Readd magazines
{
  uniformContainer player addItemCargo _x;
} forEach _uniformMagsToRemove;
{
  vestContainer player addItemCargo _x;
} forEach _vestMagsToRemove;
{
  backpackContainer player addItemCargo _x;
} forEach _backPackMagsToRemove;

