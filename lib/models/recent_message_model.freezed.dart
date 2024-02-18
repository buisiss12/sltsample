// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecentMessageModel _$RecentMessageModelFromJson(Map<String, dynamic> json) {
  return _RecentMessageModel.fromJson(json);
}

/// @nodoc
mixin _$RecentMessageModel {
  List<String> get userUid => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageTimestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentMessageModelCopyWith<RecentMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentMessageModelCopyWith<$Res> {
  factory $RecentMessageModelCopyWith(
          RecentMessageModel value, $Res Function(RecentMessageModel) then) =
      _$RecentMessageModelCopyWithImpl<$Res, RecentMessageModel>;
  @useResult
  $Res call(
      {List<String> userUid,
      String lastMessage,
      DateTime? lastMessageTimestamp});
}

/// @nodoc
class _$RecentMessageModelCopyWithImpl<$Res, $Val extends RecentMessageModel>
    implements $RecentMessageModelCopyWith<$Res> {
  _$RecentMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userUid = null,
    Object? lastMessage = null,
    Object? lastMessageTimestamp = freezed,
  }) {
    return _then(_value.copyWith(
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageTimestamp: freezed == lastMessageTimestamp
          ? _value.lastMessageTimestamp
          : lastMessageTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentMessageModelImplCopyWith<$Res>
    implements $RecentMessageModelCopyWith<$Res> {
  factory _$$RecentMessageModelImplCopyWith(_$RecentMessageModelImpl value,
          $Res Function(_$RecentMessageModelImpl) then) =
      __$$RecentMessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> userUid,
      String lastMessage,
      DateTime? lastMessageTimestamp});
}

/// @nodoc
class __$$RecentMessageModelImplCopyWithImpl<$Res>
    extends _$RecentMessageModelCopyWithImpl<$Res, _$RecentMessageModelImpl>
    implements _$$RecentMessageModelImplCopyWith<$Res> {
  __$$RecentMessageModelImplCopyWithImpl(_$RecentMessageModelImpl _value,
      $Res Function(_$RecentMessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userUid = null,
    Object? lastMessage = null,
    Object? lastMessageTimestamp = freezed,
  }) {
    return _then(_$RecentMessageModelImpl(
      userUid: null == userUid
          ? _value._userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageTimestamp: freezed == lastMessageTimestamp
          ? _value.lastMessageTimestamp
          : lastMessageTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentMessageModelImpl
    with DiagnosticableTreeMixin
    implements _RecentMessageModel {
  const _$RecentMessageModelImpl(
      {required final List<String> userUid,
      required this.lastMessage,
      this.lastMessageTimestamp})
      : _userUid = userUid;

  factory _$RecentMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentMessageModelImplFromJson(json);

  final List<String> _userUid;
  @override
  List<String> get userUid {
    if (_userUid is EqualUnmodifiableListView) return _userUid;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userUid);
  }

  @override
  final String lastMessage;
  @override
  final DateTime? lastMessageTimestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RecentMessageModel(userUid: $userUid, lastMessage: $lastMessage, lastMessageTimestamp: $lastMessageTimestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RecentMessageModel'))
      ..add(DiagnosticsProperty('userUid', userUid))
      ..add(DiagnosticsProperty('lastMessage', lastMessage))
      ..add(DiagnosticsProperty('lastMessageTimestamp', lastMessageTimestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentMessageModelImpl &&
            const DeepCollectionEquality().equals(other._userUid, _userUid) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTimestamp, lastMessageTimestamp) ||
                other.lastMessageTimestamp == lastMessageTimestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_userUid),
      lastMessage,
      lastMessageTimestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentMessageModelImplCopyWith<_$RecentMessageModelImpl> get copyWith =>
      __$$RecentMessageModelImplCopyWithImpl<_$RecentMessageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentMessageModelImplToJson(
      this,
    );
  }
}

abstract class _RecentMessageModel implements RecentMessageModel {
  const factory _RecentMessageModel(
      {required final List<String> userUid,
      required final String lastMessage,
      final DateTime? lastMessageTimestamp}) = _$RecentMessageModelImpl;

  factory _RecentMessageModel.fromJson(Map<String, dynamic> json) =
      _$RecentMessageModelImpl.fromJson;

  @override
  List<String> get userUid;
  @override
  String get lastMessage;
  @override
  DateTime? get lastMessageTimestamp;
  @override
  @JsonKey(ignore: true)
  _$$RecentMessageModelImplCopyWith<_$RecentMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
