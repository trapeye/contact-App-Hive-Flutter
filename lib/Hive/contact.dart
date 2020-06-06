import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String picture;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String telephone;

  Contact(
      {this.firstName,
      this.lastName,
      this.picture,
      this.email,
      this.telephone});
}
