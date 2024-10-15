import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/auth/signin/data/dataSources/signinDataSource.dart';
import 'package:qenan/features/auth/signin/data/repositories/signinRepository.dart';
import 'package:qenan/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:qenan/features/auth/signup/data/dataSources/signupDatasource.dart';
import 'package:qenan/features/auth/signup/data/repositories/signupRepository.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/guidelines/data/dataSources/guidelinesDataSource.dart';
import 'package:qenan/features/guidelines/data/repositories/guidelinesRepository.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_bloc.dart';
import 'package:qenan/features/home/data/dataSources/homeDataSource.dart';
import 'package:qenan/features/home/data/repositories/homeRepository.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/onboarding/splashScreen.dart';
import 'package:qenan/l10n/l10n.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final signupRepository = SignupRepository(SignupRemoteDatasource());
  final signinRepository = SigninRepository(SigninRemoteDataSource());
  final homeRepository = HomeRepository(HomeRemoteDataSource());
  final guidelinesRepository =
      GuidelinesRepository(GuidelinesRemoteDataSource());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LanguageBloc()..add(GetLanguage()),
          ),
          BlocProvider(
            create: (context) => SignupBloc(signupRepository),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => SigninBloc(signinRepository),
          ),
          BlocProvider(
            create: (context) => HomePageBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => CourseBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => SearchBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => ChangePasswordBloc(signinRepository),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => GuidelinesBloc(guidelinesRepository),
          ),
          BlocProvider(
            create: (context) => FeedbackBloc(guidelinesRepository),
          ),
          BlocProvider(
            create: (context) => LogoutBloc(signinRepository),
          ),
          BlocProvider(
            create: (context) => UpdateProfileBloc(signinRepository),
          ),
          BlocProvider(
            create: (context) => FilterBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => BundleBloc(homeRepository),
          ),
          BlocProvider(
            create: (context) => FetchFavoritesBloc(homeRepository),
          ),
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
          // BuildWhen
          buildWhen: (previous, current) =>
              previous.selectedLanguage != current.selectedLanguage,

          //Builder
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Qenan',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
                fontFamily:
                    state.selectedLanguage.value.toString().toLowerCase() ==
                            'am_amh'
                        ? 'NotoSansEthiopic'
                        : 'Inter',
                fontFamilyFallback: ['Inter'],
                useMaterial3: true,
              ),
              locale: state.selectedLanguage.value,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: BlocProvider(
                create: (context) =>
                    SignupBloc(SignupRepository(SignupRemoteDatasource())),
                child: const SplashScreen(),
              ),
            );
          },
        ));
  }
}
