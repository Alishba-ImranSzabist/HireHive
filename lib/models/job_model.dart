

// Dummy jobs list


class JobModel {
  String title;
  String budget;
  String description;
  String postedBy; // client name

  JobModel({
    required this.title,
    required this.budget,
    required this.description,
    required this.postedBy,
  });
}

// Global dummy jobs list — share the whole my app
List<JobModel> allJobs = [
  JobModel(
    title: "Flutter App Development",
    budget: "50000",
    description: "Build a full mobile app using Flutter with login, home screen, and profile.",
    postedBy: "Ali Enterprises",
  ),
  JobModel(
    title: "Website Design",
    budget: "30000",
    description: "Design a modern responsive website for our company.",
    postedBy: "Sara Ltd",
  ),
  JobModel(
    title: "Logo Design",
    budget: "10000",
    description: "Create a professional logo for our startup brand.",
    postedBy: "Ahmed Corp",
  ),
  JobModel(
    title: "UI/UX Design",
    budget: "25000",
    description: "Design user-friendly UI for our existing mobile app.",
    postedBy: "Zara Solutions",
  ),
];
