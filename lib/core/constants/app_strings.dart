/// Application string constants
class AppStrings {
  // App Info
  static const String appName = 'TopPay';
  static const String appVersion = '1.0.0';

  // General
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String remove = 'Remove';
  static const String update = 'Update';
  static const String refresh = 'Refresh';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Info';

  // Navigation
  static const String home = 'Home';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String about = 'About';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String close = 'Close';

  // Authentication
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Register';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String changePassword = 'Change Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String username = 'Username';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phoneNumber = 'Phone Number';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword =
      'Password must be at least 8 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';

  // Error Messages
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String timeoutError = 'Request timeout';
  static const String noInternetConnection = 'No internet connection';

  // Success Messages
  static const String dataLoadedSuccessfully = 'Data loaded successfully';
  static const String dataSavedSuccessfully = 'Data saved successfully';
  static const String dataUpdatedSuccessfully = 'Data updated successfully';
  static const String dataDeletedSuccessfully = 'Data deleted successfully';

  // Permissions
  static const String cameraPermission = 'Camera Permission';
  static const String storagePermission = 'Storage Permission';
  static const String locationPermission = 'Location Permission';
  static const String permissionDenied = 'Permission denied';
  static const String permissionRequired = 'Permission required to continue';

  // Theme
  static const String lightTheme = 'Light Theme';
  static const String darkTheme = 'Dark Theme';
  static const String systemTheme = 'System Theme';

  // Home Screen
  static const String welcomeMessage = 'Welcome to TopPay!';
  static const String homeTitle = 'Home';
  static const String counterText =
      'You have pushed the button this many times:';
  static const String incrementTooltip = 'Increment';

  // Get Started Screen
  static const String getStartedTitle = 'Real Nigerian Creators, Real Impact';
  static const String getStartedSubtitle =
      'Connect with trusted creators whose influence is built on authenticity, not guesswork. Our platform empowers brands to find the perfect partners to tell their stories.';
  static const String getStartedButton = 'Get Started';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signIn = ' Sign In';

  // Sign Up Screen
  static const String signUpTitle = 'Get Started';
  static const String signUpButton = 'Sign Up';
  static const String enterFirstName = 'Enter first name';
  static const String enterLastName = 'Enter last name';
  static const String enterEmail = 'Enter email';
  static const String enterPassword = 'Enter password';
  static const String enterConfirmPassword = 'confirm password';
  static const String termsAgreement =
      'By clicking Continue, you agree to the ';
  static const String washayPledge = 'Washay Pledge';
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueWithApple = 'Continue with Apple';
  static const String orDivider = 'or';
  static const String socialLoginComingSoon = ' sign up coming soon!';

  // Login Screen
  static const String loginTitle = 'Login';
  static const String loginButton = 'Login';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUp = ' Sign Up';
  static const String socialLoginComingSoonLogin = ' login coming soon!';

  // forget password reset password
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotResetPasswordButton = 'Proceed';
  static const String resetPasswordTitle = 'Reset Password';
  static const String changePasswordTitle = 'Change Password';
  static const String oldPasswordTitle = 'Old Password';
  static const String newPasswordTitle = 'New Password';

  // OTP Screen
  static const String otpTitle = 'Enter OTP';
  static const String otpSubtitle = 'We sent a 4-digit code to your mail ';
  static const String otpVerifyButton = 'Verify';
  static const String didntReceiveCode = "Didn't receive the code? ";
  static const String resendCode = 'Resend Code';
  static const String otpErrorInvalid = 'Please enter a 4-digit code';
  static const String otpVerificationComingSoon =
      'OTP verification coming soon!';
  static const String resendingCode = 'Resending code...';

  // Connect Accounts Screen
  static const String connectAccountsTitle = 'Connect at least 1 account';
  static const String proceedButton = 'Proceed';
  static const String tiktok = 'Tiktok';
  static const String instagram = 'Instagram';
  static const String twitter = 'Twitter';
  static const String facebook = 'Facebook';
  static const String selectAtLeastOne = 'Please select at least one account';
  static const String connected = 'Connected';
  static const String disconnect = 'Disconnect';
}

// /// User-facing copy, centralized for easy localization later.
// class AppStrings {
//   AppStrings._();
//
//   static const appName = 'TopPay';
//   static const tagline = 'Airtime, Data & Bills. Instantly.';
//
//   // Auth
//   static const login = 'Login';
//   static const register = 'Create Account';
//   static const welcomeBack = 'Welcome back';
//   static const loginSubtitle = 'Login to continue managing your subscriptions';
//   static const registerSubtitle = 'Create an account to get started';
//   static const forgotPassword = 'Forgot Password?';
//   static const dontHaveAccount = "Don't have an account? ";
//   static const alreadyHaveAccount = 'Already have an account? ';
//   static const verifyOtp = 'Verify OTP';
//   static const otpSubtitle = 'Enter the 6-digit code sent to';
//
//   // Errors
//   static const genericError = 'Something went wrong. Please try again.';
//   static const noInternet = 'No internet connection.';
//   static const insufficientBalance = 'Insufficient wallet balance.';
//   static const invalidPin = 'Incorrect transaction PIN.';
//
//   // Misc
//   static const comingSoon = 'Coming soon';
// }
