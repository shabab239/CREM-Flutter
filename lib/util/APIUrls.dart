class APIUrls {
  static const String baseURL = 'http://localhost/api';

  static Uri get login => Uri.parse('$baseURL/auth/login');
  static Uri get company => Uri.parse('$baseURL/company');
  static Uri get user => Uri.parse('$baseURL/user');

  static Uri get dashboard => Uri.parse('$baseURL/admin/dashboard');
  static Uri get project => Uri.parse('$baseURL/project');
  static Uri get stage => Uri.parse('$baseURL/stage');
  static Uri get worker => Uri.parse('$baseURL/worker');
  static Uri get task => Uri.parse('$baseURL/task');
  static Uri get rawMaterial => Uri.parse('$baseURL/rawMaterial');
  static Uri get supplier => Uri.parse('$baseURL/supplier');
  static Uri get booking => Uri.parse('$baseURL/booking');
  static Uri get payment => Uri.parse('$baseURL/payment');
  static Uri get account => Uri.parse('$baseURL/account');
  static Uri get transaction => Uri.parse('$baseURL/transaction');
  static Uri get ledger => Uri.parse('$baseURL/ledger');
}
