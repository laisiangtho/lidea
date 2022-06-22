part of 'main.dart';

@immutable
class UserType {
  final String identify;
  final String name;
  final List<String> email;
  final List<String> mobile;
  final List<String> phone;

  UserType({
    required this.identify,
    required this.name,
    required this.email,
    this.mobile = const [],
    this.phone = const [],
  });

  UserType.fromJSON(Map<String, Object?> o)
      : this(
          identify: (o['identify'] ?? '') as String,
          name: (o['name'] ?? '') as String,
          email: (o['email']! as List).cast<String>(),
          mobile: (o['mobile']! as List).cast<String>(),
          phone: (o['phone']! as List).cast<String>(),
        );

  Map<String, Object?> toJSON() {
    return {
      'identify': identify,
      'name': name,
      'email': email,
      'mobile': mobile,
      'phone': phone,
    };
  }
}
