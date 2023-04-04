#if defined _telegram_included
 #endinput
#endif
#define _telegram_included

#if !defined REQUIRE_PLUGIN
public __pl_telegram_SetNTVOptional()
{
	MarkNativeAsOptional("Telegram_SendMessage");
	MarkNativeAsOptional("Telegram_SendPhoto");
	MarkNativeAsOptional("Telegram_SendPoll");
}
#endif

/**
 * Send text messages.
 *
 * @param	szText			Text of the message to be sent
 * @param	szParseMode		Markdown or HTML
 *
 * @return  void
 */
native void Telegram_SendMessage(char[] szText, char[] szParseMode);

/**
 * Send photos.
 *
 * @param	szPhoto			Photo to send. Pass an HTTP URL as a String
 *
 * @return  void
 */
native void Telegram_SendPhoto(char[] szPhoto);

/**
 * Create native poll.
 *
 * @param	szQuestion		Poll question
 * @param	Poll			List of answer options
 * @param	IsAnon			True, if the poll needs to be anonymous
 *
 * @return  void
 */
native void Telegram_SendPoll(char[] szQuestion, JSONArray Poll, bool IsAnon = true);