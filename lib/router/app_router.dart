import 'package:cripstory/pages/details_page.dart';
import 'package:cripstory/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final appRouterConfig = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/details/:assetId',
        builder: (context, state) => DetailsPage(
          assetId: state.pathParameters["assetId"]!
        ),
      ),
    ],
  );