/*
	File: fn_respawned.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Sets the player up if he/she used the respawn option.
*/
private["_handle"];
//Reset our weight and other stuff
life_use_atm = TRUE;
life_hunger = 100;
life_thirst = 100;
life_carryWeight = 0;
life_cash = 0; //Make sure we don't get our cash back.
life_respawned = true;
life_loadout = false;
life_gotloadout = false;
[0] spawn life_fnc_setPain;
[false] spawn life_fnc_brokenLeg;
player playMove "amovpercmstpsnonwnondnon";

life_corpse setVariable["Revive",nil,TRUE];
life_corpse setVariable["name",nil,TRUE];
life_corpse setVariable["Reviving",nil,TRUE];
player setVariable["Revive",nil,TRUE];
player setVariable["name",nil,TRUE];
player setVariable["Reviving",nil,TRUE];


switch(playerSide) do
{
	case civilian: {
		[] call life_fnc_civFetchGear;
	};
	case independent: {
		[] call life_fnc_medicLoadout;
	};
};

//Cleanup of weapon containers near the body & hide it.
if(!isNull life_corpse) then {
	private["_containers"];
	_containers = nearestObjects[life_corpse,["WeaponHolderSimulated"],5];
	{deleteVehicle _x;} foreach _containers; //Delete the containers.
	deleteVehicle life_corpse;
};


//Destroy our camera...
life_deathCamera cameraEffect ["TERMINATE","BACK"];
camDestroy life_deathCamera;

//Bad boy
/*if(life_is_arrested) exitWith {
	hint localize "STR_Jail_Suicide";
	life_is_arrested = false;
	[player,TRUE] spawn life_fnc_jail;
	[] call SOCK_fnc_updateRequest;
};

//Johnny law got me but didn't let the EMS revive me, reward them half the bounty.
if(!isNil "life_copRecieve") then {
	[[player,life_copRecieve,true],"life_fnc_wantedBounty",false,false] spawn life_fnc_MP;
	life_copRecieve = nil;
};

//So I guess a fellow gang member, cop or myself killed myself so get me off that Altis Most Wanted
if(life_removeWanted) then {
	[[getPlayerUID player],"life_fnc_wantedRemove",false,false] spawn life_fnc_MP;
};
*/

[] call life_fnc_equipGear;

if (playerSide == civilian && getPlayerUID player == (life_configuration select 0)) then
{
	player forceAddUniform "U_NikosAgedBody";
};

[] call SOCK_fnc_updateRequest;
[] call life_fnc_hudUpdate; //Request update of hud.