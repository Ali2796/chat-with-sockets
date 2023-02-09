class UserResponseModel {
  String? token;
  int? userId;
  String? email;

  UserResponseModel({this.token, this.userId, this.email});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['user_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = this.token;
    data['user_id'] = this.userId;
    data['email'] = this.email;
    return data;
  }
}
