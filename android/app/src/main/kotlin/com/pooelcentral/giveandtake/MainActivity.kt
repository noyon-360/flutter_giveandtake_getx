package com.pooelcentral.giveandtake

import android.os.Bundle
import android.util.Log
import com.paypal.android.corepayments.CoreConfig
import com.paypal.android.corepayments.Environment
import com.paypal.android.corepayments.PayPalSDKError
import com.paypal.android.paypalnativepayments.PayPalNativeCheckoutClient
import com.paypal.android.paypalnativepayments.PayPalNativeCheckoutListener
import com.paypal.android.paypalnativepayments.PayPalNativeCheckoutRequest
import com.paypal.android.paypalnativepayments.PayPalNativeCheckoutResult
import com.paypal.android.paypalnativepayments.PayPalNativePaysheetActions
import com.paypal.android.paypalnativepayments.PayPalNativeShippingAddress
import com.paypal.android.paypalnativepayments.PayPalNativeShippingMethod
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.betopia.giveandtake/paypal"
    private lateinit var payPalNativeCheckoutClient: PayPalNativeCheckoutClient
    private var resultCallback: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initPayPal") {
                val clientId = call.argument<String>("clientId")
                val returnUrl = call.argument<String>("returnUrl")
                if (clientId != null && returnUrl != null) {
                    val config = CoreConfig(clientId, environment = Environment.SANDBOX)
                    payPalNativeCheckoutClient = PayPalNativeCheckoutClient(
                        application = application,
                        coreConfig = config,
                        returnUrl = returnUrl
                    )
                    payPalNativeCheckoutClient.listener = object : PayPalNativeCheckoutListener {
                        override fun onPayPalCheckoutStart() {
                            Log.d("PayPal", "Checkout started")
                        }

                        override fun onPayPalCheckoutSuccess(result: PayPalNativeCheckoutResult) {
                            Log.d("PayPal", "Checkout success: ${result.orderId}")
                            resultCallback?.success(mapOf("orderId" to result.orderId, "payerId" to result.payerId))
                        }

                        override fun onPayPalCheckoutFailure(error: PayPalSDKError) {
                            Log.e("PayPal", "Checkout failure: ${error.errorDescription}")
                            resultCallback?.error("PAYPAL_ERROR", error.errorDescription, null)
                        }

                        override fun onPayPalCheckoutCanceled() {
                             Log.d("PayPal", "Checkout canceled")
                             resultCallback?.error("PAYPAL_CANCELED", "User canceled payment", null)
                        }

                    }
                    result.success("PayPal Initialized")
                } else {
                    result.error("INVALID_ARGS", "ClientId or ReturnUrl missing", null)
                }
            } else if (call.method == "startPayment") {
                val orderId = call.argument<String>("orderId")
                if (orderId != null) {
                    resultCallback = result
                    payPalNativeCheckoutClient.startCheckout(
                        PayPalNativeCheckoutRequest(orderId)
                    )
                } else {
                    result.error("INVALID_ARGS", "OrderId missing", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
