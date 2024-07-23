// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_form_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanFormDataAdapter extends TypeAdapter<LoanFormData> {
  @override
  final int typeId = 0;

  @override
  LoanFormData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoanFormData()
      ..reason = fields[0] as String?
      ..id = fields[1] as String?
      ..idNumber = fields[2] as String?
      ..bvn = fields[3] as String?
      ..phoneNumber = fields[4] as String?
      ..houseAddress = fields[5] as String?
      ..bill = fields[6] as String?
      ..landlordOrAgent = fields[7] as String?
      ..landlordOrAgentName = fields[8] as String?
      ..sameProperty = fields[9] as String?
      ..landlordOrAgentNumber = fields[10] as String?
      ..landlordAccountNumber = fields[11] as String?
      ..landlordBankName = fields[12] as String?
      ..howLong = fields[13] as String?
      ..propertyType = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, LoanFormData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.reason)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.idNumber)
      ..writeByte(3)
      ..write(obj.bvn)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.houseAddress)
      ..writeByte(6)
      ..write(obj.bill)
      ..writeByte(7)
      ..write(obj.landlordOrAgent)
      ..writeByte(8)
      ..write(obj.landlordOrAgentName)
      ..writeByte(9)
      ..write(obj.sameProperty)
      ..writeByte(10)
      ..write(obj.landlordOrAgentNumber)
      ..writeByte(11)
      ..write(obj.landlordAccountNumber)
      ..writeByte(12)
      ..write(obj.landlordBankName)
      ..writeByte(13)
      ..write(obj.howLong)
      ..writeByte(14)
      ..write(obj.propertyType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanFormDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
