// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      senderUID: json['senderUID'] as String,
      receiverUID: json['receiverUID'] as String,
      text: json['text'] as String,
      userUIDs: json['userUIDs'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'senderUID': instance.senderUID,
      'receiverUID': instance.receiverUID,
      'text': instance.text,
      'userUIDs': instance.userUIDs,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
