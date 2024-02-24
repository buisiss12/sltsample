// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      postId: json['postId'] as String,
      postedUserUid: json['postedUserUid'] as String,
      postTitle: json['postTitle'] as String,
      prefecture: (json['prefecture'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'postedUserUid': instance.postedUserUid,
      'postTitle': instance.postTitle,
      'prefecture': instance.prefecture,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
