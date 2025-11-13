// ============================================
// STEP 8: DEPENDENCY INJECTION
// lib/injection_container.dart
// ============================================
// This sets up all dependencies so they can be used anywhere

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warshasy/core/network/network.dart';
import 'package:warshasy/core/storage/repository/local_storage_reposotory.dart';
import 'package:warshasy/core/storage/storage_service.dart';

// Import all auth files
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:warshasy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/data/datasources/user_remote_datasource.dart';
import 'package:warshasy/features/user/domain/repositories/user_repository.dart';
import 'package:warshasy/features/user/domain/repositories/user_repository_impl.dart';
import 'package:warshasy/features/user/domain/usecases/check_phone_exists_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/create_user_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/delete_avatar_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/get_user_by_phone_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/search_users_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/update_user_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/upload_avatar_usecase.dart';
import 'package:warshasy/features/user/presentation/blocs/user_bloc.dart';

// ============================================
// DEPENDENCY INJECTION - PRODUCTS MODULE
// lib/injection_container.dart
// ============================================
// Update your existing injection_container.dart file
// Add Products dependencies to the existing Auth dependencies

// Auth imports (existing)

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // CORE - External Dependencies
  // ============================================

  // SharedPreferences - must be initialized before app starts
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Storage Service - wraps SharedPreferences
  sl.registerLazySingleton<StorageService>(() => StorageService(sl()));

  // Local Storage Repository - high-level storage operations
  sl.registerLazySingleton<LocalStorageRepository>(
    () => LocalStorageRepository(sl()),
  );

  // Network info
  sl.registerSingleton<Network>(Network());
  // ============================================
  // EXTERNAL - SUPABASE (Existing - Keep as is)
  // ============================================
  sl.registerLazySingleton(() => Supabase.instance.client);

  _initAuthintication();
  _initUser();
}

void _initAuthintication() {
  // Use cases
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthinticationSessionUseCase(sl()));
  sl.registerLazySingleton(() => SendVerificationCodeUsecase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabase: sl()),
  );

  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(storageService: sl()),
  );

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signOutUseCase: sl(),
      getAuthenticationSessionUseCase: sl(),
      sendVerificationCodeUseCase: sl(),
    ),
  );
}

/// Initialize User feature dependencies
void _initUser() {
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByPhoneUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => UploadAvatarUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAvatarUseCase(sl()));
  sl.registerLazySingleton(() => SearchUsersUseCase(sl()));
  sl.registerLazySingleton(() => CheckPhoneExistsUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => UserBloc(
      getUserByIdUseCase: sl(),
      getUserByPhoneUseCase: sl(),
      updateUserUseCase: sl(),
      uploadAvatarUseCase: sl(),
      deleteAvatarUseCase: sl(),
      searchUsersUseCase: sl(),
      checkPhoneExistsUseCase: sl(),
    ),
  );
}

// ============================================
// EXPLANATION OF WHAT EACH REGISTRATION DOES
// ============================================

/*
═══════════════════════════════════════════════════════════════
🎓 DEPENDENCY INJECTION EXPLAINED
═══════════════════════════════════════════════════════════════

WHAT IS DEPENDENCY INJECTION?
Instead of creating objects manually:
  ❌ final bloc = ProductsBloc(
        getProductsUseCase: GetProductsUseCase(
          ProductsRepositoryImpl(
            ProductsRemoteDataSourceImpl(supabase)
          )
        ),
        // ... 10 more use cases!
      );

We register once, get anywhere:
  ✅ final bloc = sl<ProductsBloc>();

═══════════════════════════════════════════════════════════════
REGISTRATION TYPES:
═══════════════════════════════════════════════════════════════

1. registerFactory() - Creates NEW instance every time
   Use for: BLoCs (each page gets fresh BLoC)
   
   sl.registerFactory(() => ProductsBloc(...));
   
   // Each call creates new:
   final bloc1 = sl<ProductsBloc>(); // New instance
   final bloc2 = sl<ProductsBloc>(); // Another new instance

2. registerLazySingleton() - Creates ONE instance, reused everywhere
   Use for: Repositories, Use Cases, Data Sources
   
   sl.registerLazySingleton(() => GetProductsUseCase(sl()));
   
   // Same instance everywhere:
   final useCase1 = sl<GetProductsUseCase>(); // Creates instance
   final useCase2 = sl<GetProductsUseCase>(); // Returns same instance

3. registerSingleton() - Creates instance immediately
   Use for: Things that must exist at startup
   
   sl.registerSingleton(SupabaseClient(...));

═══════════════════════════════════════════════════════════════
HOW sl() WORKS:
═══════════════════════════════════════════════════════════════

sl() = Service Locator (finds the registered object)

Example:
sl.registerLazySingleton(() => GetProductsUseCase(sl()));
                                                    ↑
                                    This sl() gets ProductsRepository

Chain:
ProductsBloc needs → GetProductsUseCase
GetProductsUseCase needs → ProductsRepository  
ProductsRepository needs → ProductsRemoteDataSource
ProductsRemoteDataSource needs → SupabaseClient

GetIt automatically resolves this chain!

═══════════════════════════════════════════════════════════════
ORDER MATTERS:
═══════════════════════════════════════════════════════════════

Register from bottom to top (dependencies first):

1. External (Supabase) ← No dependencies
2. Data Sources ← Needs Supabase
3. Repositories ← Needs Data Sources  
4. Use Cases ← Needs Repositories
5. BLoCs ← Needs Use Cases

If you register in wrong order, you get error:
"Object/factory with type X is not registered"

═══════════════════════════════════════════════════════════════
WHY USE DEPENDENCY INJECTION?
═══════════════════════════════════════════════════════════════

✅ Easy to get objects anywhere: sl<ProductsBloc>()
✅ Easy to test (swap real with mock)
✅ Single source of truth for dependencies
✅ Automatic dependency resolution
✅ Clean code (no manual object creation)

═══════════════════════════════════════════════════════════════
USING DEPENDENCY INJECTION:
═══════════════════════════════════════════════════════════════

In your pages/widgets:

// Get BLoC
final productsBloc = sl<ProductsBloc>();

// Or with BlocProvider
BlocProvider(
  create: (context) => sl<ProductsBloc>(),
  child: ProductsListPage(),
)

// In routes (GoRouter)
GoRoute(
  path: '/products',
  builder: (context, state) => BlocProvider(
    create: (_) => sl<ProductsBloc>(),
    child: ProductsListPage(),
  ),
)

═══════════════════════════════════════════════════════════════
*/

// ============================================
// QUICK REFERENCE
// ============================================

/*
GET ANY REGISTERED OBJECT:

// Get ProductsBloc
final bloc = sl<ProductsBloc>();

// Get specific UseCase
final useCase = sl<GetProductsUseCase>();

// Get Repository  
final repo = sl<ProductsRepository>();

// Get Supabase
final supabase = sl<SupabaseClient>();

COMMON PATTERN IN PAGES:

class ProductsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductsBloc>()..add(LoadProducts()),
      child: Scaffold(...),
    );
  }
}
*/
