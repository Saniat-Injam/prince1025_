class ApiConstants {
  static const String baseUrl = 'https://prince-lms-server.onrender.com';

  //-------------------------Authentication-------------------------
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String sendOtp = '$baseUrl/auth/send-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  // forget password
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyForgotPasswordOtp =
      '$baseUrl/auth/verify-password-otp';
  static const String resetForgotPassword = '$baseUrl/auth/reset-password';

  // -------------------------- Contact Support -------------------------
  static const String contactSupport = '$baseUrl/contact';

  //----------------------------Profile----------------------------------
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String userProfile = '$baseUrl/user/me';
  static const String userUpdate =
      '$baseUrl/user/me'; // profile image and name update

  //-----------------------------FAQ-------------------------------------
  static const String faq = '$baseUrl/faq';
  //-----------------------------Terms and Conditions -------------------
  static const String termsAndConditions = '$baseUrl/terms/categories';
  //-----------------------------Subscription plan -------------------
  static const String subscriptionPlan = '$baseUrl/plans';
  //-----------------------------Payment -------------------
  static const String createPayment = '$baseUrl/subscriptions/checkout';
  static const String subscriptionPlanById = '$baseUrl/plans/{id}';
  
  //-----------------------------Quotes -------------------
  static const String quotes = '$baseUrl/quotes';
}
