import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject{
  Data({required this.firstName ,required this.lastName,required this.gender,required this.mobile ,required this.address,
  required this.fileUrl,required this.imageUrl});
  @HiveField(0)
  late String firstName;
  @HiveField(1)
  late String lastName;
  @HiveField(2)
  late String gender;
  @HiveField(3)
  late String mobile;
  @HiveField(4)
  late String address;
  @HiveField(5)
  late String imageUrl;
  @HiveField(6)
  late String fileUrl;
}