part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDatabaseData extends DatabaseEvent {
  final bool forceRefresh;

  LoadDatabaseData({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class RefreshDatabaseData extends DatabaseEvent {}

class ClearDatabaseCache extends DatabaseEvent {}
