class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://api.toppay.com/v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  // Profile
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String setTransactionPin = '/user/pin/set';
  static const String changeTransactionPin = '/user/pin/change';
  static const String verifyTransactionPin = '/user/pin/verify';
  static const String kycVerification = '/user/kyc';

  // Wallet & Funding
  static const String walletBalance = '/wallet/balance';
  static const String virtualAccounts = '/wallet/virtual-accounts';
  static const String fundWalletCard = '/wallet/fund/card';
  static const String verifyWalletFunding = '/wallet/fund/verify';

  // Airtime & Data
  static const String airtimeNetworks = '/vtu/airtime/networks';
  static const String buyAirtime = '/vtu/airtime/buy';

  static const String dataNetworks = '/vtu/data/networks';
  static const String dataPlans = '/vtu/data/plans';
  static const String buyData = '/vtu/data/buy';

  // Cable TV & Electricity
  static const String cableProviders = '/bills/cable/providers';
  static const String cablePackages = '/bills/cable/packages';
  static const String validateSmartCard = '/bills/cable/validate';
  static const String buyCablePackage = '/bills/cable/buy';

  static const String electricityDiscos = '/bills/electricity/discos';
  static const String validateMeterNumber = '/bills/electricity/validate';
  static const String buyElectricity = '/bills/electricity/buy';

  // Other Services
  static const String bettingProviders = '/services/betting/providers';
  static const String validateBetCustomerId = '/services/betting/validate';
  static const String fundBetAccount = '/services/betting/fund';

  static const String eduPins = '/services/education/pins';
  static const String buyEduPin = '/services/education/buy';

  // Transactions & History
  static const String transactions = '/transactions';
  static const String transactionDetails = '/transactions/';
  static const String verifyTransaction = '/transactions/verify/';

  // Utilities & Notifications
  static const String notifications = '/notifications';
  static const String appSettings = '/settings';
  static const String serviceStatus = '/services/status';
}
