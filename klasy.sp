#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR ""
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <multicolors>

#include "codclass/globals.sp"

#pragma newdecls required

public Plugin myinfo = 
{
	name = "QClass",
	author = PLUGIN_AUTHOR,
	description = "Plugin dodający klasy na serwer CODMod",
	version = PLUGIN_VERSION,
	url = "steam/qczeqofc"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_klasa", ClassCMD);
	RegConsoleCmd("sm_class", ClassCMD);
	RegConsoleCmd("sm_mojaklasa", WhatClassCMD);
	HookEvent("player_spawn", PlayerSpawn, EventHookMode_Post);
}

char g_LastPrimaryWeapon[MAXPLAYERS + 1][50];
char g_LastSecondaryWeapon[MAXPLAYERS + 1][50];

public void Weapons_OnClientPutInServer(int client)
{
	g_LastPrimaryWeapon[client] = "";
	g_LastSecondaryWeapon[client] = "";
}

public void RemoveAllPlayerWeapons(int client)
{
	//Removing primary weapon
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	if(weapon > 0) {
		RemovePlayerItem(client, weapon);
		RemoveEdict(weapon);	
	}
	
	//Removing secondary weapon
	int weapon2 = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	if(weapon2 > 0) {
		RemovePlayerItem(client, weapon2);
		RemoveEdict(weapon2);	
	}
	
	//Removing grenades
	int weapon3 = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	if(weapon3 > 0) {
		RemovePlayerItem(client, weapon3);
		RemoveEdict(weapon3);	
	}
}
public Action ClassCMD(int client, int args)
{
	Menu yMenu = new Menu(yMenu_Handler);
	yMenu.SetTitle("Wybierz klase:");
	yMenu.AddItem("1", "Snajper");
	yMenu.ExitButton = true;
	yMenu.Display(client, 30);
}
public int yMenu_Handler(Menu menu, MenuAction action, int client, int Position)
{
	if(action == MenuAction_Select)
	{
		char Item[32];
		GetMenuItem(menu, Position, Item, sizeof(Item));
		if(StrEqual(Item, "1"))
		{
			CPrintToChat(client, "{gray}[CODMOD] {lightred}Wybrałeś klasę {lightgreen}Snajper");
			g_iClientClass[client] = 1;
		}
	}
	else if(action == MenuAction_End)
		CloseHandle(menu);
}
public void OnClientPutInServer(int client)
{
	g_iClientClass[client] = 1;
	
}
public Action PlayerSpawn(Handle event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (g_iClientClass[client] = 1){
		CPrintToChat(client, "Posiadasz klasę: Snajper");
	}
}
public Action WhatClassCMD(int client, int args){
	if (g_iClientClass[client] = 1){
		CPrintToChat(client, "Posiadasz klasę: Snajper");
	}
}