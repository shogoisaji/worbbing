// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$detailPageViewModelHash() =>
    r'bc350c6af8b438d28be52895ea4e202c78a5477e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DetailPageViewModel
    extends BuildlessAutoDisposeNotifier<DetailPageState> {
  late final WordModel initialWordModel;

  DetailPageState build(
    WordModel initialWordModel,
  );
}

/// See also [DetailPageViewModel].
@ProviderFor(DetailPageViewModel)
const detailPageViewModelProvider = DetailPageViewModelFamily();

/// See also [DetailPageViewModel].
class DetailPageViewModelFamily extends Family<DetailPageState> {
  /// See also [DetailPageViewModel].
  const DetailPageViewModelFamily();

  /// See also [DetailPageViewModel].
  DetailPageViewModelProvider call(
    WordModel initialWordModel,
  ) {
    return DetailPageViewModelProvider(
      initialWordModel,
    );
  }

  @override
  DetailPageViewModelProvider getProviderOverride(
    covariant DetailPageViewModelProvider provider,
  ) {
    return call(
      provider.initialWordModel,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'detailPageViewModelProvider';
}

/// See also [DetailPageViewModel].
class DetailPageViewModelProvider extends AutoDisposeNotifierProviderImpl<
    DetailPageViewModel, DetailPageState> {
  /// See also [DetailPageViewModel].
  DetailPageViewModelProvider(
    WordModel initialWordModel,
  ) : this._internal(
          () => DetailPageViewModel()..initialWordModel = initialWordModel,
          from: detailPageViewModelProvider,
          name: r'detailPageViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$detailPageViewModelHash,
          dependencies: DetailPageViewModelFamily._dependencies,
          allTransitiveDependencies:
              DetailPageViewModelFamily._allTransitiveDependencies,
          initialWordModel: initialWordModel,
        );

  DetailPageViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialWordModel,
  }) : super.internal();

  final WordModel initialWordModel;

  @override
  DetailPageState runNotifierBuild(
    covariant DetailPageViewModel notifier,
  ) {
    return notifier.build(
      initialWordModel,
    );
  }

  @override
  Override overrideWith(DetailPageViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: DetailPageViewModelProvider._internal(
        () => create()..initialWordModel = initialWordModel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialWordModel: initialWordModel,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DetailPageViewModel, DetailPageState>
      createElement() {
    return _DetailPageViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailPageViewModelProvider &&
        other.initialWordModel == initialWordModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialWordModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DetailPageViewModelRef
    on AutoDisposeNotifierProviderRef<DetailPageState> {
  /// The parameter `initialWordModel` of this provider.
  WordModel get initialWordModel;
}

class _DetailPageViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<DetailPageViewModel,
        DetailPageState> with DetailPageViewModelRef {
  _DetailPageViewModelProviderElement(super.provider);

  @override
  WordModel get initialWordModel =>
      (origin as DetailPageViewModelProvider).initialWordModel;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
