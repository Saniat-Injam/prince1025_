# Payment Flow Testing Guide

## Testing the Stripe Payment Integration

### 1. Prerequisites
- Ensure the app is connected to your backend server
- Backend should have Stripe configured with test keys
- User should be logged in to the app

### 2. Testing Steps

#### Step 1: Navigate to Subscription Screen
1. Open the app
2. Go to Profile/Settings
3. Tap on "Subscription" or "Manage Subscription"

#### Step 2: Select a Plan
1. You should see monthly and yearly plans loaded from API
2. Select either the Monthly Plan or Yearly Plan
3. Verify the plan prices and features match your API data

#### Step 3: Initiate Payment
1. Tap the "Proceed" button
2. Should see loading indicator with "Creating checkout session..." message
3. App should make API call to `/payments/create-checkout-session`

#### Step 4: Stripe Checkout
1. If successful, Stripe checkout URL should open in browser
2. Should see a message: "You will be redirected to Stripe for secure payment..."
3. Browser should open with Stripe checkout page

#### Step 5: Payment Testing
**Using Stripe Test Cards:**
- **Success**: 4242 4242 4242 4242
- **Decline**: 4000 0000 0000 0002
- **Authentication Required**: 4000 0025 0000 3155

#### Step 6: Return to App
1. After payment (success or failure), return to the app
2. Should see a dialog asking about payment status
3. Can tap "Check Status" to verify subscription

### 3. Expected API Calls

#### Request Format
```json
POST /payments/create-checkout-session
{
  "planId": "plan-id-from-api",
  "userId": "user-id-from-storage"
}
```

#### Response Format
```json
{
  "url": "https://checkout.stripe.com/c/pay/cs_test_..."
}
```

### 4. Error Scenarios to Test

#### No Internet Connection
- Expected: Error message "Payment processing failed. Please try again."

#### Invalid Plan Selected
- Expected: Error message "Selected plan not found. Please try again."

#### User Not Logged In
- Expected: Error message "User not logged in. Please login again."

#### Backend API Error
- Expected: Error message from API or "Payment processing failed"

#### Invalid Checkout URL
- Expected: Error message "Invalid payment URL. Please try again."

#### Cannot Launch URL
- Expected: Error message "Cannot open payment page. Please try again."

### 5. Debugging Tips

#### Check Logs
Look for these log messages in the console:
- `🔄 Starting payment process for [plan] plan`
- `🔄 Creating checkout session with request: [request]`
- `✅ Checkout session created successfully`
- `🔄 Opening Stripe checkout URL: [url]`
- `✅ Stripe checkout URL opened successfully`

#### Common Issues
1. **Plan not found**: Check if API returned valid plans
2. **User ID missing**: Verify user is properly logged in
3. **URL not opening**: Check url_launcher package permissions
4. **API errors**: Verify backend endpoint and Stripe configuration

### 6. Success Indicators
- ✅ Loading states work properly
- ✅ Error messages are clear and helpful
- ✅ Stripe checkout opens in browser
- ✅ User can complete payment on Stripe
- ✅ User can return to app after payment
- ✅ Status checking dialog appears
- ✅ No crashes or unhandled exceptions

### 7. Mobile-Specific Testing

#### iOS
- Verify app can return from Safari to the app
- Test with different browsers if available

#### Android
- Verify app can return from Chrome to the app
- Test with different default browsers

### 8. Backend Verification
After successful payment, verify on your backend:
- Payment session was created
- Webhook events are received (if implemented)
- User subscription status is updated
- Database records are properly created

This testing guide ensures the complete payment flow works correctly and provides a good user experience.
