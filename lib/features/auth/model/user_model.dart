class UserModel {
  final String id;
  final String email;
  final String role; // USER | SUPERVISOR | ADMIN
  final String? firstName;
  final String? lastName;
  final String? addressReference;
  final DateTime? birthDate;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.addressReference,
    this.birthDate,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      addressReference: json['address_reference'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'address_reference': addressReference,
      'birth_date': birthDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
