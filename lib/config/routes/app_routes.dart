import 'package:life_goal/config/routes/app_route_constants.dart';
import 'package:life_goal/features/Main/presentation/pages/main_page.dart';
import 'package:life_goal/features/Settings/presentation/pages/settings_page.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/presentation/pages/create_habit.dart';
import 'package:life_goal/features/goals/presentation/pages/edit_habit_page.dart';
import 'package:life_goal/features/goals/presentation/pages/goals_page.dart';
import 'package:life_goal/features/goals/presentation/pages/good_habits.dart';
import 'package:life_goal/features/paywall/pages/paywall_page.dart';
import 'package:go_router/go_router.dart';
import 'package:life_goal/welcome/presentation/pages/onboarding_page.dart';
import 'package:life_goal/welcome/presentation/pages/user_goal_page.dart';

class AppRoutes {
  static final GoRouter appRouter = GoRouter(
    debugLogDiagnostics: true,
    //  extraCodec: HabitCodec(),
    routes: appRoutes,
  );
}

final appRoutes = <GoRoute>[
  GoRoute(
    name: RouteConstants.mainPageName,
    path: '/',
    builder: (context, state) {
      return const MainPage();
    },
    routes: [
      GoRoute(
        name: RouteConstants.settingsPageName,
        path: 'settings_page',
        builder: (context, state) {
          return const SettingsPage();
        },
      ),
      GoRoute(
        name: RouteConstants.goodHabitsPageName,
        path: 'good_habits',
        builder: (context, state) {
          return const GoodHabits();
        },
      ),
      // GoRoute(
      //   name: RouteConstants.tasksPageName,
      //   path: 'tasks',
      //   builder: (context, state) {
      //     return const GoalsPage();
      //   },
      // ),
      GoRoute(
        name: RouteConstants.newHabitPageName,
        path: 'new_habit',
        builder: (context, state) {
          return const CreateHabit();
        },
      ),
      GoRoute(
        name: RouteConstants.editHabitsPageName,
        path: 'edit_habit',

        builder: (context, state) {
          HabitModel habit = state.extra as HabitModel;

          return EditHabitPage(habit: habit);
        },
      ),

      GoRoute(
        name: RouteConstants.onboardingPageName,
        path: 'onboarding',
        builder: (context, state) {
          return const OnboardingPage();
        },
      ),
      GoRoute(
        name: RouteConstants.userGoalPageName,
        path: 'user_goal',
        builder: (context, state) {
          return const UserGoalPage();
        },
      ),
      GoRoute(
        name: RouteConstants.paywallPageName,
        path: 'paywall',
        builder: (context, state) {
          return const PaywallPage();
        },
      ),
    ],
  ),
];

// class AppRoutes {
//   static final GoRouter appRouter = GoRouter(
//     debugLogDiagnostics: true,
//     routes: appRoutes,
//     redirect: (context, state) {
//       final session = context.read<AuthBloc>().state.session;

//       // Check if the user is authenticated or not
//       if (session == null) {
//         // If not authenticated, redirect to AuthPage
//         if (state.matchedLocation != '/welcome_page') return '/welcome_page';
//       } else {
//         // If authenticated, redirect to HomePage
//         if (state.matchedLocation.startsWith('/welcome_page')) return '/';
//       }

//       // No redirection needed
//       return null;
//     },
//   );
// }

// final appRoutes = <GoRoute>[
  // GoRoute(
  //   name: RouteConstants.welcomePageName,
  //   path: '/welcome_page',
  //   builder: (context, state) {
  //     return const WelcomeAndAuthPage();
  //   },
  // ),
//   GoRoute(
//     name: RouteConstants.loaderPageName,
//     path: '/',
//     builder: (context, state) {
//       return const LoaderPage();
//     },
//     routes: [
      // GoRoute(
      //   name: RouteConstants.mainPageName,
      //   path: 'main_page',
      //   pageBuilder: (_, state) {
      //     return PageTransition(key: state.pageKey, child: const MainPage());
      //   },
      // ),
//       GoRoute(
//         name: RouteConstants.profileFormPageName,
//         path: 'profile_form',
//         pageBuilder: (_, state) {
//           return PageTransition(key: state.pageKey, child: const ProfileForm());
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.customerDetailsPage,
//         path: 'customer_details',
//         pageBuilder: (_, state) {
//           CustomerEntity order = state.extra as CustomerEntity;
//           return PageTransition(
//             key: state.pageKey,
//             child: CustomerDetailsPage(order: order),
//           );
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.editCustomerPageName,
//         path: 'edit_customer',
//         pageBuilder: (_, state) {
//           CustomerEntity currentCustomer = state.extra as CustomerEntity;
//           return PageTransition(
//             key: state.pageKey,
//             child: EditCustomerPage(currentCustomer: currentCustomer),
//           );
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.createOrderPage,
//         path: 'create_order',
//         pageBuilder: (_, state) {
//           return PageTransition(
//             key: state.pageKey,
//             child: const AddCustomerPage(),
//           );
//         },
//       ),
//       GoRoute(
//         name: RouteConstants.addProductPageName,
//         path: 'add_product',
//         pageBuilder: (_, state) {
//           return PageTransition(
//             key: state.pageKey,
//             child: const AddProductPage(),
//           );
//         },
//       ),
//       GoRoute(
//         name: RouteConstants.productsPageName,
//         path: 'products',
//         pageBuilder: (_, state) {
//           return PageTransition(
//             key: state.pageKey,
//             child: const ProductsPage(),
//           );
//         },
//       ),
//       GoRoute(
//         name: RouteConstants.salesMetricsPageName,
//         path: 'sales_metrics',
//         pageBuilder: (_, state) {
//           BusinessStatsEntity businessStat = state.extra as BusinessStatsEntity;
//           return PageTransition(
//             key: state.pageKey,
//             child: SalesMetrics(bussinessStat: businessStat),
//           );
//         },
//       ),
//       GoRoute(
//         name: RouteConstants.salesMetricsListPageName,
//         path: 'sales_metrics_list',
//         pageBuilder: (_, state) {
//           return PageTransition(
//             key: state.pageKey,
//             child: const SalesMetricsListPage(),
//           );
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.productDetailsPageName,
//         path: 'product_details',
//         pageBuilder: (_, state) {
//           ProductEntity product = state.extra as ProductEntity;
//           return PageTransition(
//             key: state.pageKey,
//             child: ProductDetailsPage(product: product),
//           );
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.generateReceitPage,
//         path: 'generate_receit',
//         pageBuilder: (_, state) {
//           ReceitModel receit = state.extra as ReceitModel;
//           return PageTransition(
//             key: state.pageKey,
//             child: GenerateCustomerReceit(receit: receit),
//           );
//         },
//       ),
//       //Settings
//       GoRoute(
//         name: RouteConstants.accountSettingsPageName,
//         path: 'account_settings',
//         pageBuilder: (_, state) {
//           return PageTransition(
//             key: state.pageKey,
//             child: const AccountSettingsPage(),
//           );
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.welcomeUserDataPageName,
//         path: 'welcome_user_data',
//         pageBuilder: (_, state) {
//           return PageTransition(
//             key: state.pageKey,
//             child: const WelcomeUserData(),
//           );
//         },
//       ),

//       GoRoute(
//         name: RouteConstants.payWallPageName,
//         path: 'pay_wall',
//         pageBuilder: (_, state) {
//           return PageTransition(key: state.pageKey, child: const Paywall());
//         },
//       ),
//     ],
//   ),
// ];
