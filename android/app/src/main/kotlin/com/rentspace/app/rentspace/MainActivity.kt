package com.rentspace.app.rentspace

import io.flutter.embedding.android.FlutterActivity
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;

class MainActivity: FlutterActivity() {
     fun logSentFriendRequestEvent() {
        val logger = AppEventsLogger.newLogger(this)
        logger.logEvent("sentFriendRequest")
    }
}
