class JobModel {
  int? id;
  String title;
  String budget;
  String description;
  String postedBy;

  JobModel({
    this.id,
    required this.title,
    required this.budget,
    required this.description,
    required this.postedBy,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'] ?? '',
      budget: json['budget'].toString(),
      description: json['description'] ?? '',
      postedBy: json['posted_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'budget': budget,
      'description': description,
      'posted_by': postedBy,
    };
  }
}
