/*
		File: fn_splint.sqf
		Author: John "Paratus" VanderZwet

		Description: Removes pain effects
*/

_unit = cursorTarget;
_target = [_this,3,objNull,[objNull]] call BIS_fnc_param; // index 3 due to addAction
if (_target == player) then { _unit = player; };

if (isNull _unit || !(_unit isKindOf "Man") || !(isPlayer _unit) || !(alive _unit)) exitWith {hint "Not a valid target for splint.  Dead?";};
if(player distance _target > 6) exitWith {}; //Not close enough.

life_action_in_use = true; //Lockout the controls.

//Setup our progress bar
_success = false;
_title = format["Applying splint to %1",name _unit];
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable ["life_progress",displayNull];
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format["%2 (1%1)...","%",_title];
_progressBar progressSetPosition 0.01;
_cP = 0.01;

_delay = 0.2;

[[player,"AinvPknlMstpSnonWnonDnon_medic_1","switch",3.3],"life_fnc_animSync",true,false] spawn BIS_fnc_MP;
while {true} do
{
	sleep _delay;
	_cP = _cP + 0.01;
	_progressBar progressSetPosition _cP;
	_titleText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_title];
	if (!alive player || !alive _unit) exitWith {};
	if(player distance _target > 7) exitWith {};
	if(_cP >= 1) exitWith{ _success = true; };
	if (!life_action_in_use) exitWith {};
};
[[player,""],"life_fnc_animSync",true,false] spawn BIS_fnc_MP;

//Kill the UI display and check for various states
5 cutText ["","PLAIN"];
player playActionNow "stop";
if (!_success) exitWith { hint "Splint application failed."; };

if (_unit == player) then {
	[false] spawn life_fnc_brokenLeg;
	titleText["You apply a splint to your injured leg.","PLAIN"];
} else {
	[[false],"life_fnc_brokenLeg",_unit,false] spawn BIS_fnc_MP;
	titleText[format["You apply a splint to %1's injured leg.", name _unit],"PLAIN"];
	[[2,format["%1 has applied a splint to your injured leg.",name player]],"life_fnc_broadcast",_unit,false] spawn BIS_fnc_MP;
};

life_action_in_use = false;
