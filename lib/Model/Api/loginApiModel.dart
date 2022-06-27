class LoginApiModel {
  var success;
  var message;
  var user_type;
  var token;
  var sales_person;
  LoginApiModel(
      {this.success,
      this.message,
      this.user_type,
      this.token,
      this.sales_person});
  factory LoginApiModel.fromJson(Map<dynamic, dynamic> json) {
    return LoginApiModel(
        success: json['success'],
        message: json['message'],
        user_type: json['user_type'],
        token: json['token'],
        sales_person: json['sales_person']);
  }
}
