// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/modules/add_battle_request/bindings/add_battle_request.dart';
import 'package:ia05_07_battlesearcher/app/modules/add_battle_request/views/add_battle_request_view.dart';

import 'package:ia05_07_battlesearcher/app/modules/edit_battle_request/bindings/edit_battle_request_binding.dart';
import 'package:ia05_07_battlesearcher/app/modules/edit_battle_request/views/edit_battle_request_view.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/bindings/home_binding.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/views/home_view.dart';
import 'package:ia05_07_battlesearcher/app/modules/login/bindings/login_binding.dart';
import 'package:ia05_07_battlesearcher/app/modules/login/views/login_view.dart';
import 'package:ia05_07_battlesearcher/app/modules/profile/bindings/profile_binding.dart';
import 'package:ia05_07_battlesearcher/app/modules/profile/views/profile_view.dart';
import 'package:ia05_07_battlesearcher/app/modules/register/bindings/register_binding.dart';
import 'package:ia05_07_battlesearcher/app/modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BATTLE_REQUEST,
      page: () => AddBattleRequestView(),
      binding: AddBattleRequestBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_BATTLE_REQUEST,
      page: () => EditBattleRequestView(),
      binding: EditBattleRequestBinding(),
    ),
  ];
}
