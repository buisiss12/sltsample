// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get senderUID => throw _privateConstructorUsedError;
  String get receiverUID => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get userUIDs => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String senderUID,
      String receiverUID,
      String text,
      String userUIDs,
      DateTime? timestamp});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderUID = null,
    Object? receiverUID = null,
    Object? text = null,
    Object? userUIDs = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      receiverUID: null == receiverUID
          ? _value.receiverUID
          : receiverUID // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userUIDs: null == userUIDs
          ? _value.userUIDs
          : userUIDs // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String senderUID,
      String receiverUID,
      String text,
      String userUIDs,
      DateTime? timestamp});
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderUID = null,
    Object? receiverUID = null,
    Object? text = null,
    Object? userUIDs = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$MessageModelImpl(
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      receiverUID: null == receiverUID
          ? _value.receiverUID
          : receiverUID // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userUIDs: null == userUIDs
          ? _value.userUIDs
          : userUIDs // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl with DiagnosticableTreeMixin implements _MessageModel {
  const _$MessageModelImpl(
      {required this.senderUID,
      required this.receiverUID,
      required this.text,
      required this.userUIDs,
      this.timestamp});

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String senderUID;
  @override
  final String receiverUID;
  @override
  final String text;
  @override
  final String userUIDs;
  @override
  final DateTime? timestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MessageModel(senderUID: $senderUID, receiverUID: $receiverUID, text: $text, userUIDs: $userUIDs, timestamp: $timestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MessageModel'))
      ..add(DiagnosticsProperty('senderUID', senderUID))
      ..add(DiagnosticsProperty('receiverUID', receiverUID))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('userUIDs', userUIDs))
      ..add(DiagnosticsProperty('timestamp', timestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.senderUID, senderUID) ||
                other.senderUID == senderUID) &&
            (identical(other.receiverUID, receiverUID) ||
                other.receiverUID == receiverUID) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.userUIDs, userUIDs) ||
                other.userUIDs == userUIDs) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, senderUID, receiverUID, text, userUIDs, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
      {required final String senderUID,
      required final String receiverUID,
      required final String text,
      required final String userUIDs,
      final DateTime? timestamp}) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get senderUID;
  @override
  String get receiverUID;
  @override
  String get text;
  @override
  String get userUIDs;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
