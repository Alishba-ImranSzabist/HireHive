

// Global user object


class UserModel {
  String role;   // "freelancer" ya "client"
  String name;
  String email;
  String skills;   // for freelancer
  String company;  // for client
  String phone;
  String bio;

  UserModel({
    required this.role,
    this.name = "",
    this.email = "",
    this.skills = "",
    this.company = "",
    this.phone = "",
    this.bio = "",
  });
}

// Global object  this will use in the whole  app
UserModel currentUser = UserModel(role: "freelancer");
