// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      useruid: json['useruid'] as String,
      posttitle: json['posttitle'] as String,
      todohuken:
          (json['todohuken'] as List<dynamic>).map((e) => e as String).toList(),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'useruid': instance.useruid,
      'posttitle': instance.posttitle,
      'todohuken': instance.todohuken,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
