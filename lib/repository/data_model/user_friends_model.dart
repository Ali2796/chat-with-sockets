class UserFriendsModel {
  int? id;
  String? password;
  dynamic lastLogin;
  bool? isSuperuser;
  String? firstName;
  String? lastName;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? fullName;
  String? email;
  String? phone;
  dynamic img;
  String? chatName;
  String? notificationId;
  String? status;
  String? lastSeen;
  List<dynamic>? groups;
  List<dynamic>? userPermissions;
  List<int>? friends;

  UserFriendsModel(
      {this.id,
      this.password,
      this.lastLogin,
      this.isSuperuser,
      this.firstName,
      this.lastName,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.fullName,
      this.email,
      this.phone,
      this.img,
      this.chatName,
      this.notificationId,
      this.status,
      this.lastSeen,
      this.groups,
      this.userPermissions,
      this.friends});

  UserFriendsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    img = json['img'];
    chatName = json['chat_name'];
    notificationId = json['notification_id'];
    status = json['status'];
    lastSeen = json['last_seen'];
    friends = json['friends'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['img'] = this.img;
    data['chat_name'] = this.chatName;
    data['notification_id'] = this.notificationId;
    data['status'] = this.status;
    data['last_seen'] = this.lastSeen;

    return data;
  }
}
