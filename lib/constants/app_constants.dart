// ignore_for_file: constant_identifier_names

class AppConstants {
  static const BASE_URL = 'https://rs-b-production.up.railway.app';
  static const SIGN_UP = '/api/user/create';
    static const GET_WALLET = '/api/wallet/get-wallet';
  static const CREATE_PIN = '/api/wallet/create-pin';
  static const FORGOT_PIN = '/api/wallet/reset-pin';
    static const RESEND_PIN_OTP = '/api/user/resend-password-otp';
  static const CHANGE_PIN = '/api/wallet/change-pin';
  static const LOGIN = '/api/user/login';
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
  static const VERFIY_ACCOUNT_DETAILS = '/api/banks/verfiy-account';
  static const WALLET_WITHDRAWAL = '/api/wallet/wallet-withdrawal';
  static const GET_BANKS_LIST = '/api/banks/bank-lists';
  static const VERFIY_BVN = '/api/bvn/verify-bvn';
  static const BVN_DEBIT = '/api/bvn/bvn-debit';
  static const CREATE_DVA = '/api/dva/create-dva';

  static const TOKEN = '';
  static const PROFILE_PICTURE = '';
}
