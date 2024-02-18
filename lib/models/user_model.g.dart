// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userUID: json['userUID'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      realName: json['realName'] as String,
      nickName: json['nickName'] as String,
      gender: json['gender'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userUID': instance.userUID,
      'profileImageUrl': instance.profileImageUrl,
      'realName': instance.realName,
      'nickName': instance.nickName,
      'gender': instance.gender,
      'birthday': instance.birthday.toIso8601String(),
    };
