import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/controllers/in_app_payment_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// In-app payment screen using WebView for Stripe checkout
/// Shows payment process inside the app and handles success/failure
class InAppPaymentScreen extends StatelessWidget {
  final String checkoutUrl;
  final String planName;
  final double planPrice;

  const InAppPaymentScreen({
    super.key,
    required this.checkoutUrl,
    required this.planName,
    required this.planPrice,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with payment details
    final controller = Get.put(InAppPaymentController());
    controller.initializePayment(
      url: checkoutUrl,
      name: planName,
      price: planPrice,
    );

    return _buildPaymentScreen(controller);
  }

  /// Build the main payment screen UI
  Widget _buildPaymentScreen(InAppPaymentController controller) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('$planName Payment'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            controller.showExitConfirmationDialog();
          },
        ),
        actions: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          // Clean payment info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Secure Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$planName - \$${planPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // WebView content with better styling and scrolling
          Expanded(
            child: Obx(() {
              if (controller.hasError.value) {
                return _buildErrorView(controller);
              }

              return Stack(
                children: [
                  // WebView with proper scrolling behavior
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ClipRect(
                      child: WebViewWidget(
                        controller: controller.webViewController,
                      ),
                    ),
                  ),
                  if (controller.isLoading.value)
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Loading secure payment page...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build error view when WebView fails to load
  Widget _buildErrorView(InAppPaymentController controller) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Unable to Load Payment Page',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.reloadWebView();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
