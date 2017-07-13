#include <macro.h>
/*
	File: fn_adminTpHere.sqf
	Author: ColinM9991

	Description:
	Teleport selected player to you.
*/
if(__GETC__(life_adminlevel) < 1) exitWith {
  closeDialog 0;
  [[0,format["You need a higher admin level in order to open this."]],"life_fnc_broadcast",true,false] spawn BIS_fnc_MP;
};

private["_target"];
_target = lbData[2902,lbCurSel (2902)];
_target = call compile format["%1", _target];
if(isNil "_target") exitwith {};
if(isNull _target) exitWith {};
if(_unit == player) exitWith {hint localize "STR_ANOTF_Error";};

_target setPos (getPos player);
hint format["You have teleported %1 to your location",_target getVariable["realname",name _target]];
//[[0,format["ADMIN: %1 has teleported someone to his selected position.",name player]],"life_fnc_broadcast",true,false] spawn BIS_fnc_MP;