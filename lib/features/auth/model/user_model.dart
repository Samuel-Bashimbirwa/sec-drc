class UserModel {
  final String id;        // device/local id
  final String alias;     // nom/alias affiché
  final String role;      // acteur | superviseur
  final String title;     // titre affiché (ex: "Acteur terrain")

  UserModel({
    required this.id,
    required this.alias,
    required this.role,
    required this.title,
  });
}
