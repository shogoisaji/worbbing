// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_manage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoticeManageModel _$NoticeManageModelFromJson(Map<String, dynamic> json) {
  return _NoticeManageModel.fromJson(json);
}

/// @nodoc
mixin _$NoticeManageModel {
// ignore: invalid_annotation_target
  @JsonKey(name: 'notice_enable')
  bool get noticeEnable =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'notice_list')
  List<NoticeDataModel> get noticeList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoticeManageModelCopyWith<NoticeManageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeManageModelCopyWith<$Res> {
  factory $NoticeManageModelCopyWith(
          NoticeManageModel value, $Res Function(NoticeManageModel) then) =
      _$NoticeManageModelCopyWithImpl<$Res, NoticeManageModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'notice_enable') bool noticeEnable,
      @JsonKey(name: 'notice_list') List<NoticeDataModel> noticeList});
}

/// @nodoc
class _$NoticeManageModelCopyWithImpl<$Res, $Val extends NoticeManageModel>
    implements $NoticeManageModelCopyWith<$Res> {
  _$NoticeManageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeEnable = null,
    Object? noticeList = null,
  }) {
    return _then(_value.copyWith(
      noticeEnable: null == noticeEnable
          ? _value.noticeEnable
          : noticeEnable // ignore: cast_nullable_to_non_nullable
              as bool,
      noticeList: null == noticeList
          ? _value.noticeList
          : noticeList // ignore: cast_nullable_to_non_nullable
              as List<NoticeDataModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoticeManageModelImplCopyWith<$Res>
    implements $NoticeManageModelCopyWith<$Res> {
  factory _$$NoticeManageModelImplCopyWith(_$NoticeManageModelImpl value,
          $Res Function(_$NoticeManageModelImpl) then) =
      __$$NoticeManageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'notice_enable') bool noticeEnable,
      @JsonKey(name: 'notice_list') List<NoticeDataModel> noticeList});
}

/// @nodoc
class __$$NoticeManageModelImplCopyWithImpl<$Res>
    extends _$NoticeManageModelCopyWithImpl<$Res, _$NoticeManageModelImpl>
    implements _$$NoticeManageModelImplCopyWith<$Res> {
  __$$NoticeManageModelImplCopyWithImpl(_$NoticeManageModelImpl _value,
      $Res Function(_$NoticeManageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeEnable = null,
    Object? noticeList = null,
  }) {
    return _then(_$NoticeManageModelImpl(
      noticeEnable: null == noticeEnable
          ? _value.noticeEnable
          : noticeEnable // ignore: cast_nullable_to_non_nullable
              as bool,
      noticeList: null == noticeList
          ? _value._noticeList
          : noticeList // ignore: cast_nullable_to_non_nullable
              as List<NoticeDataModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoticeManageModelImpl implements _NoticeManageModel {
  const _$NoticeManageModelImpl(
      {@JsonKey(name: 'notice_enable') this.noticeEnable = false,
      @JsonKey(name: 'notice_list')
      final List<NoticeDataModel> noticeList = const []})
      : _noticeList = noticeList;

  factory _$NoticeManageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeManageModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'notice_enable')
  final bool noticeEnable;
// ignore: invalid_annotation_target
  final List<NoticeDataModel> _noticeList;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'notice_list')
  List<NoticeDataModel> get noticeList {
    if (_noticeList is EqualUnmodifiableListView) return _noticeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_noticeList);
  }

  @override
  String toString() {
    return 'NoticeManageModel(noticeEnable: $noticeEnable, noticeList: $noticeList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeManageModelImpl &&
            (identical(other.noticeEnable, noticeEnable) ||
                other.noticeEnable == noticeEnable) &&
            const DeepCollectionEquality()
                .equals(other._noticeList, _noticeList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, noticeEnable,
      const DeepCollectionEquality().hash(_noticeList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeManageModelImplCopyWith<_$NoticeManageModelImpl> get copyWith =>
      __$$NoticeManageModelImplCopyWithImpl<_$NoticeManageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeManageModelImplToJson(
      this,
    );
  }
}

abstract class _NoticeManageModel implements NoticeManageModel {
  const factory _NoticeManageModel(
      {@JsonKey(name: 'notice_enable') final bool noticeEnable,
      @JsonKey(name: 'notice_list')
      final List<NoticeDataModel> noticeList}) = _$NoticeManageModelImpl;

  factory _NoticeManageModel.fromJson(Map<String, dynamic> json) =
      _$NoticeManageModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'notice_enable')
  bool get noticeEnable;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'notice_list')
  List<NoticeDataModel> get noticeList;
  @override
  @JsonKey(ignore: true)
  _$$NoticeManageModelImplCopyWith<_$NoticeManageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
