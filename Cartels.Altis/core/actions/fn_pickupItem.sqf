/*
	File: fn_pickupItem.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Master handling for picking up an item.
*/
private["_obj","_itemInfo","_itemName","_illegal","_diff","_duped"];

if((time - life_action_delay) < 1) exitWith {hint "You can't rapidly use action keys!"};

if (isNull (findDisplay 1520)) then { _obj = cursorObject; }
else
{
	_obj = objNull;
	if ((lbCurSel 1521) > -1) then
	{
		_obj = life_pickup_item_array select (lbCurSel 1521);
	};
};

if(isNil "_obj" OR isNull _obj OR isPlayer _obj) exitWith {};
_itemInfo = _obj getVariable "item";

if ((_itemInfo select 0) == "money") exitWith { [_obj] call life_fnc_pickupMoney; };
/*
_lockedGold = false;
if ((_itemInfo select 0) == "goldbar") then {
	_vault = nearestObjects [player, ["Land_Dome_Big_F","Land_Dome_Small_F"], 50];
	if (count _vault > 0) then
	{
		_vault = _vault select 0;
		if ((_vault getVariable["life_locked",0]) == 1) then { _lockedGold = true; };
	};
};
if (_lockedGold) exitWith { hint "This gold bar belongs in a vault which is still locked!"; [[35, player, format["Attempted to gather gold bars from a locked vault!", _type]],"ASY_fnc_logIt",false,false] call life_fnc_MP;};
*/

_itemName = [([_itemInfo select 0,0] call life_fnc_varHandle)] call life_fnc_varToStr;
_illegal = [_itemInfo select 0,life_illegal_items] call life_fnc_index;

//life_return_value = "";
//[[_itemName, player],"ASY_fnc_verifyPickup",false,false] call life_fnc_MP;
//waitUntil {(life_return_value != "")};
//if (life_return_value == "1") exitWith {hint "That item has already been picked up!";};

/*if(playerSide == west && _illegal != -1) exitWith
{
	titleText[format["%1 has been placed in evidence, you have received $%2 as a reward.",_itemName,[(life_illegal_items select _illegal) select 1] call life_fnc_numberText],"PLAIN"];
	//[[31, player, format["Picked up %1 and placed in evidence for %2 reward", _itemName, (life_illegal_items select _illegal)]],"ASY_fnc_logIt",false,false] call life_fnc_MP;
	["atm","add",((life_illegal_items select _illegal) select 1)] call life_fnc_uC;
	deleteVehicle _obj;
	life_action_delay = time;
};*/
life_action_delay = time;
_diff = [_itemInfo select 0,_itemInfo select 1,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if(_diff <= 0) exitWith {hint "Can't pick up that item, you are full."};
if(_diff != _itemInfo select 1) then
{
	if(([true,_itemInfo select 0,_diff] call life_fnc_handleInv)) then
	{
		player playmove "AinvPknlMstpSlayWrflDnon";
		//sleep 0.5;
		_obj setVariable["item",[_itemInfo select 0,((_itemInfo select 1) - _diff)],true];
		titleText[format["You picked up %1 %2",_diff,_itemName],"PLAIN"];
		//[[32, player, format["Picked up %1 %2", _diff, _itemName]],"ASY_fnc_logIt",false,false] call life_fnc_MP;
	};
}
	else
{
	if(([true,_itemInfo select 0,_itemInfo select 1] call life_fnc_handleInv)) then
	{
		deleteVehicle _obj;
		player playmove "AinvPknlMstpSlayWrflDnon";
		//sleep 0.5;
		titleText[format["You picked up %1 %2",_diff,_itemName],"PLAIN"];
		//[[33, player, format["Picked up %1 %2", _diff, _itemName]],"ASY_fnc_logIt",false,false] call life_fnc_MP;
	};
};

/*
_logItems = ["dirty_money","diamondf","storage1","storage2","money","meth","speedbomb","scotch_3","treasure_1","treasure_2","treasure_3","treasure_4","treasure_5","dogp","manfleshp","scotch_0","scotch_1","scotch_2","cocainepure","cocapaste","goldbar","treasure"];
if ((_itemInfo select 0) in _logItems) then { [[33, player, format["Picked up %1 %2", _diff, _itemName]],"ASY_fnc_logIt",false,false] call life_fnc_MP; };
*/
