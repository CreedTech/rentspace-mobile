// ignore_for_file: constant_identifier_names

class AppConstants {
  static const BASE_URL = 'https://rentspacetech-backend-production.up.railway.app';
  static const SIGN_UP = '/api/user/create';
  static const GET_WALLET = '/api/wallet/get-wallet';
  static const WALLET_TRANSFER = '/api/wallet/wallet-withdrawal';
  static const CREATE_PIN = '/api/wallet/create-pin';
  static const FORGOT_PIN = '/api/wallet/reset-pin';
  static const RESEND_PIN_OTP = '/api/wallet/resend-pinOtp';
  static const VERIFY_RESET_PIN_OTP = '/api/wallet/verify-otp';
  static const SET_NEW_PIN_OTP = '/api/wallet/set-pin';
  static const CHANGE_PIN = '/api/wallet/change-pin';
  static const LOGIN = '/api/user/login';
  static const SINGLE_DEVICE_LOGIN_OTP = '/api/auth/single-device-login-otp';
  static const VERIFY_SINGLE_DEVICE_LOGIN_OTP = '/api/auth/verify-single-device-login-otp';
  static const LOGOUT = '/api/user/logout';

  static const GET_USER = '/api/user/get-user';
  static const GET_RENT = '/api/rent/get-rent';
  static const CREATE_RENT = '/api/rent/create-rent';
  static const GET_ACTIVITIES = '/api/user/userActivities';
  static const OTP = '/api/auth/password/verify';
  static const RESENDOTP = '/api/user/resend-verification-otp';
  static const FORGOTPASSWORD = '/api/auth/password/forgot-password';
  static const RESEND_PASSWORD_OTP = '/api/user/resend-password-otp';
  static const UPDATE_PHOTO = '/api/user/update-profile';
  static const RESET_PASSWORD = '/api/auth/password/reset-password';
  static const REPORT_AN_ISSUE = '/api/report/report-issue';

  static const VERIFY_CODE = '/api/auth/verify';
  static const GET_ANNOUNCEMENT = '/api/auth/announcements';
  static const CREATE_PAYMENT = '/api/watu/create-payment';
  static const FUND_RENT_WITH_WALLET = '/api/rent/fund-rentWithWallet';
  static const CALCULATE_NEXT_PAYMENT_DATE = '/api/rent/calc-nextPaymentDate';
  static const VERFIY_ACCOUNT_DETAILS = '/api/banks/verfiy-account';
  static const WALLET_WITHDRAWAL = '/api/wallet/wallet-withdrawal';
  static const GET_BANKS_LIST = '/api/banks/bank-lists';
  static const VERFIY_BVN = '/api/bvn/verify-bvn';
  // static const BVN_DEBIT = '/api/bvn/bvn-debit';
  static const CREATE_DVA = '/api/dva/create-dva';

  static const BUY_AIRTIME = '/api/buy-airtime';
  static const BUY_DATA = '/api/buy-data';
  static const BUY_ELECTRICITY = '/api/buy-electricity';
  static const GET_AIRTIMES = '/api/get-airtimes';
  static const GET_DATA_VARIATION_CODES = '/api/variation-codes';
  static const GET_TV = '/api/get-tv';
  static const VERIFY_METER = '/api/verify-meter';
  static const VERIFY_TV = '/api/validate-tv';
  static const VEND_TV = '/api/vend-tv';
  static const ADD_UTILITY_HISTORY = '/api/utilities/add-utility';
  static const UTILITY_HISTORY = '/api/utilities/utility-history';
  static const WALLET_HISTORY = '/api/wallet/wallet-histories';
  static const RECENT_TRANSFERS = '/api/wallet/user-recent-transfers';

  static const TOKEN = '';
  static const FCM_TOKEN = '/api/user/postToken';
  static const PROFILE_PICTURE = '';
}
