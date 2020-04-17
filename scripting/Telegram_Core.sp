#include <sourcemod>
#include <ripext>

static const char APIURL[256] = "https://api.telegram.org/bot<TOKEN>"; // @BotFather
static const char ChatId[256] = "";

public Plugin myinfo =
{
	author = "Alexbu444",
	name = "[Telegram] Core (LiteServers LLP)",
	description	= "Library for sending messages via bot to Telegram",
	version = "1.1.0",
	url = "https://t.me/alexmo812"
};

HTTPClient httpClient;

public void OnPluginStart()
{
	httpClient = new HTTPClient(APIURL);
}

public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max) 
{
	CreateNative("Telegram_SendMessage", TG_SendMessage);
	CreateNative("Telegram_SendPhoto", TG_SendPhoto);
	CreateNative("Telegram_SendPoll", TG_SendPoll);
	
	return APLRes_Success;
}

public int TG_SendMessage(Handle hPlugin, int iNumParams)
{
	char szText[256];
	GetNativeString(1, szText, sizeof(szText));
	
	char szParseMode[256];
	GetNativeString(2, szParseMode, sizeof(szParseMode));
	
	JSONObject hRequest = new JSONObject();
	hRequest.SetString("chat_id", ChatId);
	hRequest.SetString("text", szText);
	hRequest.SetString("parse_mode", szParseMode);
	
	httpClient.Post("sendMessage", hRequest, OnRequestComplete);
	
	delete hRequest;
}

public int TG_SendPhoto(Handle hPlugin, int iNumParams)
{
	char szPhoto[256];
	GetNativeString(1, szPhoto, sizeof(szPhoto));
	
	JSONObject hRequest = new JSONObject();
	hRequest.SetString("chat_id", ChatId);
	hRequest.SetString("photo", szPhoto);
	
	httpClient.Post("sendPhoto", hRequest, OnRequestComplete);
	
	delete hRequest;
}

public int TG_SendPoll(Handle hPlugin, int iNumParams)
{
	char szQuestion[256];
	GetNativeString(1, szQuestion, sizeof(szQuestion));
	
	JSONArray Poll = GetNativeCell(2);	
	bool IsAnon = GetNativeCell(3);
	
	JSONObject hRequest = new JSONObject();
	hRequest.SetString("chat_id", ChatId);
	hRequest.SetString("question", szQuestion);
	hRequest.Set("options", Poll);
	hRequest.SetBool("is_anonymous", IsAnon);
	
	httpClient.Post("sendPoll", hRequest, OnRequestComplete);
	
	delete hRequest;
}

public void OnRequestComplete(HTTPResponse hResponse, any value)
{
	if (hResponse.Status != HTTPStatus_Created)
		return;

	if (hResponse.Data == null)
		return;
}