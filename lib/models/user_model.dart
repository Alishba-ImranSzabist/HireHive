class UserModel {
  int? id;
  String role;
  String name;
  String email;
  String skills;
  String company;
  String phone;
  String bio;

  UserModel({
    this.id,
    required this.role,
    this.name = "",
    this.email = "",
    this.skills = "",
    this.company = "",
    this.phone = "",
    this.bio = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      role: json['role'] ?? 'freelancer',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      skills: json['skills'] ?? '',
      company: json['company'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}
