#include <sourcemod>
#include <SteamWorks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name	= "[Telegram] Core",
	author	= "Alexmo812 aka Alexbu444",
	version = "1.0.0",
	url = "https://t.me/alexbu444"
};

char szLogFile[256], szPath[256], szToken[256], szChatId[256], szQuery[256], szMessage[256];

public void OnPluginStart() {
	BuildPath(Path_SM, szLogFile, sizeof(szLogFile), "logs/tg_info.log");
	BuildPath(Path_SM, szPath, sizeof(szPath), "configs/telegram.cfg");

	KeyValues kv = new KeyValues("Telegram");
	
	if(!kv.ImportFromFile(szPath) || !kv.GotoFirstSubKey()) SetFailState("[Telegram] file is not found (%s)", szPath);
	
	kv.Rewind();
	
	if(kv.JumpToKey("Settings"))
	{
		kv.GetString("token", szToken, sizeof(szToken));
		kv.GetString("chatId", szChatId, sizeof(szChatId));
	}
	else
	{
		SetFailState("[Telegram] settings not found (%s)", szPath);
	}
	    
	delete kv;
}

public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max) 
{
	CreateNative("TelegramMsg", TGMsg);
	CreateNative("TelegramSend", TGSend);
	
	return APLRes_Success;
}

public int TGMsg(Handle hPlugin, int iNumParams) { 
	GetNativeString(1, szMessage, sizeof(szMessage));
}

public int TGSend(Handle hPlugin, int iNumParams) {
	FormatEx(szQuery, sizeof(szQuery), "https://api.telegram.org/bot%s/sendMessage?chat_id=%s&parse_mode=markdown&text=%s", szToken, szChatId, szMessage);
	Handle hRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodPOST, szQuery);
	SteamWorks_SetHTTPRequestHeaderValue(hRequest, "User-Agent", "telegram");
	SteamWorks_SetHTTPCallbacks(hRequest, OnTransferComplete);
	SteamWorks_SendHTTPRequest(hRequest);
}

public int OnTransferComplete(Handle hRequest, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode) {
	int sz;
	SteamWorks_GetHTTPResponseBodySize(hRequest, sz);
	char[] sBody = new char[sz];
	SteamWorks_GetHTTPResponseBodyData(hRequest, sBody, sz);
	LogToFileEx(szLogFile, "Telegram: %s", sBody);
}