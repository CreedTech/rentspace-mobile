import 'package:hive/hive.dart';

part 'loan_form_model.g.dart';

@HiveType(typeId: 0)
class LoanFormData extends HiveObject {
  @HiveField(0)
  String? reason;

  @HiveField(1)
  String? id;

  @HiveField(2)
  String? idNumber;

  @HiveField(3)
  String? bvn;

  @HiveField(4)
  String? phoneNumber;

  @HiveField(5)
  String? houseAddress;

  @HiveField(6)
  String? bill;

  @HiveField(7)
  String? landlordOrAgent;

  @HiveField(8)
  String? landlordOrAgentName;

  @HiveField(9)
  String? sameProperty;

  @HiveField(10)
  String? landlordOrAgentAddress;

  @HiveField(11)
  String? landlordOrAgentNumber;

  @HiveField(12)
  String? howLong;

  @HiveField(13)
  String? propertyType;

}
