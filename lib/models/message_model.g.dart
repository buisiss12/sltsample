// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      senderUID: json['senderUID'] as String,
      receiverUID: json['receiverUID'] as String,
      text: json['text'] as String,
      userUIDs: json['userUIDs'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'senderUID': instance.senderUID,
      'receiverUID': instance.receiverUID,
      'text': instance.text,
      'userUIDs': instance.userUIDs,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
