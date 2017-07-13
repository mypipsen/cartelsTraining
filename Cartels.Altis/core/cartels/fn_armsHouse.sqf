/*
	File: fn_armsHouse.sqf
	Author: Pentax

	Description:
	Changes Arms Dealer's location.
*/

#include <macro.h>

if(__GETC__(life_adminlevel) == 0) exitWith {
  systemChat "You need to be an admin to use this function.";
};

[] spawn {
  while {dialog} do {
   closeDialog 0;
   sleep 0.01;
  };
};

"capture_label_1" setMarkerPos getMarkerPos "capture_1_house";
"capture_area_1" setMarkerPos getMarkerPos "capture_1_house";
capture_1 setpos (getMarkerpos "capture_1_house");

[[0,format["ADMIN: %1 has changed Arms Dealer location. New location: House Arms.",name player]],"life_fnc_broadcast",true,false] spawn BIS_fnc_MP;
