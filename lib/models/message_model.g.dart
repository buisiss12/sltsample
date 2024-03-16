// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      senderUid: json['senderUid'] as String,
      receiverUid: json['receiverUid'] as String,
      text: json['text'] as String,
      userUid: json['userUid'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'senderUid': instance.senderUid,
      'receiverUid': instance.receiverUid,
      'text': instance.text,
      'userUid': instance.userUid,
      'timestamp': instance.timestamp.toIso8601String(),
    };
