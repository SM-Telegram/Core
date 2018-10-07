#if defined _telegram_included
 #endinput
#endif
#define _telegram_included

#if !defined REQUIRE_PLUGIN
public __pl_telegram_SetNTVOptional()
{
	MarkNativeAsOptional("TelegramMsg");
	MarkNativeAsOptional("TelegramSend");
}
#endif

/**
 * Setup a message text.
 *
 * @param   szMessage      Text
 *
 * @return  void
 */
native void TelegramMsg(const char[] szMessage);

/**
 * Ends a message, sending into Telegram.
 *
 * @return  void
 */
native void TelegramSend();