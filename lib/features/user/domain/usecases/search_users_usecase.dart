import 'package:equatable/equatable.dart';
import 'package:warshasy/features/auth/auth.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SearchUsersUseCase implements UseCase<List<User>, SearchUsersParams> {
  final UserRepository repository;

  SearchUsersUseCase(this.repository);

  @override
  Future<List<User>> call(SearchUsersParams params) async {
    return await repository.searchUsers(
      query: params.query,
      city: params.city,
      limit: params.limit,
    );
  }
}

class SearchUsersParams extends Equatable {
  final String? query;
  final City? city;
  final int? limit;

  const SearchUsersParams({this.query, this.city, this.limit});

  @override
  List<Object?> get props => [query, city, limit];
}
