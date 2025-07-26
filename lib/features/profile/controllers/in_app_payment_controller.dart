import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/controllers/subscription_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:logger/logger.dart';

/// Controller for In-app payment screen WebView management
/// Handles payment URL loading, completion detection, and user interface state
class InAppPaymentController extends GetxController {
  // Dependencies
  final Logger logger = Logger();

  // Observable properties
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // WebView controller
  late final WebViewController webViewController;

  // Payment details
  late String checkoutUrl;
  late String planName;
  late double planPrice;

  /// Initialize controller with payment details
  void initializePayment({
    required String url,
    required String name,
    required double price,
  }) {
    checkoutUrl = url;
    planName = name;
    planPrice = price;
    _initializeWebView();
  }

  /// Initialize WebView controller with payment URL
  void _initializeWebView() {
    logger.i('🔄 Initializing WebView for payment: $checkoutUrl');

    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setUserAgent(
            'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          )
          // Enable scrolling and zooming for better user experience
          ..enableZoom(true)
          ..addJavaScriptChannel(
            'PaymentChannel',
            onMessageReceived: (JavaScriptMessage message) {
              logger.i('📨 JavaScript message: ${message.message}');
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                logger.i('🔄 WebView loading progress: $progress%');
              },
              onPageStarted: (String url) {
                logger.i('🔄 WebView page started: $url');
                isLoading.value = true;
                hasError.value = false;
              },
              onPageFinished: (String url) {
                logger.i('✅ WebView page finished: $url');
                isLoading.value = false;

                // Inject CSS to improve appearance and enable scrolling
                _injectCustomCSS();

                // Inject CSS again after a short delay to handle dynamic content
                Future.delayed(const Duration(milliseconds: 500), () {
                  _injectCustomCSS();
                });

                _checkForPaymentCompletion(url);
              },
              onWebResourceError: (WebResourceError error) {
                logger.e('❌ WebView error: ${error.description}');
                isLoading.value = false;
                hasError.value = true;
                errorMessage.value = error.description;
              },
              onNavigationRequest: (NavigationRequest request) {
                logger.i('🔄 Navigation request: ${request.url}');

                // Check for payment completion URLs
                if (_isPaymentCompleteUrl(request.url)) {
                  _handlePaymentCompletion(request.url);
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(checkoutUrl));
  }

  /// Inject custom CSS to improve the appearance of Stripe checkout
  void _injectCustomCSS() {
    webViewController.runJavaScript('''
      try {
        // Create style element
        var style = document.createElement('style');
        style.innerHTML = `
          body {
            background-color: #ffffff !important;
            color: #000000 !important;
            overflow-y: auto !important;
            -webkit-overflow-scrolling: touch !important;
            height: auto !important;
            min-height: 100vh !important;
          }
          
          /* Enable smooth scrolling */
          html {
            scroll-behavior: smooth !important;
            overflow-y: auto !important;
          }
          
          /* Stripe checkout container */
          .StripeElement {
            background-color: #ffffff !important;
            color: #000000 !important;
          }
          
          /* Form container with proper scrolling */
          .App, .App > div, main, section {
            background-color: #ffffff !important;
            overflow-y: auto !important;
            height: auto !important;
            min-height: 100% !important;
          }
          
          /* Input fields */
          input, select, textarea {
            background-color: #ffffff !important;
            color: #000000 !important;
            border: 1px solid #e0e0e0 !important;
          }
          
          /* Labels and text */
          label, span, p, div {
            color: #000000 !important;
          }
          
          /* Button styling */
          button {
            background-color: #007bff !important;
            color: #ffffff !important;
            border: none !important;
            border-radius: 8px !important;
            padding: 12px 24px !important;
            font-weight: 600 !important;
          }
          
          button:hover {
            background-color: #0056b3 !important;
          }
          
          /* Override any dark theme */
          * {
            color-scheme: light !important;
          }
          
          /* Ensure content is scrollable on mobile */
          @media (max-width: 768px) {
            body {
              touch-action: pan-y !important;
              overflow-y: scroll !important;
            }
          }
        `;
        document.head.appendChild(style);
        
        // Force light mode
        document.documentElement.style.colorScheme = 'light';
        document.body.style.backgroundColor = '#ffffff';
        document.body.style.color = '#000000';
        
        // Enable scrolling explicitly
        document.body.style.overflow = 'auto';
        document.body.style.overflowY = 'auto';
        document.documentElement.style.overflow = 'auto';
        document.documentElement.style.overflowY = 'auto';
        
        // Enable touch scrolling on mobile
        document.body.style.webkitOverflowScrolling = 'touch';
        document.body.style.touchAction = 'pan-y';
        
        // Set proper viewport and height
        var viewportMeta = document.querySelector('meta[name="viewport"]');
        if (!viewportMeta) {
          viewportMeta = document.createElement('meta');
          viewportMeta.setAttribute('name', 'viewport');
          document.head.appendChild(viewportMeta);
        }
        viewportMeta.setAttribute('content', 'width=device-width, initial-scale=1.0, user-scalable=yes');
        
        console.log('Custom CSS and scrolling settings injected successfully');
      } catch (e) {
        console.log('Error injecting CSS:', e);
      }
    ''');
  }

  /// Check if URL indicates payment completion
  bool _isPaymentCompleteUrl(String url) {
    return url.contains('success') ||
        url.contains('cancel') ||
        url.contains('return') ||
        url.contains('checkout/complete') ||
        url.contains('payment/success') ||
        url.contains('payment/cancel');
  }

  /// Check for payment completion based on current URL
  void _checkForPaymentCompletion(String url) {
    if (_isPaymentCompleteUrl(url)) {
      _handlePaymentCompletion(url);
    }
  }

  /// Handle payment completion (success or failure)
  void _handlePaymentCompletion(String url) {
    logger.i('🎯 Payment completion detected: $url');

    final bool isSuccess =
        url.contains('success') || url.contains('checkout/complete');
    final bool isCancel = url.contains('cancel');

    if (isSuccess) {
      logger.i('✅ Payment successful');
      showPaymentSuccessDialog();
    } else if (isCancel) {
      logger.i('⚠️ Payment cancelled by user');
      showPaymentCancelledDialog();
    } else {
      logger.w('⚠️ Payment completion with unknown status');
      showPaymentUnknownDialog();
    }
  }

  /// Show payment success dialog
  void showPaymentSuccessDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your $planName subscription has been activated successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Amount: \$${planPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You now have access to all premium features!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Close payment screen
                refreshUserProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show payment cancelled dialog
  void showPaymentCancelledDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.cancel_outlined,
                color: Colors.orange,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Cancelled',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your payment was cancelled. No charges were made to your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Close payment screen
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.black26),
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    // Stay on payment screen to retry
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show unknown payment status dialog
  void showPaymentUnknownDialog() {
    Get.dialog(
      AlertDialog(
        icon: const Icon(Icons.help_outline, color: Colors.blue, size: 64),
        title: const Text('Payment Status'),
        content: const Text(
          'We\'re verifying your payment status. Please check your subscription status in a few minutes.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close payment screen
              refreshUserProfile();
            },
            child: const Text('Check Status'),
          ),
        ],
      ),
    );
  }

  /// Refresh user profile to get updated subscription status
  void refreshUserProfile() {
    try {
      // Call subscription controller to check status
      final subscriptionController = Get.find<SubscriptionController>();
      subscriptionController.checkSubscriptionStatus();

      // You can also call ProfileController to refresh user data
      // Example: Get.find<ProfileController>().fetchUserProfileFromApi();
      logger.i('🔄 Refreshing user profile after payment');
    } catch (e) {
      logger.e('❌ Error refreshing user profile: $e');
    }
  }

  /// Reload WebView when there's an error
  void reloadWebView() {
    hasError.value = false;
    isLoading.value = true;
    webViewController.reload();
  }

  /// Show exit confirmation dialog
  void showExitConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Exit Payment?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          'Are you sure you want to exit the payment process? Your payment will not be processed.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.black26),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Close payment screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Exit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
