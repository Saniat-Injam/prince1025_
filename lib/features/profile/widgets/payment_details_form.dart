import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';

class PaymentDetailsForm extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onProceed;

  const PaymentDetailsForm({
    super.key,
    required this.isDarkTheme,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Details',
          style: getDMTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Payment Method Tabs
        _buildPaymentMethodTabs(),
        const SizedBox(height: 20),

        // Card Details Form
        _buildTextField(label: 'Card Number', hint: '1234 5678 9012 3456'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(label: 'Expiry Date', hint: 'MM/YY'),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'CVV', hint: '123')),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Cardholder Name', hint: 'John Smith'),
        const SizedBox(height: 24),

        // Security Note
        _buildSecurityNote(),
        const SizedBox(height: 24),

        // Proceed Button
        _buildProceedButton(),
      ],
    );
  }

  Widget _buildPaymentMethodTabs() {
    return Row(
      children: [
        Expanded(child: _buildTabButton(text: 'Credit Card', isSelected: true)),
        const SizedBox(width: 12),
        Expanded(child: _buildTabButton(text: 'PayPal', isSelected: false)),
      ],
    );
  }

  Widget _buildTabButton({required String text, required bool isSelected}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2D1F3F),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: getDMTextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: getDMTextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D1F3F),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: getDMTextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: getDMTextStyle(color: Colors.white38),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      children: [
        const Icon(Icons.lock_outline, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Secure payment processing. Your data is protected.',
            style: getDMTextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return ElevatedButton(
      onPressed: onProceed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        'Proceed',
        style: getDMTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
