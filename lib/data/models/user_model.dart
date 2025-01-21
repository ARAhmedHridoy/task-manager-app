class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  String get fullName {
    return '$firstName $lastName';
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    mobile = json['mobile'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'lastName': lastName,
      'firstName': firstName,
      'mobile': mobile,
      'photo': photo,
    };
  }
}
