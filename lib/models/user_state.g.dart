// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStateImpl _$$UserStateImplFromJson(Map<String, dynamic> json) =>
    _$UserStateImpl(
      useruid: json['useruid'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      realname: json['realname'] as String,
      gender: json['gender'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$$UserStateImplToJson(_$UserStateImpl instance) =>
    <String, dynamic>{
      'useruid': instance.useruid,
      'profileImageUrl': instance.profileImageUrl,
      'realname': instance.realname,
      'gender': instance.gender,
      'birthday': instance.birthday.toIso8601String(),
    };
