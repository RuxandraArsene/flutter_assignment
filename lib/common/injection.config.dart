// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/use_case/get_art_collection_use_case.dart' as _i891;
import '../data/repository/collection_repository.dart' as _i460;
import '../data/source/rijksmuseum_api/collection_api_source.dart' as _i572;
import '../data/source/rijksmuseum_api/mapper/collection_mapper.dart' as _i512;
import '../data/source/rijksmuseum_api/rijksmuseum_api_client.dart' as _i931;
import '../view/cubit/collection/collection_cubit.dart' as _i693;
import 'dio_register_module.dart' as _i531;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final dioRegisterModule = _$DioRegisterModule();
  gh.factory<_i361.Dio>(() => dioRegisterModule.dio);
  gh.factory<_i512.CollectionMapper>(() => _i512.CollectionMapper());
  gh.factory<_i931.Client>(() => _i931.Client.new(gh<_i361.Dio>()));
  gh.factory<_i572.CollectionApiSource>(
    () => _i572.CollectionApiSource(
      gh<_i931.Client>(),
      gh<_i512.CollectionMapper>(),
    ),
  );
  gh.factory<_i460.CollectionRepository>(
    () => _i460.CollectionRepository(gh<_i572.CollectionApiSource>()),
  );
  gh.factory<_i891.GetArtCollectionUseCase>(
    () => _i891.GetArtCollectionUseCase(gh<_i460.CollectionRepository>()),
  );
  gh.factory<_i693.CollectionCubit>(
    () => _i693.CollectionCubit(gh<_i891.GetArtCollectionUseCase>()),
  );
  return getIt;
}

class _$DioRegisterModule extends _i531.DioRegisterModule {}
