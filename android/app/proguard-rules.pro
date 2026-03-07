-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
# Keep Stripe classes
-keep class com.stripe.** { *; }

# Keep Cardinal Commerce classes (3DS)
-keep class com.cardinalcommerce.** { *; }
-dontwarn com.cardinalcommerce.**

# Keep BouncyCastle classes
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Keep Conscrypt classes
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# Keep OpenJSSE classes
-keep class org.openjsse.** { *; }
-dontwarn org.openjsse.**

# Keep javax.xml.stream classes
-dontwarn javax.xml.stream.**
-keep class javax.xml.stream.** { *; }

# Keep Apache Tika classes
-keep class org.apache.tika.** { *; }
-dontwarn org.apache.tika.**

# Keep OkHttp platform classes
-keep class okhttp3.internal.platform.** { *; }
-dontwarn okhttp3.internal.platform.**