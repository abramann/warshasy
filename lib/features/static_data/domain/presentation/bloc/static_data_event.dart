part of 'static_data_bloc.dart';

abstract class StaticDataEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStaticData extends StaticDataEvent {
  final bool forceRefresh;

  LoadStaticData({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class RefreshStaticData extends StaticDataEvent {}

class ClearStaticDataCache extends StaticDataEvent {}
