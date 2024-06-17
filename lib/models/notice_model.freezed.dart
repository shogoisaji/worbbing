// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) {
  return _NoticeModel.fromJson(json);
}

/// @nodoc
mixin _$NoticeModel {
  bool get noticeEnable => throw _privateConstructorUsedError;
  int get selectedWordCount => throw _privateConstructorUsedError;
  bool get time1Enable => throw _privateConstructorUsedError;
  bool get time2Enable => throw _privateConstructorUsedError;
  bool get time3Enable => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get selectedTime1 => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get selectedTime2 => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get selectedTime3 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoticeModelCopyWith<NoticeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeModelCopyWith<$Res> {
  factory $NoticeModelCopyWith(
          NoticeModel value, $Res Function(NoticeModel) then) =
      _$NoticeModelCopyWithImpl<$Res, NoticeModel>;
  @useResult
  $Res call(
      {bool noticeEnable,
      int selectedWordCount,
      bool time1Enable,
      bool time2Enable,
      bool time3Enable,
      @TimeOfDayConverter() TimeOfDay selectedTime1,
      @TimeOfDayConverter() TimeOfDay selectedTime2,
      @TimeOfDayConverter() TimeOfDay selectedTime3});
}

/// @nodoc
class _$NoticeModelCopyWithImpl<$Res, $Val extends NoticeModel>
    implements $NoticeModelCopyWith<$Res> {
  _$NoticeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeEnable = null,
    Object? selectedWordCount = null,
    Object? time1Enable = null,
    Object? time2Enable = null,
    Object? time3Enable = null,
    Object? selectedTime1 = null,
    Object? selectedTime2 = null,
    Object? selectedTime3 = null,
  }) {
    return _then(_value.copyWith(
      noticeEnable: null == noticeEnable
          ? _value.noticeEnable
          : noticeEnable // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedWordCount: null == selectedWordCount
          ? _value.selectedWordCount
          : selectedWordCount // ignore: cast_nullable_to_non_nullable
              as int,
      time1Enable: null == time1Enable
          ? _value.time1Enable
          : time1Enable // ignore: cast_nullable_to_non_nullable
              as bool,
      time2Enable: null == time2Enable
          ? _value.time2Enable
          : time2Enable // ignore: cast_nullable_to_non_nullable
              as bool,
      time3Enable: null == time3Enable
          ? _value.time3Enable
          : time3Enable // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTime1: null == selectedTime1
          ? _value.selectedTime1
          : selectedTime1 // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      selectedTime2: null == selectedTime2
          ? _value.selectedTime2
          : selectedTime2 // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      selectedTime3: null == selectedTime3
          ? _value.selectedTime3
          : selectedTime3 // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoticeModelImplCopyWith<$Res>
    implements $NoticeModelCopyWith<$Res> {
  factory _$$NoticeModelImplCopyWith(
          _$NoticeModelImpl value, $Res Function(_$NoticeModelImpl) then) =
      __$$NoticeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool noticeEnable,
      int selectedWordCount,
      bool time1Enable,
      bool time2Enable,
      bool time3Enable,
      @TimeOfDayConverter() TimeOfDay selectedTime1,
      @TimeOfDayConverter() TimeOfDay selectedTime2,
      @TimeOfDayConverter() TimeOfDay selectedTime3});
}

/// @nodoc
class __$$NoticeModelImplCopyWithImpl<$Res>
    extends _$NoticeModelCopyWithImpl<$Res, _$NoticeModelImpl>
    implements _$$NoticeModelImplCopyWith<$Res> {
  __$$NoticeModelImplCopyWithImpl(
      _$NoticeModelImpl _value, $Res Function(_$NoticeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeEnable = null,
    Object? selectedWordCount = null,
    Object? time1Enable = null,
    Object? time2Enable = null,
    Object? time3Enable = null,
    Object? selectedTime1 = null,
    Object? selectedTime2 = null,
    Object? selectedTime3 = null,
  }) {
    return _then(_$NoticeModelImpl(
      noticeEnable: null == noticeEnable
          ? _value.noticeEnable
          : noticeEnable // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedWordCount: null == selectedWordCount
          ? _value.selectedWordCount
          : selectedWordCount // ignore: cast_nullable_to_non_nullable
              as int,
      time1Enable: null == time1Enable
          ? _value.time1Enable
          : time1Enable // ignore: cast_nullable_to_non_nullable
              as bool,
      time2Enable: null == time2Enable
          ? _value.time2Enable
          : time2Enable // ignore: cast_nullable_to_non_nullable
              as bool,
      time3Enable: null == time3Enable
          ? _value.time3Enable
          : time3Enable // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTime1: null == selectedTime1
          ? _value.selectedTime1
          : selectedTime1 // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      selectedTime2: null == selectedTime2
          ? _value.selectedTime2
          : selectedTime2 // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      selectedTime3: null == selectedTime3
          ? _value.selectedTime3
          : selectedTime3 // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoticeModelImpl implements _NoticeModel {
  const _$NoticeModelImpl(
      {this.noticeEnable = false,
      this.selectedWordCount = 1,
      this.time1Enable = false,
      this.time2Enable = false,
      this.time3Enable = false,
      @TimeOfDayConverter()
      this.selectedTime1 = const TimeOfDay(hour: 0, minute: 0),
      @TimeOfDayConverter()
      this.selectedTime2 = const TimeOfDay(hour: 0, minute: 0),
      @TimeOfDayConverter()
      this.selectedTime3 = const TimeOfDay(hour: 0, minute: 0)});

  factory _$NoticeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeModelImplFromJson(json);

  @override
  @JsonKey()
  final bool noticeEnable;
  @override
  @JsonKey()
  final int selectedWordCount;
  @override
  @JsonKey()
  final bool time1Enable;
  @override
  @JsonKey()
  final bool time2Enable;
  @override
  @JsonKey()
  final bool time3Enable;
  @override
  @JsonKey()
  @TimeOfDayConverter()
  final TimeOfDay selectedTime1;
  @override
  @JsonKey()
  @TimeOfDayConverter()
  final TimeOfDay selectedTime2;
  @override
  @JsonKey()
  @TimeOfDayConverter()
  final TimeOfDay selectedTime3;

  @override
  String toString() {
    return 'NoticeModel(noticeEnable: $noticeEnable, selectedWordCount: $selectedWordCount, time1Enable: $time1Enable, time2Enable: $time2Enable, time3Enable: $time3Enable, selectedTime1: $selectedTime1, selectedTime2: $selectedTime2, selectedTime3: $selectedTime3)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeModelImpl &&
            (identical(other.noticeEnable, noticeEnable) ||
                other.noticeEnable == noticeEnable) &&
            (identical(other.selectedWordCount, selectedWordCount) ||
                other.selectedWordCount == selectedWordCount) &&
            (identical(other.time1Enable, time1Enable) ||
                other.time1Enable == time1Enable) &&
            (identical(other.time2Enable, time2Enable) ||
                other.time2Enable == time2Enable) &&
            (identical(other.time3Enable, time3Enable) ||
                other.time3Enable == time3Enable) &&
            (identical(other.selectedTime1, selectedTime1) ||
                other.selectedTime1 == selectedTime1) &&
            (identical(other.selectedTime2, selectedTime2) ||
                other.selectedTime2 == selectedTime2) &&
            (identical(other.selectedTime3, selectedTime3) ||
                other.selectedTime3 == selectedTime3));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      noticeEnable,
      selectedWordCount,
      time1Enable,
      time2Enable,
      time3Enable,
      selectedTime1,
      selectedTime2,
      selectedTime3);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeModelImplCopyWith<_$NoticeModelImpl> get copyWith =>
      __$$NoticeModelImplCopyWithImpl<_$NoticeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeModelImplToJson(
      this,
    );
  }
}

abstract class _NoticeModel implements NoticeModel {
  const factory _NoticeModel(
      {final bool noticeEnable,
      final int selectedWordCount,
      final bool time1Enable,
      final bool time2Enable,
      final bool time3Enable,
      @TimeOfDayConverter() final TimeOfDay selectedTime1,
      @TimeOfDayConverter() final TimeOfDay selectedTime2,
      @TimeOfDayConverter() final TimeOfDay selectedTime3}) = _$NoticeModelImpl;

  factory _NoticeModel.fromJson(Map<String, dynamic> json) =
      _$NoticeModelImpl.fromJson;

  @override
  bool get noticeEnable;
  @override
  int get selectedWordCount;
  @override
  bool get time1Enable;
  @override
  bool get time2Enable;
  @override
  bool get time3Enable;
  @override
  @TimeOfDayConverter()
  TimeOfDay get selectedTime1;
  @override
  @TimeOfDayConverter()
  TimeOfDay get selectedTime2;
  @override
  @TimeOfDayConverter()
  TimeOfDay get selectedTime3;
  @override
  @JsonKey(ignore: true)
  _$$NoticeModelImplCopyWith<_$NoticeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
